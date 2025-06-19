genre_region_summary <- function(data) {
    genre_region_summary <- data %>%
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


    print(avg_user_rating)
    ggsave("results/avg_user_rating.png", plot = avg_user_rating, width = 6, height = 5, dpi = 300)
    saveRDS(top_genres, "results/top_genres.rds")
}