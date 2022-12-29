December 06, 2022
## This repository contains all the input files and analyses done with microsatellite data for the article: "No effects of fishery collapse on the genetic diversity of the Gulf of California Corvina, Cynoscion othonopterus (Perciformes: Sciaenidae)"

### By Arce-Valdés LR, Abadía-Cardoso A, Arteaga MC, Peñaranda-González LV, Ruiz-Campos G & Enríquez-Paredes LM

### Raw data
Raw microsatellite reads are found in the file `01_Binning/0_Base_de_Datos.xlsx`. From there all subsecuent analyses were done as files are ordered. First the binning trough the files in the `01_Binning/` directory and from there all analyses are numbered on each directory.

### Repository structure

This repository is divided in four main directories, each numbered in the way analyses were made. Inside each directory analyses are placed each on their own subdirectory and they are ordered as they were done. Each main directory begins with a CREATE directory in which input files were made. Then each input file was used on the correspoding subdirectory. 


+ `01_Binning/`: Allele binning with Flexibin and Autobin macros.
+ `02_QualityControl/`: Testing several quality filters on microsatellite data.
	+ `02_QualityControl/01_CREATE/`: Input file creation for all the software used.
	+ `02_QualityControl/02_MicroChecker/`: Checking for null alleles and other scoring problems.
	+ `02_QualityControl/03_GenePop_HW/`: Testing for Hardy-Weinberg disequilibrium on each locus.
	+ `02_QualityControl/04_GenePop_LD/`: Pairwise tests for linkage disequilibrium between loci.
	+ `02_QualityControl/05_PyPop/`: Neutrality tests per locus.
	+ `02_QualityControl/06_QualitySummary/`: Excel file with control quality results.
+ `03_Nulls10/`: Population genetics analyses on the dataset including microsatellites with null alleles frequencies > 0.10.
+ `04_NoNulls/`: Population genetics analyses on the dataset without microsatellites with null alleles frequencies > 0.10.

Each of the two previous directories contains the same subdirectories on each doing a specific analysis included in the final manuscript.
	+ `03_Nulls10 & 04_NoNulls/01_CREATE/`: Input file creation for all the software used.
	+ `03_Nulls10 & 04_NoNulls/02_GenAlex/`: Summary Statistics of Genetic Diversity.
	+ `03_Nulls10 & 04_NoNulls/03_Structure/`: Tests for hidden genetic structure.
	+ `03_Nulls10 & 04_NoNulls/04_MRatio/`: GarzaAndWilliamson 2001 original M ratio test.
	+ `03_Nulls10 & 04_NoNulls/05_Bottleneck/`: Bottleneck tests.
	+ `03_Nulls10 & 04_NoNulls/06_NeEstimator/`: Ne estimation via LD.
	+ `03_Nulls10 & 04_NoNulls/07_DIYABC/`: Aproximate bayesian coalescence simualtions for demographic inference.
	+ `03_Nulls10 & 04_NoNulls/08_Migraine/`: Maximum Likelihood estimation of Ne.
	+ `03_Nulls10 & 04_NoNulls/09_MsVar/`: Bayesian coalescence demographic inference.
	+ `03_Nulls10 & 04_NoNulls/10_InEst/`: Model testing for significant inbreeding.
	
Finally we have included an Excel file with generation time estimations:
+ `GenerationTime.xlsx`