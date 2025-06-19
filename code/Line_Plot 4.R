line_plot <- function(data, xvar, yvar, group = NULL)
    {if (is.null(group))
        {ggplot(data, aes(x = xvar, y = yvar)) +
         geom_line()}
    else {ggplot(data, aes(x = xvar, y = yvar, color = group, group = group)) +
            geom_line()}} +
    scale_x_continuous(breaks = seq(min(data[[xvar]]), max(data[[xvar]]), by = 5),
                        limits = c(min(data[[xvar]]), max(data[[xvar]])))
