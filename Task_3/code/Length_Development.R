length_development <- function(data) {
    length <- data %>% group_by(release_year) %>%
        summarize(mean_duration = mean(runtime)) %>%
        ungroup()

    source("code/Line_Plot.R")
    length_over_time <- line_plot(length, "release_year", "mean_duration")
    print(length_over_time)
    saveRDS(length_over_time, "results/length_over_time.rds")

}
