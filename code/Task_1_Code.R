## load necessary packages
library(tidyverse)
library(scales)
library(dplyr)

## Load in the data
baby_names <- read_rds("data/US_Baby_names/Baby_Names_By_US_State.rds")
billboard <- read_rds("data/US_Baby_names/charts.rds")
hbo_titles <- read_rds("data/US_Baby_names/HBO_titles.rds")
hbo_credits <- read_rds("data/US_Baby_names/HBO_credits.rds")

## Check structure of baby_names and clean if necessary

colnames(baby_names)
head(baby_names)

# check for NAs in Name column
sum(is.na(baby_names$Name))
# result = zero

# check for duplicated rows
sum(duplicated(baby_names))
# result = zero

# check the structure of the data frame
str(baby_names)


## Analysis

# create overview of total names counted per year

count_name_year <- baby_names %>%
                        group_by(Year) %>%
                        summarize(Total = sum(Count))

source("code/Line_Plot.R")
count_name_year_plot <- line_plot(count_name_year, "Year", "Total") + scale_y_continuous(labels = comma)
print(count_name_year_plot)
ggsave(filename = "results/count_name_year_plot.png", plot = count_name_year_plot, width = 10, height = 6, dpi = 300)

# create overview of most popular names each year

mainstream_analysis <- baby_names %>%
                    group_by(Year, Gender) %>%
                    slice_max(order_by = Count, n = 1) %>%
                    ungroup()

# load bar plot function
source("code/Bar_Plot.R")

# create and save overview of count of top name over time
top_name_bar_plot <- bar_plot(top_name_year, "Year", "Count", "Gender")
print(top_name_bar_plot)
ggsave(filename = "results/top_name_bar_plot.png", plot = top_name_bar_plot, width = 10, height = 6, dpi = 300)


# create the Spearmen Rank Correlation

# keep only top 25 names per year and gender

top25 <- baby_names %>%
    group_by(Year, Gender, Name) %>%
    summarise(Total = sum(Count), .groups = "drop") %>%  # Sum counts across states
    group_by(Year, Gender) %>%
    slice_max(order_by = Total, n = 25) %>%  # Now picks true top 25 national names
    ungroup()

head(top25)

# calculate correlation between year t and year t+1
years <- c(1910:2011)
results <- data.frame(Year = integer(), Correlation = numeric())
for (y in years) {

    t <- top25 %>% filter(Year == y) %>% select(Name, Gender, Count = Total)
    t3 <- top25 %>% filter(Year == y + 3) %>% select(Name, Gender, Count = Total)
    all_names <- bind_rows(t, t3) %>% distinct(Name, Gender)
    combined <- all_names %>%
        left_join(t, by = c("Name", "Gender")) %>%
        left_join(t3, by = c("Name", "Gender")) %>%
        rename(Count_t = Count.x, Count_t3 = Count.y) %>%
        mutate(Count_t = replace_na(Count_t, 0),  # Names that left top 25 get Count_t = 0
                Count_t3 = replace_na(Count_t3, 0)) # Names new to top 25 get Count_t3 = 0
        corr <- cor.test(combined$Count_t, combined$Count_t3, method = "spearman")
        results <- rbind(results, data.frame(Year = y, Correlation = corr$estimate))}

# check if average correlation was different pre and post 1990

results <- results %>%
    mutate(Period_Check = ifelse(Year < 1990, "Before", "After"))

results %>%
    group_by(Period_Check) %>%
    summarise(mean_correlation = mean(Correlation),
              sd_correlation = sd(Correlation),
              n = n())

# visualize results
source("code/Line_Plot.R")
correlation_line_plot <- line_plot(results, "Year", "Correlation")
print(correlation_line_plot)
ggsave(filename = "results/correlation_line_plot.png", plot = correlation_line_plot, width = 8, height = 6, dpi = 300)

# check for spikes in names between years

name_trends <- baby_names %>%
    group_by(Year, Name, Gender) %>%
    summarise(Count = sum(Count), .groups = "drop")

# add Pct_Change column to check for changes in names between years

spikes <- name_trends %>%
    arrange(Name, Gender, Year) %>%
    group_by(Name, Gender) %>%
    mutate(Pct_Change = (Count - lag(Count)) / lag(Count) * 100) %>%
    mutate(Big_Spike = !is.na(Pct_Change) & Pct_Change > 1000) %>%
    arrange(desc(Pct_Change)) %>%
    ungroup()

# display and save results

top_spikes_table <- spikes %>%
    select(Year, Name, Gender, Pct_Change) %>%
    head(15)

saveRDS(top_spikes_table, "results/top_spikes.rds")


knitr::kable(top_spikes_table,
             caption = "Top 15 Baby Name Spikes by Percentage Increase",
             col.names = c("Year", "Name", "Gender", "% Increase"),
             digits = 1) %>%
    kableExtra::kable_styling(bootstrap_options = c("striped", "hover"))

## match the resulting 14 top spiked names to billboard, hbo titles and hbo credits data ##
# billboard #

top_20_artists_songs_year <- billboard %>%
    mutate(Year = year(date)) %>%
    filter(Year >= 1910, Year <= 2014) %>%
    group_by(Year, artist, song) %>%
    summarise(Total_Weeks = sum(`weeks-on-board`, na.rm = TRUE)) %>%
    ungroup() %>%
    arrange(Year, desc(Total_Weeks)) %>%
    group_by(Year) %>%
    slice_max(order_by = Total_Weeks, n = 20) %>%
    ungroup()

# collapse all artist and song strings for partial detection
all_artists <- paste(top_20_artists_songs_year$artist, collapse = " ")
all_songs <- paste(top_20_artists_songs_year$song, collapse = " ")

spikes <- spikes %>%
    mutate(In_Artist = str_detect(all_artists, fixed(Name)),
            In_Song   = str_detect(all_songs, fixed(Name)))

# hbo #
hbo_total <- hbo_titles %>%
                left_join(hbo_credits %>% select(id, name, character), by = "id") %>%
                select(-type, -runtime,-production_countries, -seasons, -tmdb_score, -tmdb_popularity, - imdb_votes) %>%
                filter(imdb_score >= 8.5, release_year <= 2014)

all_hbo <- paste(hbo_total$name, hbo_total$character, hbo_total$title, hbo_total$description, collapse = " ")

spikes <- spikes %>% mutate(in_Film = str_detect(all_hbo, fixed(Name)))

# check how many % of names can be explained by songs, singers, or film-related names

pct_assign <- spikes %>%
    group_by(Gender) %>%
    summarise(pct_artist = mean(In_Artist),
              pct_song   = mean(In_Song),
              pct_film   = mean(in_Film), .groups = "drop")

print(pct_assign)

popular_films <- hbo_total %>%
    filter(imdb_score >= 8, release_year >= 2014)

first_names <- popular_films %>%
    select(name) %>%
    separate(name, into = c("first_name", "last_name"), sep = " ", extra = "merge") %>%
    select("first_name")

print(first_names)

first_names %>%
    kbl(caption = "Top Name Predictions") %>%  # kableExtra's version of kable()
    kable_styling(bootstrap_options = c("striped", "hover"))