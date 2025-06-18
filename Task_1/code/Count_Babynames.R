count_babynames <- function(data) {
    data %>%
        group_by(Year) %>%
        summarize(Total = sum(Count))
}

