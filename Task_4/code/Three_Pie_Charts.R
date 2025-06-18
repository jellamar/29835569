three_pie_charts <- function(data) {
    data_1996 <- data %>% filter(year == 1996)
    data_2001 <- data %>% filter(year == 2001)
    data_2014 <- data %>% filter(year == 2014)

    # Set up plot area (3 charts side by side)
    par(mfrow = c(1, 3), mar = c(0, 0, 2, 0)) # Tight margins

    # Define consistent colors and settings
    colors <- colors <- c("lightblue", "orange")
    label_cex <- 0.8  # Label size
    main_cex <- 1.1   # Title size

    source("code/Pie_Chart.R")
    pie_chart(data_1996, 1996, colors, main_cex, label_cex)
    pie_chart(data_1996, 1996, colors, main_cex, label_cex)
    pie_chart(data_1996, 1996, colors, main_cex, label_cex)

    # Add legend below charts
    legend("bottom",
            legend = c("USA", "Emerging Economies"),
            fill = colors,
            horiz = TRUE,
            inset = c(0, -0.1), # Position below charts
            xpd = TRUE, # Allow drawing outside plot area
            bty = "n") # No legend box
}