industry_trends <- function(data) {
    industry_data <- data %>%
        filter(Selfmade_Check) %>%
        mutate(Industry_Group = case_when(wealth.how.industry %in% c("Technology-Computer", "Software") ~ "Technology",
                                          wealth.how.industry %in% c("Retail", "Restaurant", "Consumer") ~ "Consumer Services",
                                          wealth.how.industry %in% c("Banking", "Diversified Financial", "Hedge Funds", "Money                                                                         Management", "Venture Capital") ~ "Finance",
                                          wealth.how.industry %in% c("Real Estate") ~ "Real Estate",
                                          wealth.how.industry %in% c("Construction") ~ "Construction",
                                          wealth.how.industry %in% c("Energy", "Mining And Metals") ~ "Energy & Resources",
                                          wealth.how.industry %in% c("Media") ~ "Media & Entertainment",
                                          wealth.how.industry %in% c("Technology-Medical") ~ "Healthcare Tech", TRUE ~ "Other Industries")) %>%
        group_by(year, Industry_Group) %>%
        summarise(count = n(), .groups = "drop") %>%
        group_by(year) %>%
        mutate(prop = count / sum(count))

    saveRDS(industry_data, "results/industry_trends_data.rds")

industry_plot <- ggplot(industry_data, aes(x = factor(year), y = prop, fill = Industry_Group)) +
        geom_bar(stat = "identity", position = "stack") +
        geom_text(aes(label = scales::percent(prop, accuracy = 1)),
              position = position_stack(vjust = 0.5, reverse = TRUE),
              size = 2.5,
              color = "black",
              fontface = "bold") +
        labs(title = "Industry Composition of Self-Made Billionaires Over Time",
             x = "Year",
             y = "Proportion of Billionaires",
             fill = "Industry") +
        scale_y_continuous(labels = scales::percent_format()) +
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1),
              legend.position = "bottom") +
        guides(fill = guide_legend(ncol = 2))

print(industry_plot)
}
