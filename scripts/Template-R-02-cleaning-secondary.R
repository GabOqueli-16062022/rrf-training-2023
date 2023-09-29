# Cleaning data - R - secondary sources - template
# Load necessary packages --------------------------
#install.packages("pacman")

packages <- c("tidyr", 
              "dplyr", 
              "labelled", 
              "stringi", 
              "Hmisc")

pacman::p_load(packages,
               character.only = TRUE,
               install = FALSE) # Change to TRUE to install the necessary packages

# Set path of our data 

# Set folder path to where you downloaded the data
tidy_folder <- "C:/Users/minis/Documents/rrf-training-2023/data"

# Exercise 1 part 1 ---------------------------------------

# Step 0: Read data

# Read the connectivity data from your CSV file
# ...
connectivity_decleaned <- read.csv(file.path(tidy_folder, "colombia_connectivity_decleaned.csv")) 

# Step 1: Remove duplicate entries
# Identify and remove duplicate rows in your data
# ...
connectivity_decleaned <- connectivity_decleaned %>% distinct()
only_duplicates <- connectivity_decleaned %>%
  

# Step 2: Ensure there is at least one identifying variable in the data
# Verify that your data has at least one identifying variable
#.....
connectivity_clean <- connectivity_decleaned %>%
  select(-id_test_data)
# Step 3: Encode choice questions and ensure correct data types
# Check data types of different columns and modify them if necessary
# ...
#data_type <- sapply(connectivity_clean, class)
#data_type

# Step 4: Handle missing values
# Handle rows and columns with missing values in a way that suits your analysis
# ...
connectivity_clean <- connectivity_clean %>%
  na.omit(connectivity_clean)

connectivity_clean <- connectivity_clean %>%
  mutate(avg_u_kbps = as.numeric(avg_u_kbps), 
         tests = as.numeric(tests))


# Step 5: Drop data collection metadata variables not needed for analysis
# Remove unnecessary columns from your dataset
# ...
connectivity_clean <- connectivity_clean %>%
  rowwise()%>%
  filter(!all(is.na(c(avg_d_kbps, avg_u_kbps, avg_lat_ms, tests, devices)))) %>%
  ungroup()
# Step 6: Ensure all variables have English names and no special characters
# Standardize the column names by removing special characters
# ...
connectivity_clean <- connectivity_clean %>%
  mutate(ADM1_ES = stringi::stri_trans_general(ADM1_ES, "Latin-ASCII"),
         ADM2_ES = stringi::stri_trans_general(ADM2_ES, "Latin-ASCII")
         )
# Step 7: Adding variable labels
# Add descriptive labels to your variables with a maximum of 80 characters each
# ...
#connectivity_clean <- connectivity_clean %>%
 # set_variable_labels(
  #  quadkey = ""
    
    
  #)

# View the clean data
# Preview your cleaned data
# ...

# Exercise 1 part 2 ---------------------------------------

# Metadata
# Step 0: Get data type and labels for each column
# Get the class/type and labels of each column in your cleaned data
# ...

#column_classes <- sapply(connectivity_clean, class)

# Step 1: Create a data frame for the codebook
# Create a codebook data frame using the info gathered in the previous step
# ...

# Step 2: Save the cleaned data and the codebook
# Save your cleaned data and the codebook as CSV files
# ...
