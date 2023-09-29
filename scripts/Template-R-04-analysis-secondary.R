# Analysis - R - secondary sources Template
# Load necessary packages --------------------------

# install.packages("pacman")

packages <- c("tidyr", 
              "dplyr", 
              "ggplot2", 
              "corrplot", 
              "stargazer", 
              "gt", 
              "plm", 
              "lmtest")

pacman::p_load(packages,
               character.only = TRUE,
               install = FALSE) # Change to TRUE to install the necessary packages

# Set path of our data 

# Set folder path to where you downloaded the data
tidy_folder <- "C:/Users/minis/Documents/rrf-training-2023/data"
# read data 

municipality_database <- read.csv(file.path(tidy_folder,
                                            "municipality_database.csv"))

state_database <- read.csv(file.path(tidy_folder,
                                     "state_database.csv"))

# -------------
# Task 1: Create Summary Statistics
# -------------

# In this task, generate summary statistics for both municipality and state databases.

# You can use summary() function, here is another more customized option. 

summary_stats <- municipality_database %>%
  # only numeric variables 
  summarise(across(avg_d_mbps_winsorized:avg_u_mbps_change, list(mean = ~mean(.x, na.rm = TRUE), 
                                                                 sd = ~sd(.x, na.rm = TRUE), 
                                                                 cilower = ~quantile(.x, 0.025, na.rm = TRUE), 
                                                                 ciupper = ~quantile(.x, 0.975, na.rm = TRUE)))) %>%
  pivot_longer(cols = everything(),
               names_to = c("Statistic", "Variable"),
               values_to = "value", 
               names_sep = "_(?=[^_]+$)") %>% 
  pivot_wider(names_from = Variable) %>% 
  rename(Mean = "mean", SD = "sd", `95% CI Lower` = "cilower", `95% CI Upper` = "ciupper")


summary_stats_state <- state_database %>%
  # only numeric variables 
  summarise(across(avg_d_mbps_winsorized:avg_u_mbps_change, list(mean = ~mean(.x, na.rm = TRUE), 
                                                                 sd = ~sd(.x, na.rm = TRUE), 
                                                                 cilower = ~quantile(.x, 0.025, na.rm = TRUE), 
                                                                 ciupper = ~quantile(.x, 0.975, na.rm = TRUE)))) %>%
  pivot_longer(cols = everything(),
               names_to = c("Statistic", "Variable"),
               values_to = "value", 
               names_sep = "_(?=[^_]+$)") %>% 
  pivot_wider(names_from = Variable) %>% 
  rename(Mean = "mean", SD = "sd", `95% CI Lower` = "cilower", `95% CI Upper` = "ciupper")

# Task 1: Create Summary Statistics ------------------------

# For Municipality
# Note: Use dplyr functions such as summarise and across to calculate summary statistics like mean, sd, etc.
# ....
# Use gt package to create nice looking tables.
# ....

summary_stats %>%
  gt()%>%
  tab_header(title = "Infraestructure and connectivity in colombia by Municipality") %>%
  fmt_number(decimals = 2) %>%
  gtsave(filename = file.path(tidy_folder, "summary_stats_municipality.html"))

# For State
# Note: Similarly, create summary statistics for the state database
# ....
summary_stats_state %>%
  gt()%>%
  tab_header(title = "Infraestructure and connectivity in colombia by State") %>%
  fmt_number(decimals = 2) %>%
  gtsave(filename = file.path(tidy_folder, "summary_stats_state.html"))

# Task 2: Visualization of Individual Variables ------------

# Histogram
# Note: Use ggplot2 package to create histograms. Use geom_histogram() function for histograms.
# ....
state_connetivity_histogram <- state_connetivity %>%
  select(avg_u_mbps,avg_u_mbps_winsorized)%>%
  pivot_longer(cols = everything()) %>%
  ggplot(aes(x = value))+
  geom_histogram(bins = 30)+
  facet_wrap(~ name, scales = "free_x")+
  labs(
    title = "Diference of uplode",
    x = "Variable",
    y = "Frequency", 
  )+
theme_minimal()
ggsave(filename = file.path(tidy_folder, "Diference of uplode.png"))

# Boxplot
# Note: Use geom_boxplot() function to create box plots.
# ....
state_infrastructure_boxplot <- state_database %>%
  select(college:hospital)%>%
  pivot_longer(cols = everything()) %>%
  ggplot(aes(x = name, y = value, fill= name))+
  geom_boxplot()+
  labs(
    title = "Boxplot of Social Infrastrcuture",
    x = "Variable",
    y = "Number", 
  )+
  scale_fill_brewer(palette = "Set3")+
  theme_minimal()
ggsave(filename = file.path(tidy_folder, "Boxplot of Social Infrastrcuture.png"))
# Save the plots using ggsave()
# ....

# Task 3: Regression Analysis ------------------------

# Building Simple Linear Regression Model
# Note: Use lm() function to create a linear model. Use summary() function to get a summary of the model.
# ....
model1 <- lm(avg_d_mbps_winsorized ~ school + trimester, data = municipality_database)
summary(model1)
# Building Panel Data Model
# Note: Use pdata.frame() to create a panel data frame and use plm() function for panel data models.
# ....
pdata <- pdata.frame(municipality_database, index = c("ADM2_PC", "trimester"))
model_panel <- plm(avg_d_mbps_winsorized ~ school, data = pdata, model = "pooling"  )
summary(model_panel)
# Multiple Regression Model with Clustered Standard Errors
# Note: Use plm() function to build the model and vcovHC() and coeftest() functions to get clustered standard errors.
# ....
model2 <- plm(avg_d_mbps_winsorized ~ school + hospital, data = pdata, model = "pooling"  )
summary(model2)

clustered_se <- vcovHC(model2, type = "HC3", cluster = "group", group = pdata$ADM1_PC)
coeftest(model2, vcov. = clustered_se)

# Save the model using stargazer
# Note: Use the stargazer package to create a neat table of your regression results. 
# Set different parameters in the stargazer function to customize the table according to your needs.
# ....
stargazer(model1, model_panel, model2, 
          type = "html",
          out = file.path(tidy_folder, "regression.html"),
          title = "Regression Result"
  
)
# Task 4: Visual Analysis ------------------------

# Relationship Analysis
# Note: Use ggplot2 for scatter plots and add trend lines using geom_smooth() function. 
# Analyze the relationship between different variables visually.
# ....

# Change in Connectivity Analysis
# Note: Use ggplot2 to create a bar plot to visualize changes in connectivity. 
#You can use dplyr functions like filter, group_by, and summarize to process the data before plotting.
# ....

# Task 5: Correlation Analysis ------------------------

# Note: Use cor.test() function to perform correlation tests. Use cor() function to create a correlation matrix.
# ....

# Visualize the correlation matrix
# Note: Use corrplot() function from corrplot package to visualize the correlation matrix.
# ....
