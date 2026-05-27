#' Plot simulated seroconversion density curves
#'
#' Plots example seroconversion-time densities for several intercept/slope
#' hazard combinations.
#'
#' @returns a [ggplot2::ggplot]
#' @keywords internal
graph_simulated_densities <- function() {
  ggplot2::ggplot() +
    ggplot2::theme_classic() +
    ggplot2::theme(
      text = ggplot2::element_text(size = 15),
      legend.position = "bottom"
    ) +
    ggplot2::geom_function(
      fun = seroconversion_density_function,
      args = list(intercept = 0, slope = .5), ggplot2::aes(col = "0+0.5t")
    ) +
    ggplot2::geom_function(
      fun = seroconversion_density_function,
      args = list(intercept = 0, slope = 1), ggplot2::aes(col = "0+1t")
    ) +
    ggplot2::geom_function(
      fun = seroconversion_density_function,
      args = list(intercept = 0, slope = 2), ggplot2::aes(col = "0+2t")
    ) +
    ggplot2::geom_function(
      fun = seroconversion_density_function,
      args = list(intercept = 1, slope = 0), ggplot2::aes(col = "1+ 0t")
    ) +
    ggplot2::geom_function(
      fun = seroconversion_density_function,
      args = list(intercept = 1, slope = .5), ggplot2::aes(col = "1+0.5t")
    ) +
    ggplot2::geom_function(
      fun = seroconversion_density_function,
      args = list(intercept = 10, slope = 0), ggplot2::aes(col = "10+ 0t")
    ) +
    ggplot2::geom_function(
      fun = seroconversion_density_function,
      args = list(intercept = 10, slope = .5), ggplot2::aes(col = "10+0.5t")
    ) +
    ggplot2::xlim(0, 2) +
    ggplot2::xlab("Time since study start (years)") +
    ggplot2::ylim(0, 12) +
    ggplot2::ylab("p(S=s|E=0)") +
    # ggplot2::scale_y_log10() +
    ggplot2::labs(col = "")
}
