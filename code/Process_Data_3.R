process_data <- function(data) {
    processed <- data %>%
  mutate(
    Exercise = case_when(
      Physical.Activity.Level == "Sedentary" ~ 1,
      Physical.Activity.Level == "Lightly Active" ~ 2,
      Physical.Activity.Level == "Moderately Active" ~ 3,
      Physical.Activity.Level == "Very Active" ~ 4),

    Sleep = case_when(
      Sleep.Quality == "Poor" ~ 1,
      Sleep.Quality == "Fair" ~ 2,
      Sleep.Quality == "Good" ~ 3,
      Sleep.Quality == "Excellent" ~ 4),

    Health = Daily.Caloric.Surplus.Deficit,
    Stress = Stress.Level)

    model <- lm(Health ~ Exercise + Sleep + Stress, data = processed)

    saveRDS(processed, "results/processed_data.rds")
    saveRDS(broom::tidy(model), "results/regression_summary.rds")

    html_tab <- modelsummary(
        model, statistic = "({std.error})",
        stars     = TRUE,
        output    = "html",
        title     = "Table 1 – Regression: Health on Exercise, Sleep, Stress")

    cat(as.character(html_tab))
}
