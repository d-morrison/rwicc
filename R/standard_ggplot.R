#' Create a ggplot with standard theme settings
#'
#' Internal helper function that initializes a ggplot object with consistent
#' theme and styling settings used across multiple plotting functions in the
#' package.
#'
#' @param data A data frame to be passed to [ggplot2::ggplot()].
#'
#' @return A [ggplot2::ggplot()] object with standard theme settings applied,
#'   including a black and white theme, custom axis styling, and legend
#'   positioning at the bottom.
#'
#' @keywords internal
standard_ggplot = function(data)
{
  data |>
    ggplot2::ggplot() +
    ggplot2::theme_bw() +
    ggplot2::scale_color_discrete(name = "") +
    ggplot2::scale_shape_discrete(name = "") +
    ggplot2::theme(
      panel.border = element_blank(),
      # panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.line = element_line(colour = "black"),
      legend.position="bottom",
      text = element_text(size = 15)
    )

}
