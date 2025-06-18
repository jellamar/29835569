calculate_band_stats <- function(bands_df, version_selection) {
    stats <- bands_df %>%
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
        pivot_wider(names_from = artist, values_from = value)
}