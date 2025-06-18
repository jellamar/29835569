merge_df <- function (df1, df2) {
    df1 <- df1 %>% mutate(title = str_squish(tolower(title)))

    df2 <- df2 %>%
        mutate(genres = listed_in, title = str_squish(tolower(title))) %>%
        select(-show_id, -listed_in)

    merged <- df1 %>%
        left_join(df2, by = c("title" = "title", "release_year" = "release_year"))

    source("code/region_map.R")

    # split cells with multiple country entries

    merged <- merged %>%
        separate_rows(country, sep = ",") %>%
        mutate(country = str_trim(country))

    region_data <- merged %>%
        left_join(region_map, by = "country")

    saveRDS(region_data, "results/region_data.rds")
}