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
