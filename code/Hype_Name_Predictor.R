hype_name_predictor <- function(data) {

    names_list <- data %>%
        filter(!is.na(name), imdb_score >= 8.5, release_year >= 2020) %>%
        mutate(first_name = word(name, 1)) %>%
        pull(first_name) %>%
        unique() %>%
        sort()

    names_list <- sample(names_list, 20) %>% sort()

    df <- data.frame(Names = names_list)

    kable(df, caption = "Top Name Predictions") %>%
        kable_styling(bootstrap_options = c("striped", "hover"))
}

