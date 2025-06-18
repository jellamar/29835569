pie_chart <- function(data, year, main_cex, label_cex) {
    pie(c(data$Selfmade_Share[1], data$Selfmade_Share[2]),
        labels = c(paste0(round(100*data$Selfmade_Share[1]), "% USA"),
                   paste0(round(100*data$Selfmade_Share[2]), "% Emerging")),
        col = colors,
        main = year,
        cex.main = main_cex,
        cex = label_cex,
        init.angle = 90)

}