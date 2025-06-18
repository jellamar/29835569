analyse_avg_song_popularity <- function(band, band_name) {
        band %>%
            group_by(year) %>%
            summarise(Avg_Pop = mean(popularity, na.rm = TRUE)) %>%
            mutate(!!band_name := Avg_Pop)}
