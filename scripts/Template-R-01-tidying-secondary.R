# Tidying data - R - secondary sources - template
# Load necessary packages --------------------------

# install.packages("pacman")

packages <- c("tidyr", 
              "dplyr")

pacman::p_load(packages,
               character.only = TRUE,
               install = FALSE) # Change to TRUE to install the necessary packages

# Set path of our data 

# Set folder path to where you downloaded the data
tidy_folder <- "C:/Users/minis/Documents/rrf-training-2023/data"
# Exercise 1 ---------------------------------------

# Step 1: Read the wide format data

connectivity_wide <- read.csv(file.path(tidy_folder, "colombia_connectivity_wide.csv")) 

# Step 2: Remove duplicates 
##Compare all area
connectivity_wide <- connectivity_wide %>% distinct()

##connectivity_wide_unique <- distinct(connectivity_wide, .keep_all = FALSE)

# Step 3: Reshape data

connectivity_long <- connectivity_wide %>%
pivot_longer(cols = ends_with(c("_01", "_04")),
             names_to = c(".value", "trimester"),
             names_pattern = "(.+)_(\\d+)",
             values_to = ".value"
             )

# Step 4: Verify your dataset has the desired structure
View(connectivity_long)
write.csv(connectivity_long, file.path(tidy_folder,"connectivity_long.csv"),row.names = FALSE)
##yeah
# Exercise 2 ----------------------------

# Step 1: Read the long format data for infrastructure 
infrastructure_long <- read.csv(file.path(tidy_folder,
                                          "colombia_infrastructure_lng.csv"))

# Step 2: Explore the data 
View(infrastructure_long)
  
# Step 3: Reshape the data. 
?pivot_wider
infrastructure_wide <- infrastructure_long %>%
pivot_wider(names_from = "amenities",  
            values_from = "value"
)
View(infrastructure_wide)

write.csv(infrastructure_wide, file.path(tidy_folder, "infrastructure_long.csv"),row.names = FALSE)
# Challenges  --------------------------

##### Part 1: municipality with more download speed


# rest of the exercise 


##### Part 2: municipality with more educational institutions 
#highest_education_wide <- infrastructure_wide %>%
 # mutate(edu_facilities = rowSums(select(., school, college, university), 
   #                               na.rm = TRUE
    #                              ))%>%
  #arrange(-edu_facilities)
# rest of the exercise 
#highest_education_long <- infrastructure_long %>%
