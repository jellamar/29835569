adjust_data <- function(coldplay_data, metallica_data, spotify_data) {
    coldplay_cleaned <- coldplay_data %>%
        mutate(artist = "Coldplay", album = album_name, year = as.numeric(substr(release_date, 1, 4))) %>%
        select(-release_date, -album_name)
    metallica_cleaned <- metallica_data %>%
        mutate(artist = "Metallica", duration = duration_ms * 0.001,
               year = as.numeric(substr(release_date, 1, 4))) %>%
        select(-duration_ms, -release_date)
    spotify_cleaned <- spotify_data %>%
        mutate(duration = duration_ms * 0.001, year = as.numeric(year)) %>%
        select(-duration_ms, -spotify_id, -spotify_preview_url, -track_id) %>%
        filter(!artist %in% c("Coldplay", "Metallica"))

    bands <- bind_rows(coldplay_cleaned, metallica_cleaned, spotify_cleaned)

    bands <- bands %>%
        mutate(name = iconv(name, "UTF-8", "ASCII", sub = "")) %>%
        mutate(name = tolower(name)) %>%
        mutate(version = case_when(str_detect(name, "live") ~ "live",
                                   str_detect(name, "demo") ~ "demo",
                                   TRUE ~ "studio"))

    saveRDS(bands,"results/bands.rds")
    saveRDS(coldplay_cleaned,"results/coldplay.rds")
    saveRDS(metallica_cleaned,"results/metallica.rds")
    saveRDS(spotify_cleaned,"results/spotify.rds")
    return(bands)
}
