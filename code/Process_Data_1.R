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

    #table <- mtable("Health ~ Exercise + Sleep + Stress" = model,
                    #summary.stats = c('R-squared', 'F', 'p', 'N'))


    #reg_results <- tidy(model)
    print(summary(model))
    #
    #reg_results <- broom::tidy(model)
    #tabel <- knitr::kable(reg_results, digits = 3, caption = "Table 1: Regression Results")
    saveRDS(processed, "results/processed_data.rds")
    saveRDS(broom::tidy(model), "results/regression_summary.rds")

    #tabel
}