#---------------------------------------------------------#
#Project name: Data Analysis Project 
#Description: 
#Data Analisys project
#
#Date: 
#Autor: Gabriel Oqueli 
#--------------------------------------------------#
install.packages("here")
install.packages("renv")
install.packages("dplyr")
install.packages("pacman")
library(here)
library(tidyverse)

##add in the terminal create#
##git init
##git remote add origin https://github.com/GabOqueli-16062022/rrf-training-2023.git
##git branch -M main 
#path <- here("rrf-training-2023", "data", "data-file.csv")
#####Main script######
source(here("scripts", "Template-R-01-tidying-secondary.R"))
source(here("scripts", "Template-R-02-cleaning-secondary.R")) 
source(here("scripts", "Template-R-03-construction-secondary.R")) 
source(here("scripts", "Template-R-04-analysis-secondary.R")) 

#git add .
#git commit -m
#"Feature: setting data workfl ow environment"
#git push -u origin main
