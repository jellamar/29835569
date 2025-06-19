spike_analysis <- function(data) {

    # summarize on country level

    name_trends <- baby_names %>%
        group_by(Year, Name, Gender) %>%
        summarise(Count = sum(Count)) %>%
        ungroup()

    # add Pct_Change column to check for changes in names between years

    spikes <- name_trends %>%
        arrange(Name, Gender, Year) %>%
        group_by(Name, Gender) %>%
        mutate(Pct_Change = (Count - lag(Count)) / lag(Count) * 100) %>%
        mutate(Big_Spike = !is.na(Pct_Change) & Pct_Change > 1000) %>%
        arrange(desc(Pct_Change)) %>%
        ungroup()

    # display and save results

    top_spikes_table <- spikes %>%
        select(Year, Name, Gender, Pct_Change) %>%
        head(15)

    saveRDS(spikes, "results/spikes.rds")
    saveRDS(top_spikes_table, "results/top_spikes.rds")


}