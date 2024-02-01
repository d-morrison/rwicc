#' Build table of dates with possible seroconversions in dataset
#'
#' @param participant_level_data a [data.frame]
#' @param bin_width number of days per bin
#'
#' @return a [data.frame]
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
