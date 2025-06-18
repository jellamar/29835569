check_data <- function(data_frame, column) {
    na_count <- sum(is.na(data_frame$column))
    dup_count <- sum(duplicated(data_frame$column))

    invisible(list(NA_Count = na_count, Duplicate_Count = dup_count))
}
