import numpy as np
from scipy import io
import pandas as pd
import datajoint as dj
import seaborn as sns
import matplotlib.pyplot as plt

schema = dj.schema('cadwell2020', locals())


@schema
class CellsPerClone(dj.Lookup):
    definition = """
    # number of cells per clone

    n_per_clone                 : int # cells per clone
    """

    contents = [(60,)]


@schema
class SlabSize(dj.Lookup):
    definition = """
    # size of the column under consideration

    area                    : double    # sidelength of the slab in mm^2
    ---
    n_per_slab              : int       # number of neurons in a slab with sidelength^2 area
    area_type               : enum("square", "circle") # whether the area is computed from a circle or a square
    """

    contents = [
        (0.0871195 ** 2 * np.pi, 1908, "circle"),
    ]


@schema
class Layer(dj.Lookup):
    definition = """
    # presynaptic layers

    layer     : enum('L2/3', 'L4', 'L5') # presynaptic layers
    ---
    """

    contents = [('L2/3',), ('L4',), ('L5',)]

@schema
class Source(dj.Lookup):
    definition = """
    # data source
    
    source      : varchar(20) 
    ---  
    """

    contents = zip(['Cadwell2019', 'Yu2009'])



@schema
class Connection(dj.Manual):
    definition = """
    # connection probabilities based on raw data
    
    -> Source
    (pre_cell_layer) -> Layer
    (post_cell_layer) -> Layer
    ---
    k_rel               : smallint       # number of connected related pairs
    n_rel               : smallint       # total number of related pairs tested
    p_rel               : double         # related  connection probability
    k_unrel             : smallint       # number of connected unrelated pairs
    n_unrel             : smallint       # total number of  unrelated pairs tested
    p_unrel             : double         # unrelated connection probability
    """

    def fill(self):
        dat = io.loadmat('data/data_raw2018-12-19.mat')
        C_rel = dat['connR']
        N_rel = C_rel + dat['unconnR']
        C_unrel = dat['connU']
        N_unrel = C_unrel + dat['unconnU']
        for pre, krrow, nrrow, kurow, nurow in zip(['L2/3', 'L4', 'L5'], C_rel, N_rel, C_unrel, N_unrel):
            for post, kr, nr, ku, nu in zip(['L2/3', 'L4', 'L5'], krrow, nrrow, kurow, nurow):
                res = dict(pre_cell_layer=pre,
                                  post_cell_layer=post,
                                  p_rel=kr / nr,
                                  p_unrel=ku / nu,
                                  k_rel=kr,
                                  k_unrel=ku,
                                  n_rel=nr,
                                  n_unrel=nu,
                                  source='Cadwell2019'
                                  )
                self.insert1(res, skip_duplicates=True)

                res['k_rel'] = 65
                res['n_rel'] = 179
                res['p_rel'] = 65 / 179

                res['k_unrel'] = 13
                res['n_unrel'] = 216
                res['p_unrel'] = 13 / 216
                res['source'] = 'Yu2009'
                self.insert1(res, skip_duplicates=True)



@schema
class LayerDistribution(dj.Lookup):
    definition = """
    # distribution of the cells across the layers

    layername           : varchar(40)  # name of the layer
    ---
    p_layer             : double       # fraction of the cells in that layer
    """

    contents = [('L2/3', .35), ('L4', .15), ('L5', .25)]


@schema
class PPickSister(dj.Computed):
    definition = """
    # probability to randomly pick a sister cell

    ->CellsPerClone
    ->SlabSize
    ---
    p_pick_sister     : double # probability to randomly draw a sister cell
    """

    def _make_tuples(self, key):
        self.insert1(dict(key, p_pick_sister=key['n_per_clone'] / (SlabSize() & key).fetch1('n_per_slab')))


@schema
class ExpectedSisterInput(dj.Computed):
    definition = """
    # expected input from one layer to another given relation status

    -> PPickSister
    -> Connection
    ---
    p_sis                   : double # proportion of sister cells in the expected input to a cell
    p_sis_se                : double # standard error of p_sis
    p_sis_sim               : double # simulated p_sis
    p_sis_se_sim            : double # simulated p_sis_se
    p_sis_ci_sim            : double # simulated 95 percent confidence intervall
    """

    def make(self, key):
        ps, ns, pc, nc = (Connection() & key).fetch1('p_rel', 'n_rel', 'p_unrel', 'n_unrel')

        vePS = ps * (1 - ps) / ns
        vePC = pc * (1 - pc) / nc

        q = (PPickSister() & key).fetch1('p_pick_sister')

        # -----------compute numbers for layer-----------------
        p_conn_sister = ps * q
        p_conn_nonsister = (1 - q) * pc

        pm = p_conn_sister + p_conn_nonsister  # marginal connection probability

        if pm > 0:
            key['p_sis'] = p_conn_sister / pm
            F = np.array([
                [-pc * q * (q - 1) / (pc * (q - 1) - ps * q) ** 2],
                [ps * q * (q - 1) / (pc * (q - 1) - ps * q) ** 2]
            ])
            S = np.diag([ps * (1 - ps) / ns, pc * (1 - pc) / nc])
            key['p_sis_se'] = np.sqrt(np.dot(F.T, np.dot(S, F))[0, 0])

            # simulate (these values will very likely be larger;
            # vague reason: Jensen on 1/(1+p1/p2)
            ks = np.random.binomial(ns, ps, 1000000)
            kc = np.random.binomial(nc, pc, 1000000)
            ps = ks / ns
            pc = kc / nc
            p_conn_nonsister = (1 - q) * pc
            p_conn_sister = ps * q
            pm = p_conn_sister + p_conn_nonsister
            idx = pm > 0
            p_sis = p_conn_sister[idx] / pm[idx]
            key['p_sis_sim'] = p_sis.mean()
            key['p_sis_se_sim'] = p_sis.std(ddof=1)
            key['p_sis_ci_sim'] = np.percentile(np.abs(p_sis-p_sis.mean()), 95)

        else:
            key['p_sis'] = 0
            key['p_sis_se'] = 0
            key['p_sis_sim'] = 0
            key['p_sis_se_sim'] = 0
            key['p_sis_ci_sim'] = 0

        self.insert1(key)

