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

For quantitative analysis of clones and connectivity data, we used the [DataJoint](https://github.com/datajoint) data management framework implemented in Matlab, which utilizes a relational database model for organizing, populating, and querying data.  

Analysis of gene expression data was performed using packages previously developed in R Bioconductor.

Modeling of the cortical circuit was done in Python.

For efficiency, the data were also stored at different stages of analysis as .mat or .csv files. 

Individual analysis steps
-------------------------

###

###

DataJoint database structure
--------------------------------

### Schema `mc`

The following tables are most relevant:

* `PatchCells`

