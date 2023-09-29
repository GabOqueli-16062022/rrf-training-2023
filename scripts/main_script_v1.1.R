#---------------------------------------------------------#
#Project name: Data Analysis Project 
#Description: 
#Data Analisys project
#
#Date: 
#Autor: Gabriel Oqueli 
#--------------------------------------------------#
install.packages("pacman")

packages <- c("tidyr", 
              "dplyr", 
              "labelled",
              "stringi",
              "Hmisc",
              "stringr")
pacman::p_load(packages, 
               character.only = TRUE, 
               install =TRUE)

##add in the terminal#
##git init
##git remote add origin https://github.com/GabOqueli-16062022/rrf-training-2023.git
##git branch -M main 


source(here("scripts", "Template-R-01-tidying-secondary.R"))
source(here("scripts", "Template-R-02-cleaning-secondary.R")) 
source(here("scripts", "Template-R-03-construction-secondary.R")) 
source(here("scripts", "Template-R-04-analysis-secondary.R")) 

#git add .
#git commit -m
#"Feature: setting data workfl ow environment"
#git push -u origin main
