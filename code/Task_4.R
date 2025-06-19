# load packages
library(dplyr)

# load data
Billions <- read.csv("data/Billions/billionaires.csv")

# visualize share of selfmade billionaires on total millionaires USA vs. emerging economies

analysis <- Billions %>%
    mutate(USA_Check == if(location.country.code == "USA"; TRUE, FALSE,
           Selfmade_Check == if(wealth.how.inherited == "not inherited"; TRUE, FALSE)) %>%
    group_by(year, USA_Check) %>%
    summarise(Selfmade_Share = sum())

source("code/Bar_Plot.R")
bar_plot(analysis, "year", "Selfmade_Share", "USA_Check")

# or some other graph on inherited vs. non-inherited wealth in USA vs. remainder of world (e.g. bubble chart)
# write function


## "Most new self-made millionaires are in software, compared to consumer services type industries in the 90s"
# need filter for selfmade_check = TRUE
# make bar chart with three areas on x axis for different points in time and % of billionaires on y axis
# bars show wealth.how.industry classification

## "This is related to different countries’ GDP, of course, with richer countries providing more innovation in consumer services"
# want to make regression
# check if countries GDP predicts % of innovation in consumer services (wealth.how.industry)
# maybe make regression on predictors of billionaires