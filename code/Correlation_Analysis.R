correlation_analysis <- function(data) {

consumer_analysis <- data %>%
  filter(Selfmade_Check, !is.na(location.gdp), location.gdp > 0) %>%
  mutate(Is_Consumer = wealth.how.industry %in% c("Consumer", "Retail", "Restaurant"),
    Country = location.citizenship,
    Log10_GDP = log10(location.gdp)) %>%
  group_by(Country) %>%
  summarise(total_billionaires = n(),
    Consumer_Count = sum(Is_Consumer),
    Consumer_Share = Consumer_Count / total_billionaires,
    Avg_log10_GDP = mean(Log10_GDP, na.rm = TRUE)) %>%
    filter(total_billionaires >= 3)

correlation_result <- cor.test(x = consumer_analysis$Avg_log10_GDP, y= consumer_analysis$Consumer_Share, method = "pearson")

plot <- ggplot(consumer_analysis, aes(x = Avg_log10_GDP, y = Consumer_Share)) +
    geom_point(aes(size = total_billionaires, color = Avg_log10_GDP), alpha = 0.7) +
    geom_smooth(method = "lm", color = "red", se = FALSE) +
    ggrepel::geom_text_repel(
        aes(label = ifelse(total_billionaires > 20 | Consumer_Share > 0.5, Country, "")),
        size = 3
    ) +
    scale_color_viridis_c() +
    labs(
        title = "No Significant GDP-Consumer Industry Relationship",
        subtitle = "Filtered only countries with ≥3 billionaires",
        x = "Log10(GDP)",
        y = "Consumer Industry Share"
    ) +
    theme_minimal()

print(plot)
#write_csv(consumer_analysis, "results/consumer_share_by_country.csv")
ggsave("results/gdp_consumer_correlation.png", plot, width = 8, height = 6)

}