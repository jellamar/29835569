library(dplyr)
library(tidyr)
library(stringr)
library(tidytext)
library(scales)
library(ggplot2)
library(ggrepel)

Titles <- readRDS("data/netflix/titles.rds")
Credits <- readRDS("data/netflix/credits.rds")
Movie_Info <- read.csv("data/netflix/netflix_movies.csv")

# merge data frames

Titles <- Titles %>% mutate(title = str_squish(tolower(title)))

Movie_Info <- Movie_Info %>%
                mutate(genres = listed_in, title = str_squish(tolower(title))) %>%
                select(-show_id, -listed_in)

merged <- Titles %>%
    left_join(Movie_Info, by = c("title" = "title", "release_year" = "release_year"))

source("code/region_map.R")

# split cells with multiple country entries

merged <- merged %>%
    separate_rows(country, sep = ",") %>%
    mutate(country = str_trim(country))

region_data <- merged %>%
    left_join(region_map, by = "country")


# Analyse average length development over time

length_development <- region_data %>% group_by(release_year) %>%
                                        summarize(mean_duration = mean(runtime)) %>%
                                        ungroup()

source("code/Line_Plot.R")
length_over_time <- line_plot(length_development, "release_year", "mean_duration")
saveRDS(length_over_time.rds)

# sentiment analysis descriptions

descriptions_long <- region_data %>%
    select(id, description.x, description.y) %>%
    pivot_longer(cols = starts_with("description"),
                 names_to = "source",
                 values_to = "text") %>%
    filter(!is.na(text))

tokens <- descriptions_long %>%
    unnest_tokens(word, text) %>%
    anti_join(stop_words, by = "word")

# Use bing sentiment lexicon
sentiment_scores <- tokens %>%
    inner_join(get_sentiments("bing"), by = "word", relationship = "many-to-many") %>%
    count(id, source, sentiment) %>%
    pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>%
    mutate(sentiment_score = (positive - negative)/(positive + negative))

sentiment_avg <- sentiment_scores %>%
    group_by(id) %>%
    summarise(sentiment_score = mean(sentiment_score, na.rm = TRUE),
        .groups = "drop")

data_sentiment <- region_data %>%
    left_join(sentiment_avg %>% select(id, sentiment_score), by = "id")

genre_region_summary <- data_sentiment %>%
    group_by(region, genres.x) %>%
    summarise(
        Avg_IMDb = mean(imdb_score, na.rm = TRUE),
        Avg_Sentiment = mean(sentiment_score, na.rm = TRUE),
        n = n()) %>%
    ungroup()

top_genres <- genre_region_summary %>%
    mutate(genres = genres.x %>%
        str_remove_all("\\[|\\]|'|\"")) %>%
    separate_rows(genres, sep = ",\\s*") %>%
    mutate(genres = str_trim(genres)) %>%
    group_by(region, genres) %>%
    summarise(Avg_IMDb = mean(Avg_IMDb, na.rm = TRUE),
        Avg_Sentiment = mean(Avg_Sentiment, na.rm = TRUE),
        n = sum(n)) %>%
    ungroup() %>%
    group_by(region) %>%
    slice_max(Avg_IMDb, n = 5) %>%
    filter(!is.na(region)) %>%
    ungroup()

top_genres <- top_genres %>%
    mutate(region = recode(region,
                           "Latin America" = "Latin\nAmerica",
                           "North America" = "North\nAmerica",
                           "Middle East" = "Middle\nEast"))

avg_user_rating <- ggplot(top_genres, aes(x = region, y = genres, fill = Avg_IMDb)) +
    geom_tile(color = "white") +
    scale_fill_viridis_c(option = "C", name = "Average User Rating") +
    labs(title = "Genre Popularity by Region", x = "Region", y = "Genre") +
    theme_minimal()

ggsave("results/avg_user_rating.png", plot = avg_user_rating, width = 6, height = 5, dpi = 300)

source("code/scatterplot_sentiment_rating.R")
scatterplot <- plot_sentiment_vs_rating(top_genres)
ggsave("results/plot_sentiment_vs_rating.png", plot = scatterplot, width = 6, height = 5, dpi = 300)




