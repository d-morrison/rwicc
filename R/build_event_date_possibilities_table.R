#' Build table of event date possibilities
#'
#' @param participant_level_data a [data.frame]
#' @param omega.hat
#' @inheritParams  build_omega_table
#'
#' @return a data.frame
#' @export
#'
#' @examples
build_event_date_possibilities_table = function(
    participant_level_data,
    bin_width = 1,
    omega.hat =
      participant_level_data |>
      build_omega_table(bin_width = bin_width))
{
  participant_level_data %>%
    dplyr::select(ID, Stratum, L, R) %>%
    dplyr::left_join(omega.hat, by = "Stratum") %>%
    dplyr::filter(L <= S, S <= R) %>%
    dplyr::select(-c(L, R))
}
