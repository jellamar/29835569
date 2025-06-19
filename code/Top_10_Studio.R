top_10_studio <- function(data) {
   top_10 <- ggplot(data, aes(x = album, y = popularity, fill = artist)) +
    geom_boxplot(outlier.shape = 16, outlier.size = 1.2, alpha = 0.8) +
    coord_flip() +
    labs(
        title = "Top 10 Popular Studio-Albums per Band",
        x = "Album", y = "Popularity") +
    scale_fill_manual(values = c("Coldplay" = "#FFA07A", "Metallica" = "#87CEFA")) +
    theme_minimal(base_size = 12) +
    theme(
        axis.text.y = element_text(size = 9),
        plot.title = element_text(hjust = 0.5),
        legend.position = "bottom")

print(top_10)
ggsave("results/top_10_studio_plot.png", plot = top_10, width = 6, height = 5, dpi = 300)

}