selfmade_visualization <- function(data) {
    visualization <- ggplot(data, aes(x = factor(year), y = Selfmade_Share, fill = Region)) +
        geom_bar(stat = "identity", position = position_dodge(width = 0.8), width = 0.7) +
        geom_text(aes(label = scales::percent(Selfmade_Share, accuracy = 0.1)),
                  position = position_dodge(width = 0.8),
                  vjust = -0.5,
                  size = 3.5) +
        scale_y_continuous(labels = scales::percent_format(),
                           limits = c(0, 0.8),
                           expand = expansion(mult = c(0, 0.05))) +
        scale_fill_manual(values = c("USA" = "#1f77b4", "Emerging Economies" = "#ff7f0e")) +
        labs(title = "Share of Self-Made Billionaires by Region",
             x = "Year",
             y = "Percentage of Self-Made Billionaires",
             fill = "Region") +
        theme_minimal(base_size = 12) +
        theme(legend.position = "top",
              panel.grid.major.x = element_blank(),
              plot.title = element_text(face = "bold"))

print(visualization)
ggsave("results/Selfmade_Millionaires.png", visualization)

}
