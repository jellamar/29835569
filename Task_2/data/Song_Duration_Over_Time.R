song_duration_over_time <- function() {
    song_duration <- bands %>%
        filter(version == "studio") %>%
        mutate(Artist_Group = case_when(
            artist == "Coldplay" ~ "Coldplay",
            artist == "Metallica" ~ "Metallica",
            TRUE ~ "Other"), Year = year) %>%
        group_by(Artist_Group, Year) %>%
        summarize(Average_Duration = mean(duration)) %>%
        ungroup()

    source("code/Line_Plot.R")
    line_plot(song_duration, "Year", "Average_Duration", "Artist_Group")
}