build_9_graphs <- function(data) {

plot_data <- data %>%
    filter(version == "studio") %>%
    mutate(Year = year, Artist_Group = case_when(
               artist == "Coldplay"  ~ "Coldplay",
               artist == "Metallica" ~ "Metallica",
               TRUE                  ~ "Other"
           )) %>%
    pivot_longer(cols = c(danceability, energy, loudness,
                          speechiness, acousticness, instrumentalness,
                          liveness, valence, tempo),
                 names_to  = "Feature",
                 values_to = "Value") %>%
    group_by(Year, Artist_Group, Feature) %>%  # Mittelwert pro Jahr & Gruppe
    summarise(Value = mean(Value, na.rm = TRUE), .groups = "drop")

ggplot(plot_data,
       aes(x = Year, y = Value, colour = Artist_Group)) +
    geom_line(linewidth = 1) +
    facet_wrap(~ Feature, ncol = 3, scales = "free_y") +
    scale_colour_manual(values = c("Coldplay"  = "#FFA07A",
                                   "Metallica" = "#87CEFA",
                                   "Other"     = "grey60")) +
    theme_minimal(base_size = 11) +
    theme(legend.position = "bottom",
          strip.text = element_text(face = "bold"))


}