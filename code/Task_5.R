library(dplyr)

Health <- "data/Health/HealthCare.csv" %>% read.csv()

# output: power point deck with a few charts / tables / regression analyses to provide health care insights.
# question: how to improve health care
# hypotheses to test:
# 1. sleeping is more important to your health than exercise
# 2. living a stress free lifestyle has a major impact on your health as well

# change categories Physical Activity Level and sleep quality
# Sedentary = 1, Lightly Active = 2, Moderately Active = 3, or Very Active = 4
# Poor = 1, Fair = 2, Good = 3, or Excellent = 4,
# Stress level = high = bad


# need to define measure of health (BMI??)
# need to find out how to make presentation

# make scatter plot between
