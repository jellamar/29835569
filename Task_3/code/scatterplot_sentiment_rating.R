plot_sentiment_vs_rating <- function(data, sentiment_col = "Avg_Sentiment", imdb_col = "Avg_IMDb",
                                   region_col = "region", size_col = "n", label_col = "genres",
                                   point_alpha = 0.7, repel = TRUE) {

    p <- ggplot(data, aes_string(x = sentiment_col, y = imdb_col, color = region_col,
                                 size = size_col, label = label_col)) +
        geom_point(alpha = point_alpha) +
        geom_hline(yintercept = 7, linetype = "dashed", color = "gray") +
        geom_vline(xintercept = 0, linetype = "dashed", color = "gray") +
        labs(title = "Sentiment vs User Rating by Genre and Region",
            x = "Average Sentiment Score",
            y = "Average User Rating (IMDb Score)") +
        theme_minimal() +
        theme(legend.position = "bottom")

    if (repel) {p <- p + ggrepel::geom_text_repel(max.overlaps = 25, size = 3)}
    else {p <- p + geom_text(size = 3, vjust = -1)}
    return(p)}
