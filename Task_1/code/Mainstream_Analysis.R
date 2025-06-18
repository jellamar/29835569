mainstream_analysis <- function (data) {
                    data %>%
                        group_by(Year, Gender) %>%
                        slice_max(order_by = Count, n = 1) %>%
                        ungroup()

}