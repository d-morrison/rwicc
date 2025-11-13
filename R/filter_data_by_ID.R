#' Filter dataset by participant IDs
#'
#' Internal helper function that filters all data frames within a dataset
#' structure to include only the specified participant IDs.
#'
#' @param dataset A list containing data frames output from
#'   [simulate_interval_censoring()], including `pt_data`, `obs_data0`,
#'   and `obs_data` components.
#' @param included_IDs A [character] [vector] of participant IDs to retain
#'   in the filtered dataset.
#'
#' @return A list with the same structure as `dataset`, but with all
#'   data frames filtered to include only rows where the ID is in
#'   `included_IDs`.
#'
#' @keywords internal
filter_data_by_ID <- function(dataset, included_IDs) {
  dataset$pt_data <- dataset$pt_data |>
    dplyr::filter(.data$ID %in% included_IDs)
  dataset$obs_data0 <- dataset$obs_data0 |>
    dplyr::filter(.data$ID %in% included_IDs)
  dataset$obs_data <- dataset$obs_data |>
    dplyr::filter(.data$ID %in% included_IDs)

  return(dataset)
}
