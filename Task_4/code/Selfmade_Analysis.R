selfmade_analysis <- function(data) {
    selfmade_share <- data %>%
    mutate(USA_Check = if_else(location.country.code == "USA", TRUE, FALSE),
      Selfmade_Check = if_else(wealth.how.inherited == "not inherited", TRUE, FALSE)) %>%
    group_by(year, USA_Check) %>%
    summarise(Total_Billionaires = n(),
        Selfmade_Count = sum(Selfmade_Check),
        Selfmade_Share = Selfmade_Count / Total_Billionaires) %>%
        ungroup() %>%
    mutate(Region = if_else(USA_Check, "USA", "Emerging Economies"))

    saveRDS(selfmade_share, "results/selfmade_share.rds")
}