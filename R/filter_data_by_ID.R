filter_data_by_ID <- function(dataset, included_IDs) {
  dataset$pt_data <- dataset$pt_data |>
    dplyr::filter(.data$ID %in% included_IDs)
  dataset$obs_data0 <- dataset$obs_data0 |>
    dplyr::filter(.data$ID %in% included_IDs)
  dataset$obs_data <- dataset$obs_data |>
    dplyr::filter(.data$ID %in% included_IDs)

  return(dataset)
}
