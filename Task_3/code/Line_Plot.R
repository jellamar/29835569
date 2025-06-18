line_plot <- function(data, xvar, yvar, group = NULL) {
    if (is.null(group)) {
        p <- ggplot(data, aes(x = !!sym(xvar), y = !!sym(yvar))) +
            geom_line()
    } else {
        p <- ggplot(data, aes(x = !!sym(xvar), y = !!sym(yvar), color = !!sym(group))) +
            geom_line()
    }

    p + scale_x_continuous(
        breaks = seq(min(data[[xvar]], na.rm = TRUE),
                     max(data[[xvar]], na.rm = TRUE), by = 10),
        limits = c(min(data[[xvar]], na.rm = TRUE),
                   max(data[[xvar]], na.rm = TRUE))
    )
}
