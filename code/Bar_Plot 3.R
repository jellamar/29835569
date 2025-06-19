bar_plot <- function(data, xvar, yvar, fill = NULL) {
    if (is.null(fill)) {ggplot(data, aes_string(x = xvar, y = yvar)) +
            geom_bar(stat = "identity")}
    else {ggplot(data, aes_string(x = xvar, y = yvar, fill = fill)) +
            geom_bar(stat = "identity", position = "dodge")}} +
    scale_x_continuous(breaks = seq(min(data[[xvar]]), max(data[[xvar]]), by = 5),
        limits = c(min(data[[xvar]]), max(data[[xvar]])))
