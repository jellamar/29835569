name_pop_culture_check <- function(data) {
    pct_assign <- data %>%
        group_by(Gender) %>%
        summarise(pct_artist = mean(In_Artist),
                  pct_song   = mean(In_Song),
                  pct_film   = mean(In_Film)) %>%
        ungroup() %>%
        mutate(across(-Gender, ~scales::percent(., accuracy = 0.1)))

    kableExtra::kbl(pct_assign, caption = "Name Representation in Pop Culture") %>%
        kableExtra::kable_styling(bootstrap_options = c("striped", "hover"))
}



