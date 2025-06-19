top_albums <- function(data, band_name, n = 10) {
        data %>% filter(artist == band_name, version == "studio") %>%
            group_by(album) %>%
            summarise(mean_popularity = mean(popularity, na.rm = TRUE), .groups = "drop") %>%
            slice_max(mean_popularity, n = n) %>%
            mutate(artist = band_name)}


