music_check <- function(data) {

     spikes <- readRDS("results/spikes.rds")

     top_20_artists_songs_year <- data %>%
         mutate(Year = year(date)) %>%
         filter(Year >= 1910, Year <= 2014) %>%
         group_by(Year, artist, song) %>%
         summarise(Total_Weeks = sum(`weeks-on-board`, na.rm = TRUE)) %>%
         ungroup() %>%
         arrange(Year, desc(Total_Weeks)) %>%
         group_by(Year) %>%
         slice_max(order_by = Total_Weeks, n = 20) %>%
         ungroup()

     # collapse all artist and song strings for partial detection
     all_artists <- paste(top_20_artists_songs_year$artist, collapse = " ")
     all_songs <- paste(top_20_artists_songs_year$song, collapse = " ")

     spikes <- spikes %>%
         mutate(In_Artist = str_detect(all_artists, fixed(Name)),
                In_Song = str_detect(all_songs, fixed(Name)))

     saveRDS(spikes, "results/spikes.rds")


 }