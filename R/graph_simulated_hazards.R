# "2001-01-01"
# "2002-01-03"
graph_simulated_hazards = function()
{

  ggplot() +
    theme_classic() +
    theme(
      text = element_text(size = 15),
      legend.position = "bottom"
    ) +
    ggplot2::geom_abline(aes(intercept = 0, slope = .5, col = "0+0.5t")) +
    ggplot2::geom_abline(aes(intercept = 0, slope = 1,  col = "0+1t")) +
    ggplot2::geom_abline(aes(intercept = 0, slope = 2,  col = "0+2t")) +
    ggplot2::geom_abline(aes(intercept = 1, slope = 0,  col = "1+ 0t")) +
    ggplot2::geom_abline(aes(intercept = 1, slope = .5,  col = "1+0.5t")) +
    ggplot2::geom_abline(aes(intercept = 10,slope = 0,  col = "10+ 0t")) +
    ggplot2::geom_abline(aes(intercept = 10,slope = .5,  col = "10+0.5t")) +
    xlim(0, 2) +
    ylab("Hazard, p(S=s|S≥s)") +
    xlab("Time since study start (s, years)") +
    ylim(0, 12) +
    ggplot2::labs(col = "")

}
