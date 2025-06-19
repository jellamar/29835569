# load necessary packages
library(tidyverse)
library(scales)
library(dplyr)
library(stringr)

# read in data
coldplay <- read.csv("data/Coldplay_vs_Metallica/Coldplay.csv")
metallica <- read.csv("data/Coldplay_vs_Metallica/metallica.csv")
spoitfy <- readRDS("data/Coldplay_vs_Metallica/Broader_Spotify_Info.rds")
billboard_100 <- readRDS("data/Coldplay_vs_Metallica/charts.rds")

# sight data
head(coldplay)
head(metallica)

# adjust data
coldplay <- coldplay %>%
                mutate(year = substr(release_date, 1, 4)) %>%
                mutate(name = iconv(name, "UTF-8", "ASCII", sub = "")) %>%
                mutate(name = tolower(name))

metallica <- metallica %>%
                mutate(year = substr(release_date, 1, 4)) %>%
                mutate(name = iconv(name, "UTF-8", "ASCII", sub = "")) %>%
                mutate(name = tolower(name))

# filter out "Live" from song names

coldplay <- coldplay %>%
                filter(!str_detect(name, "live"))

metallica <- metallica %>%
                filter(!str_detect(name, "live"))

# compare average danceability, energy, loudness, speechiness, acousticness, instrumentalness, liveness, valence, tempo between both bands

coldplay_analysis <- coldplay %>%
    summarise(danceability = mean(danceability, na.rm = TRUE),
        energy = mean(energy, na.rm = TRUE),
        loudness = mean(loudness, na.rm = TRUE),
        speechiness = mean(speechiness, na.rm = TRUE),
        acousticness = mean(acousticness, na.rm = TRUE),
        instrumentalness = mean(instrumentalness, na.rm = TRUE),
        liveness = mean(liveness, na.rm = TRUE),
        valence = mean(valence, na.rm = TRUE),
        tempo = mean(tempo, na.rm = TRUE)) %>%
        pivot_longer(cols = everything(),
                 names_to = "feature",
                 values_to = "value") %>%
        mutate(value = round(value, 3))

metallica_analysis <- metallica %>%
        summarise(danceability = mean(danceability, na.rm = TRUE),
              energy = mean(energy, na.rm = TRUE),
              loudness = mean(loudness, na.rm = TRUE),
              speechiness = mean(speechiness, na.rm = TRUE),
              acousticness = mean(acousticness, na.rm = TRUE),
              instrumentalness = mean(instrumentalness, na.rm = TRUE),
              liveness = mean(liveness, na.rm = TRUE),
              valence = mean(valence, na.rm = TRUE),
              tempo = mean(tempo, na.rm = TRUE)) %>%
              pivot_longer(cols = everything(),
                 names_to = "feature",
                 values_to = "value") %>%
               mutate(value = round(value, 3))

combined_data <- bind_rows(coldplay_analysis %>% mutate(band = "Coldplay"),
                            metallica_analysis %>% mutate(band = "Metallica")) %>%
                            pivot_wider(names_from = band, values_from = value)

saveRDS(combined_data, file = "results/combined_data.rds")

# Analyse average song popularity over time

coldplay_pop <- coldplay %>%
                    group_by(year) %>%
                    summarise(Avg_Pop = mean(popularity))

metallica_pop <- metallica %>%
                    group_by(year) %>%
                    summarise(Avg_Pop = mean(popularity))

