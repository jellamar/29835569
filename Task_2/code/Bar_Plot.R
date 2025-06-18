bar_plot <- function(data, xvar, yvar, fill = NULL) {
    data[[xvar]] <- as.numeric(data[[xvar]])
    p <- if (is.null(fill)) {
        ggplot(data, aes(x = .data[[xvar]], y = .data[[yvar]])) +
            geom_bar(stat = "identity")}
    else {
        ggplot(data, aes(x = .data[[xvar]], y = .data[[yvar]], fill = .data[[fill]])) +
            geom_bar(stat = "identity", position = "dodge")}

    if (is.numeric(data[[xvar]])) {
        p <- p + scale_x_continuous(breaks = seq(min(data[[xvar]]), max(data[[xvar]]), by = 5),
                                    limits = c(min(data[[xvar]]), max(data[[xvar]])))}

    return(p)
}