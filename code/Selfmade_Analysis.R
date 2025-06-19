selfmade_analysis <- function(data) {
    analysis <- data %>%
        mutate(USA_Check = if_else(location.country.code == "USA", TRUE, FALSE),
                Selfmade_Check = if_else(wealth.how.inherited == "not inherited", TRUE, FALSE),
                Region = if_else(USA_Check, "USA", "Emerging Economies"))

    selfmade_share <- analysis %>%
                group_by(year, Region) %>%
                summarise(Total_Billionaires = n(),
                          Selfmade_Count = sum(Selfmade_Check),
                          Selfmade_Share = Selfmade_Count / Total_Billionaires) %>%
                ungroup()

    saveRDS(selfmade_share, "results/selfmade_share.rds")
    saveRDS(analysis, "results/analysis.rds")
}
