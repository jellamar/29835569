line_plot <- function(data, xvar, yvar, group = NULL) {
    plot <- if (is.null(group)) {ggplot(data, aes(x = .data[[xvar]], y = .data[[yvar]])) +
            geom_line()
    } else {ggplot(data, aes(x = .data[[xvar]], y = .data[[yvar]], color = .data[[group]], group = .data[[group]])) +
            geom_line()}

    plot + scale_x_continuous(breaks = seq(min(data[[xvar]]), max(data[[xvar]]), by = 10),
                              limits = c(min(data[[xvar]]), max(data[[xvar]])))
}