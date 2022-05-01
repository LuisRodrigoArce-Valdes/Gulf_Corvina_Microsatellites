May 01, 2022
## This repository contains all the input files and analyses done with microsatellite data for the article: "No effects of fishery collapse on the genetic diversity of the Gulf of California Corvina, Cynoscion othonopterus (Perciformes: Sciaenidae)"

### By Arce-Valdés LR, Abadía-Cardoso A, Arteaga MC, Peñaranda-González LV, Ruiz-Campos G & Enríquez-Paredes LM

### Raw data
Raw microsatellite reads are found in the file `00_Binning/0_Base_de_Datos.xlsx`. From there all subsecuent analyses are order. First the binning trough the files in the `00_Binning/` directory and from there all analyses are numbered on each directory.

### Repository structure

This repository is divided in several directories, each numbered in the way analyses were made. Note that all input files were created in the `01_CREATE/` directory. From there input files were copied to the repository in which they were used.

+ `00_Binning/`: Allele binning with Flexibin and Autobin macros.
+ `01_CREATE/`: Input file creation for all the software used.
+ `02_MicroChecker/`: Checking for null alleles and other scoring problems.
+ `03_Structure/`: Tests for hidden population genetic structure.
+ `04_GenAlex/`: Estimations of genetic diversity.
+ `05_GenePop/`: Tests for HW disequilibrium.
+ `06_MRatio/`: MRatio recent bottleneck test.
+ `07_Bottleneck/`: Heterozygosity excess and mode shift recent bottleneck tests.
+ `08_NeEstimator/`: Estimation of Ne via linkage disequilibrium.
+ `09_MsVar/`: Demographic inference using coalescent MsVar.
+ `10_DIYABC/`: Demographic simulations using aproximate bayesian computation with DIAYBC.
+ `11_Migraine/`: Maximum likelihood inference of Ne.