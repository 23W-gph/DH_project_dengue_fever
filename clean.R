# About this script
# Purpose: Examination
# Author name: Anna Wedler
# Student ID: 22306466
# Study programme: MSc Global Health
# Module: Digital Health
# Semester: Winter semester 2023/2024
# Task: Data visulaization of a self-chosen Public Health problem
# Title: Dengue fever in Bangladesh

#install and load packages
install.packages("pacman")
pacman::p_load(readr,
               rio,
               here,
               tidyverse,
               dplyr,
               plotly,
               janitor,
               ggplot2)

#import, load, and prepare data (set columns where no complex mutation needed)
library(readr)
dengue_data <- read_csv(
  here("data", "dataset.csv"),
  name_repair = "universal",
  col_types = cols(
    Gender = col_factor(levels = c("Female", "Male")), 
    Age = col_integer()), 
)

#View data
View(dengue_data)   

#Transform data-----------------------------------------------------
dengue_data <- dengue_data %>%
  
  #clean column names
  clean_names() %>% 
  
  #mutate data
  mutate(
    across(c(area, area_type, house_type), as.factor),
    outcome = as.logical(outcome)
  ) %>% 
  
  #Remove duplicates
  distinct()

#Create subset table with relevant data 
dengue_infr <- subset(dengue_data, outcome == 1, select = c(area, outcome, area_type, house_type))

#Review new data frame 
print(dengue_infr)

#Create interactive bar chart for shiny app
