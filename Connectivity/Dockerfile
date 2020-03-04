FROM datajoint/datajoint

RUN apt-get -y update && \
    apt-get -y install graphviz

RUN pip install jupyterlab && \
    jupyter serverextension enable --py jupyterlab --sys-prefix

RUN pip install statsmodels


WORKDIR /notebooks

RUN mkdir -p /scripts
ADD ./jupyter/run_jupyter.sh /scripts/
ADD ./jupyter/jupyter_notebook_config.py /root/.jupyter/
RUN chmod -R a+x /scripts
ENTRYPOINT ["/scripts/run_jupyter.sh"]
