pie_chart <- function(data, year, colors, label_cex = 0.8, main_cex = 1.1) {
    pie(c(data$Selfmade_Share[1], data$Selfmade_Share[2]),
        labels = c(paste0("USA\n", round(100*data$Selfmade_Share[1]), "%"),
                   paste0("Others\n", round(100*data$Selfmade_Share[2]), "%")),
        col = colors,
        main = year,
        cex.main = main_cex,
        cex = label_cex,
        init.angle = 45,  # Start at 45 degree angle for better label placement
        clockwise = TRUE, # Helps position labels better
        radius = 0.9)    # Slightly smaller radius to make room for labels
}