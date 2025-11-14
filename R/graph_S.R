graph_S = function(
    subject_level_data_possibilities,
    ID = 1)
{
  subject_level_data_possibilities |>
    dplyr::filter(ID == ID) |>
    ggplot2::ggplot() +
    ggplot2::aes(
      x = S,
      y = `P(S=s|e,l,r,o,y)`,
      col = "P(S=s|e,l,r,o,y)") +
    ggplot2::geom_point() +
    ggplot2::geom_line() +
    ggplot2::geom_point(aes(y = `P(S=s|E=e)`, col = "P(S=s|E=e)")) +
    ggplot2::geom_line(aes(y = `P(S=s|E=e)`, col = "P(S=s|E=e)")) +
    ggplot2::geom_point(aes(y = `P(Y=y|T=t)`, col = "P(Y=y|T=t)")) +
    ggplot2::geom_line(aes(y = `P(Y=y|T=t)`, col = "P(Y=y|T=t)")) +
    ggplot2::xlab("Seroconversion date (s)") +
    ggplot2::ylab("Probability density or mass") +
    ggplot2::theme_classic() +
    ggplot2::theme(
      legend.position = "bottom",
      text = ggplot2::element_text(size = 15)
    )
}
