# Construction - R - secondary sources
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

# read data 

# from cleaned
colombia_connectivity_clean <- read.csv(file.path(tidy_folder, 
                                                  "colombia_connectivity_cleaned.csv"))

# from tidying  
colombia_infraestructure_clean <- read.csv(file.path(tidy_folder,
                                               "colombia_infrastructure_cleaned.csv"))


##### Task 1  --------------------------
# Plan construct outputs
# Add your code here to plan how to construct the outputs
#How many analysis data sets will you have to create?
#R: Just one merge of colombia_connectivity_cleaned and colombia_infrastructure_cleaned  
#What are the unit of observations in each of them?
#R:Unit of observation: municipalities and state.  
#

##### Task 2  --------------------------
# Standardize units
# Add your code here to standardize units from KB to MB
#colombia_connectivity_clean$avg_d_mbps <- colombia_connectivity_clean$avg_d_kbps/1000
#colombia_connectivity_clean$avg_u_mbps <- colombia_connectivity_clean$avg_u_kbps/1000

colombia_connectivity_const <- colombia_connectivity_clean %>%
  mutate(avg_u_mbps = avg_u_kbps/1000, 
         avg_d_mbps = avg_d_kbps/1000
         )

##Drop original variable 
colombia_connectivity_const <- colombia_connectivity_const %>%
  select(-avg_d_kbps, -avg_u_kbps)

##### Task 3  --------------------------
# Handle outliers 
# - Visual identification of outliers through plots
ggplot(colombia_connectivity_const, aes(y = "avg_u_mbps" )) +
  geom_boxplot() +
  facet_wrap(~trimester)

ggplot(colombia_connectivity_const, aes(y = "avg_d_mbps" )) +
  geom_boxplot() +
  facet_wrap(~trimester)
# - Define a function to handle outliers
# Define the function
#
winsor_function <- function(dataset, var, min = 0.00, max = 0.99){
  var_sym <- sym(var)
  
  percentiles <- quantile(
    dataset %>% pull(!!var_sym), probs = c(min, max), na.rm = TRUE
  )
  
  min_percentile <- percentiles[1]
  max_percentile <- percentiles[2]
  
  dataset %>%
    mutate(
      !!paste0(var, "_winsorized") := case_when(
        is.na(!!var_sym) ~ NA_real_,
        !!var_sym <= min_percentile ~ percentiles[1],
        !!var_sym >= max_percentile ~ percentiles[2],
        TRUE ~ !!var_sym
      )
    )
}
# - Apply the function to your dataset
colombia_connectivity_const <- winsor_function(dataset = colombia_connectivity_const, var = "avg_u_mbps")
colombia_connectivity_const <- winsor_function(dataset = colombia_connectivity_const, var = "avg_d_mbps")

hist(colombia_connectivity_const$avg_u_mbps, main= "Before Winsorization", xlab= "Variabke Value")
hist(colombia_connectivity_const$avg_u_mbps_winsorized, main= "After Winsorization", xlab= "Variabke Value")

hist(colombia_connectivity_const$avg_d_mbps, main= "Before Winsorization", xlab= "Variabke Value")
hist(colombia_connectivity_const$avg_d_mbps_winsorized, main= "After Winsorization", xlab= "Variabke Value")

##### Task 4  --------------------------
# Create indicators
# - Create a state database
# - Create a municipality database
state_connetivity <- colombia_connectivity_const %>%
  dplyr::group_by( ADM0_PC, ADM0_ES, ADM1_PC,ADM1_ES, trimester) %>%
  dplyr::summarize(
        
            avg_u_mbps = mean(avg_u_mbps, na.rm = TRUE),
            avg_d_mbps = mean(avg_d_mbps, na.rm = TRUE), 
            avg_u_mbps_winsorized = mean(avg_u_mbps_winsorized, na.rm = TRUE),
            avg_d_mbps_winsorized = mean(avg_d_mbps_winsorized, na.rm = TRUE),
            
            tests = max(tests, na.rm = TRUE)
            )%>%
arrange(ADM1_PC)%>%
  ungroup()

state_infrastructure <- colombia_infraestructure_clean %>%
  dplyr::group_by(ADM0_PC, ADM0_ES, ADM1_PC, ADM1_ES)%>%
  dplyr::summarise(across(college:hospital, ~sum(.x, na.rm = TRUE)))%>%
  ungroup()

state_database <- state_connetivity %>%
  dplyr::left_join(state_infrastructure) %>%
  dplyr::group_by(ADM0_PC, ADM0_ES, ADM1_PC, ADM1_ES)%>%
  arrange(trimester, ADM1_PC)%>%
  mutate(
    avg_u_mbps_change = avg_u_mbps_winsorized/dplyr::lag(avg_u_mbps_winsorized)-1,
    avg_d_mbps_change = avg_d_mbps_winsorized/dplyr::lag(avg_d_mbps_winsorized)-1,
  ) %>%
  mutate(across(college:hospital, -replace_na(.x, 0)))%>%
  arrange(ADM1_ES) %>%
  #ungroup()

###municipality
municipality_connetivity <- colombia_connectivity_const %>%
  dplyr::group_by( ADM0_PC, ADM0_ES, ADM1_PC,ADM1_ES, ADM2_PC, ADM2_ES , trimester) %>%
  dplyr::summarize(
    avg_u_mbps = mean(avg_u_mbps, na.rm = TRUE),
    avg_d_mbps = mean(avg_d_mbps, na.rm = TRUE), 
    avg_u_mbps_winsorized = mean(avg_u_mbps_winsorized, na.rm = TRUE),
    avg_d_mbps_winsorized = mean(avg_d_mbps_winsorized, na.rm = TRUE),
    
    tests = max(tests, na.rm = TRUE),
    devices = sum(devices, na.rm = TRUE)
  )%>%
  arrange(ADM2_PC)%>%
  ungroup()

municipality_infrastructure <- colombia_infraestructure_clean %>%
  group_by( ADM0_PC, ADM0_ES, ADM1_PC,ADM1_ES, ADM2_PC, ADM2_ES) %>%
  summarise(across(college:hospital, ~sum(.x, na.rm = TRUE)))


##### Task 5  --------------------------
# Save the final datasets
# - Remove unnecessary variables
# - Save the datasets as CSV files
