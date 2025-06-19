three_pie_charts <- function(data) {
    data_1996 <- data %>% filter(year == 1996)
    data_2001 <- data %>% filter(year == 2001)
    data_2014 <- data %>% filter(year == 2014)

    # Set up plot area (3 charts side by side)
    #par(mfrow = c(1, 3), mar = c(0, 0, 2, 0))
    par(mfrow = c(1, 3), mar = c(2, 0, 3, 0), oma = c(0, 0, 0, 0))

    # Define consistent colors and settings
    colors <- colors <- c("lightblue", "orange")

    source("code/Pie_Chart.R")
    pie_chart(data_1996, "1996", colors)
    pie_chart(data_2001, "2001", colors)
    pie_chart(data_2014, "2014", colors)

    # Add legend below charts
    legend("bottom",
            legend = c("USA", "Others"),
            fill = colors,
            horiz = TRUE,
            inset = c(0, -0.1), # Position below charts
            xpd = TRUE, # Allow drawing outside plot area
            bty = "n") # No legend box
}