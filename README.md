# rrf-training-2023

Based on the Ookla database, an analysis of certain sectors of the Colombian economy was carried out. 


We have a database of connection speed and infrastructure of the different regions of Colombia.

If you want to see the code execution please download all 5 scripts in R language including the main menu. 

#main_script
The main script executes the codes and defines the input and output data folder. 

#Template-R-01-tidying-secondary
The first scrip models the data giving it the right shape for the development process. 

#Template-R-02-cleaning-secondary
The second scrip clears the data of inconsistencies and removes outliers. 

#Template-R-03-construction-secondary
The third, generates the different databases to be analyzed, generating a combination of internet connection base and infrastructure at the level of municipality and region, of the different zones of Colombia. 

#Template-R-04-analysis-secondary
The fourth scrip generates the analysis using scatter plots, histograms, and multiple regression types, as well as a correlation analysis. 

#Details 
Details to review, are the input and output data paths, the codes in certain parts of the analysis are not finished, if you want to add them we would appreciate the support.
#Remember 
Remember to install these packages and others defined in the scrips
install.packages("here")
install.packages("renv")
install.packages("dplyr")
install.packages("pacman")
library(here)
library(tidyverse)
