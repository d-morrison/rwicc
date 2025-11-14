#' Graph seroconversion hazard model
#'
#' @param omega a [data.frame] containing parameter values for
#' the seroconversion hazard model
#'
#' @returns a [ggplot2::ggplot2]
#' @export
#'
#' @examples
#' example_model <-
#'   fs::path_package("rwicc", "extdata/example_model.rds") |>
#'   readRDS()
#' omega_est_EM <- example_model$Omega
#' omega_est_EM |> graph_omega()
#'
#'
graph_omega <- function(omega) {
  omega |>
    ggplot2::ggplot() +
    ggplot2::aes(
      x = .data$S,
      y = .data$`P(S=s|S>=s,E=e)`
    ) +
    ggplot2::geom_point(
      data = omega |> dplyr::filter(.data$`P(S=s|S>=s,E=e)` > 0),
      alpha = .5
    ) +
    ggplot2::geom_line(alpha = .5) +
    ggplot2::theme_classic() +
    ggplot2::xlab("Seroconversion date (s)") +
    ggplot2::ylab("P(S=s|S>=s)") +
    ggplot2::theme(
      text = ggplot2::element_text(size = 15)
    )
}
