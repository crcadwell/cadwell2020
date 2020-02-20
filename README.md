Overview
========

This repository contains the Matlab, R and Python code used to analyze data and generate figures in Cadwell et al., _Cell type composition and circuit organization of clonally related excitatory neurons in the juvenile mouse neocortex_, eLife (2020). 

License
=======

Copyright 2020 C. R. Cadwell

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
   
General Organization of the Code
================================

For quantitative analysis of clones and connectivity data, we used the Matlab implementation of [DataJoint](https://github.com/datajoint), which utilizes a relational database model for organizing, populating, and querying data. The DataJoint schemas are archived at atlab/commons and the critical tables for our analyses are described below.  

Analysis of gene expression data was performed in R Bioconductor using custom software and previously developed packages including `scran`.

Modeling of the cortical circuit was done in Python using Jupyter Notebook.

For efficiency, the data were also stored at different stages of analysis as .mat or .csv files. 

Individual analysis steps
-------------------------

### Reconstruction of clones across slices (analyses used for Figure 1)
Tile scan Z-stacks of entire coronal sections were first maximially projected using the commercial acquisition software for the microscope. The positions of labeled cells were annotated using the following Matlab-based custom software:
* `Segmentation.m` This code selects one maximally projected coronal section at a time, and has the user  manually outline the contours of the cortex, and mark the positions of cortical neurons by presenting small patches of the cortex area. The positions of annotated cortical neurons are saved to a separate file.  
* `showImages.m` This code shows all annotated coronal sections for an entire mouse brain, including the outlines of the cortex and positions of the neurons identified above. The user can scroll through the slices to see how individual clones appear on adjacent sections.
* `CountCells.m` While active, this code will count the number of annotated neurons within an area selected by the user, while viewing an annotated coronal section. 

###

DataJoint database structure
--------------------------------

### Schema `mc`

The following tables are most relevant:

* `PatchCells`

