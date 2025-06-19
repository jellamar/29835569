scatter_plot <- function(data, xvar, yvar, group = NULL)
                    {if (is.null(group))
                        {ggplot(data, aes_string(x = xvar, y = yvar)) +
                        geom_point()}
                    else {ggplot(data, aes_string(x = xvar, y = yvar, color = group)) +
                        geom_point()}}
