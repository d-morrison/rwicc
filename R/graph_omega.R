graph_omega = function(omega)
{
  omega |>
  ggplot(
    aes(
      x = S,
      y = `P(S=s|S>=s,E=e)`)
  ) +
    geom_point(
      data = omega |> dplyr::filter(`P(S=s|S>=s,E=e)` > 0),
      alpha = .5) +
    geom_line(alpha = .5) +
    theme_classic() +
    xlab("Seroconversion date (s)") +
    ylab("P(S=s|S>=s)") +
    theme(
      text = element_text(size = 15)
    )
}
