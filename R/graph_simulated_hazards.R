#' Plot simulated seroconversion hazard curves
#'
#' Plots example linear seroconversion hazards for several intercept/slope
#' combinations.
#'
#' @returns a [ggplot2::ggplot]
#' @keywords internal
graph_simulated_hazards <- function() {
  ggplot2::ggplot() +
    ggplot2::theme_classic() +
    ggplot2::theme(
      text = ggplot2::element_text(size = 15),
      legend.position = "bottom"
    ) +
    ggplot2::geom_abline(
      ggplot2::aes(intercept = 0, slope = .5, col = "0+0.5t")
    ) +
    ggplot2::geom_abline(
      ggplot2::aes(intercept = 0, slope = 1, col = "0+1t")
    ) +
    ggplot2::geom_abline(
      ggplot2::aes(intercept = 0, slope = 2, col = "0+2t")
    ) +
    ggplot2::geom_abline(
      ggplot2::aes(intercept = 1, slope = 0, col = "1+ 0t")
    ) +
    ggplot2::geom_abline(
      ggplot2::aes(intercept = 1, slope = .5, col = "1+0.5t")
    ) +
    ggplot2::geom_abline(
      ggplot2::aes(intercept = 10, slope = 0, col = "10+ 0t")
    ) +
    ggplot2::geom_abline(
      ggplot2::aes(intercept = 10, slope = .5, col = "10+0.5t")
    ) +
    ggplot2::xlim(0, 2) +
    ggplot2::ylab("Hazard, p(S=s|S \u2265 s)") +
    ggplot2::xlab("Time since study start (s, years)") +
    ggplot2::ylim(0, 12) +
    ggplot2::labs(col = "")
}
