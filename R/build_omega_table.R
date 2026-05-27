#' Build table of dates with possible seroconversions in dataset
#'
#' @param participant_level_data a [data.frame] with columns:
#' * Stratum: indicator for which population stratum the participant belongs to
#' * L: left censoring interval endpoint
#' * R: right censoring interval endpoint
#' @param bin_width number of days per bin
#'
#' @returns a [data.frame]
#' @export
#'
build_omega_table = function(
    participant_level_data,
    bin_width = 1)
{
  participant_level_data |>
    dplyr::reframe(
      .by = "Stratum",
      S = seq(min(.data$L), max(.data$R), by = bin_width)
    )
}
