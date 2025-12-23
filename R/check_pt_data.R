#' Validate participant-level data
#'
#' Internal helper function that performs basic validation checks on
#' participant-level data to ensure data integrity before model fitting.
#'
#' @param participant_level_data A data.frame or tibble containing
#'   participant-level data with at least the following columns:
#'   * `ID`: participant ID
#'   * `L`: date of last negative test for seroconversion
#'   * `R`: date of first positive test for seroconversion
#'
#' @returns NULL (invisibly). The function throws an error if validation fails.
#'
#' @keywords internal
check_pt_data = function(participant_level_data)
{
  if (with(participant_level_data, any(L > R))) stop("L must be <= R!")

  if (with(participant_level_data, any(duplicated(ID)))) stop("duplicate IDs")
}
