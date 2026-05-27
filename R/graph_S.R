#' Plot the estimated seroconversion-date distribution for one participant
#'
#' @param subject_level_data_possibilities a [data.frame] of per-subject
#'   seroconversion-date possibilities with their estimated probabilities
#' @param id the participant ID to plot
#' @returns a [ggplot2::ggplot]
#' @keywords internal
graph_S <- function(
  subject_level_data_possibilities,
  id = 1
) {
  subject_level_data_possibilities |>
    dplyr::filter(.data$ID == id) |>
    ggplot2::ggplot() +
    ggplot2::aes(
      x = .data$S,
      y = .data$`P(S=s|e,l,r,o,y)`,
      col = "P(S=s|e,l,r,o,y)"
    ) +
    ggplot2::geom_point() +
    ggplot2::geom_line() +
    ggplot2::geom_point(
      ggplot2::aes(y = .data$`P(S=s|E=e)`, col = "P(S=s|E=e)")
    ) +
    ggplot2::geom_line(
      ggplot2::aes(y = .data$`P(S=s|E=e)`, col = "P(S=s|E=e)")
    ) +
    ggplot2::geom_point(
      ggplot2::aes(y = .data$`P(Y=y|T=t)`, col = "P(Y=y|T=t)")
    ) +
    ggplot2::geom_line(
      ggplot2::aes(y = .data$`P(Y=y|T=t)`, col = "P(Y=y|T=t)")
    ) +
    ggplot2::xlab("Seroconversion date (s)") +
    ggplot2::ylab("Probability density or mass") +
    ggplot2::theme_classic() +
    ggplot2::theme(
      legend.position = "bottom",
      text = ggplot2::element_text(size = 15)
    )
}
