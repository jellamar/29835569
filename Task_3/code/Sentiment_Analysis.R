sentiment_analysis <- function(data) {

    descriptions_long <- data %>%
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

    data_sentiment <- data %>%
        left_join(sentiment_avg %>% select(id, sentiment_score), by = "id")

    saveRDS(data_sentiment, "results/data_sentiment.rds")

}