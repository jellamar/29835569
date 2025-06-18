film_check <- function(data1, data2) {

    spikes <- readRDS("results/spikes.rds")

    hbo_total <- data1 %>%
        left_join(data2 %>% select(id, name, character), by = "id") %>%
        select(-type, -runtime,-production_countries, -seasons, -tmdb_score, -tmdb_popularity, - imdb_votes)

    hbo_filtered <- hbo_total %>%
        filter(imdb_score >= 8.5, release_year <= 2014)

    all_hbo <- paste(hbo_filtered$name, hbo_filtered$character, hbo_filtered$title, hbo_filtered$description, collapse = " ")

    spikes <- spikes %>% mutate(In_Film = str_detect(all_hbo, fixed(Name)))

    saveRDS(hbo_total, "results/hbo_total.rds")
    saveRDS(hbo_filtered, "results/hbo_filtered")
    saveRDS(spikes, "results/spikes.rds")

}
