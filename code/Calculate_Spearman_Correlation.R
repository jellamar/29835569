calculate_spearman_correlation <- function(data) {

    top25 <- data %>%
        group_by(Year, Gender, Name) %>%
        summarise(Total = sum(Count)) %>%
        ungroup() %>%
        group_by(Year, Gender) %>%
        slice_max(order_by = Total, n = 25) %>%
        ungroup()

    head(top25)

    # calculate correlation between year t and year t+3
    years <- c(1910:2011)
    results <- data.frame(Year = integer(), Correlation = numeric())
    for (y in years) {t <- top25 %>% filter(Year == y) %>% select(Name, Gender, Count = Total)
                      t3 <- top25 %>% filter(Year == y + 3) %>% select(Name, Gender, Count = Total)
        all_names <- bind_rows(t, t3) %>% distinct(Name, Gender)
        combined <- all_names %>%
            left_join(t, by = c("Name", "Gender")) %>%
            left_join(t3, by = c("Name", "Gender")) %>%
            rename(Count_t = Count.x, Count_t3 = Count.y) %>%
            mutate(Count_t = replace_na(Count_t, 0),  # Names that left top 25: Count_t = 0
                   Count_t3 = replace_na(Count_t3, 0)) # Names new in top 25: Count_t3 = 0
        corr <- suppressWarnings(cor.test(combined$Count_t, combined$Count_t3, method = "spearman"))
        results <- rbind(results, data.frame(Year = y, Correlation = corr$estimate))}

    # check if average correlation was different before and after 1990
    results <- results %>%
        mutate(Period_Check = ifelse(Year < 1990, "Before", "After"))

    results %>%
        group_by(Period_Check) %>%
        summarise(mean_correlation = mean(Correlation), sd_correlation = sd(Correlation), n = n())

    saveRDS(results, "results/spearman_correlation_results.rds")

}