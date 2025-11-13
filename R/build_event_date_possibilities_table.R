#' Build table of event date possibilities
#'
#' @param participant_level_data a [data.frame] with columns:
#' * ID: participant identifier
#' * Stratum: indicator for which population stratum the participant belongs to
#' * E: study entry date
#' * L: left censoring interval endpoint
#' * R: left censoring interval endpoint
#' @param omega.hat a [data.frame] from [build_omega_table()] representing the
#' seroconversion hazard model.
#' @inheritParams  build_omega_table
#'
#' @returns a [data.frame] with columns:
#' * ID: participant identifier
#' * Stratum: indicator for which population stratum the participant belongs to
#' * S: possible seroconversion dates
#' @export
#'
#' @examples
#' simulate_interval_censoring()$pt_data |>
#' mutate(Stratum = 1) |>
#' build_event_date_possibilities_table()
build_event_date_possibilities_table = function(
    participant_level_data,
    bin_width = 1,
    omega.hat =
      participant_level_data |>
      build_omega_table(bin_width = bin_width))
{
  participant_level_data |>
    dplyr::select(ID, Stratum, L, R) |>
    dplyr::left_join(omega.hat, by = "Stratum") |>
    dplyr::filter(L <= S, S <= R) |>
    dplyr::select(-c(L, R))
}
