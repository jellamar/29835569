# load necessary packages
library(tidyverse)
library(scales)
library(dplyr)
library(stringr)

# read in data
coldplay <- read.csv("data/Coldplay_vs_Metallica/Coldplay.csv")
metallica <- read.csv("data/Coldplay_vs_Metallica/metallica.csv")
spotify <- readRDS("data/Coldplay_vs_Metallica/Broader_Spotify_Info.rds")
billboard_100 <- readRDS("data/Coldplay_vs_Metallica/charts.rds")

# sight data
head(coldplay)
head(metallica)

# adjust data
coldplay <- coldplay %>%
                mutate(artist = "Coldplay", album = album_name, year = as.numeric(substr(release_date, 1, 4))) %>%
                select(-release_date, -album_name)
metallica <- metallica %>%
                mutate(artist = "Metallica", duration = duration_ms * 0.001,
                       year = as.numeric(substr(release_date, 1, 4))) %>%
                select(-duration_ms, -release_date)
spotify <- spotify %>%
                mutate(duration = duration_ms * 0.001, year = as.numeric(year)) %>%
                select(-duration_ms, -spotify_id, -spotify_preview_url, -track_id) %>%
                filter(!artist %in% c("Coldplay", "Metallica"))

bands <- bind_rows(coldplay, metallica, spotify)

bands <- bands %>%
                mutate(name = iconv(name, "UTF-8", "ASCII", sub = "")) %>%
                mutate(name = tolower(name)) %>%
                mutate(version = case_when(str_detect(name, "live") ~ "live",
                                           str_detect(name, "demo") ~ "demo",
                                           TRUE ~ "studio"))

# compare average danceability, energy, loudness, speechiness, acousticness, instrumentalness, liveness, valence, tempo between both bands

calculate_combined_band_stats <- function(bands_df, version_selection) {
    bands_df %>%
        filter(artist %in% c("Coldplay", "Metallica")) %>%
        group_by(artist) %>%
        filter(version == version_selection) %>%
        summarise(danceability = mean(danceability, na.rm = TRUE),
            energy = mean(energy, na.rm = TRUE),
            loudness = mean(loudness, na.rm = TRUE),
            speechiness = mean(speechiness, na.rm = TRUE),
            acousticness = mean(acousticness, na.rm = TRUE),
            instrumentalness = mean(instrumentalness, na.rm = TRUE),
            liveness = mean(liveness, na.rm = TRUE),
            valence = mean(valence, na.rm = TRUE),
            tempo = mean(tempo, na.rm = TRUE),
            duration = mean(duration, na.rm = TRUE)) %>%
        pivot_longer(cols = -artist, names_to = "feature", values_to = "value") %>%
        mutate(value = round(value, 3)) %>%
        pivot_wider(names_from = artist, values_from = value)}

combined_analysis <- calculate_combined_band_stats(bands, "studio")

saveRDS(combined_data, file = "results/combined_data.rds")

# Show average duration over time (Metallica vs. Coldplay vs. All)

song_duration_over_time <- bands %>%
                            filter(version == "studio") %>%
                            mutate(Artist_Group = case_when(
                                artist == "Coldplay" ~ "Coldplay",
                                artist == "Metallica" ~ "Metallica",
                                TRUE ~ "Other"), Year = year) %>%
                            group_by(Artist_Group, Year) %>%
                            summarize(Average_Duration = mean(duration)) %>%
                            ungroup()


source("code/Line_Plot.R")
line_plot(song_duration_over_time, "Year", "Average_Duration", "Artist_Group")
saveRDS(song_duration_over_time, file = "results/song_duration_over_time.rds")

# Reproduce graph from the task
top_albums_per_band <- function(data, band_name, n = 10) {
    data %>% filter(artist == band_name, version == "studio") %>%
        group_by(album) %>%
        summarise(mean_popularity = mean(popularity, na.rm = TRUE), .groups = "drop") %>%
        slice_max(mean_popularity, n = n) %>%
        mutate(artist = band_name)}

top_albums <- bind_rows(
    top_albums_per_band(bands, "Coldplay"),
    top_albums_per_band(bands, "Metallica"))

# Filter only relevant rows for plotting
plot_data <- bands %>%
    filter(version == "studio") %>%
    semi_join(top_albums, by = c("artist", "album")) %>%
    mutate(album = fct_reorder(album, popularity, .fun = median))

# Plot
top_10_studio <- ggplot(plot_data, aes(x = album, y = popularity, fill = artist)) +
    geom_boxplot(outlier.shape = 16, outlier.size = 1.2, alpha = 0.8) +
    coord_flip() +
    labs(
        title = "Top 10 Popular Studio-Albums per Band",
        x = "Album", y = "Popularity") +
    scale_fill_manual(values = c("Coldplay" = "#FFA07A", "Metallica" = "#87CEFA")) +
    theme_minimal(base_size = 12) +
    theme(
        axis.text.y = element_text(size = 9),
        plot.title = element_text(hjust = 0.5),
        legend.position = "bottom")

ggsave("results/top_10_studio_plot.png", plot = top_10_studio, width = 6, height = 5, dpi = 300)


# Analyse average song popularity over time

analyse_avg_song_popularity <- function(band, band_name) {
                                    band %>%
                                    group_by(year) %>%
                                    summarise(Avg_Pop = mean(popularity, na.rm = TRUE)) %>%
                                    mutate(!!band_name := Avg_Pop)}

coldplay_popularity <- analyse_avg_song_popularity(coldplay, "Coldplay")
metallica_popularity <- analyse_avg_song_popularity(metallica, "Metallica")
combined_popularity <-  bind_rows(coldplay_popularity, metallica_popularity) %>%
                            pivot_longer(cols = c(Coldplay, Metallica),
                                            names_to = "Artist",
                                            values_to = "Popularity") %>%
                            mutate(Year = as.numeric(year))

# use bar_plot function
source("code/Bar_Plot.R")
bar_plot(combined_popularity, "Year", "Popularity", "Artist")
saveRDS(combined_data, file = "results/combined_data.rds")
