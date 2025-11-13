#' Plot censoring data
#'
#' @param dataset output from [simulate_interval_censoring()]
#' @param included_IDs [character] [vector] of IDs from `dataset` to include
#' @param label_size [numeric]:
#' passed to [ggrepel::geom_text_repel()]'s `size` argument
#' @param point_size
#' [numeric]: passed to [ggplot2::geom_point]'s `size` argument
#' @param s_vjust passed to [ggrepel::geom_text_repel]'s `vjust` argument
#' @param labelled_IDs [character] [vector]
#' indicating which IDs to label events for
#'
#' @return a ggplot
#' @importFrom ggplot2 ggplot geom_segment geom_point xlab ylab
#' @importFrom plotly ggplotly
#' @importFrom dplyr reframe bind_rows pull
#' @export
#'

plot_censoring_data <- function(
  dataset,
  included_IDs = unique(dataset$pt_data$ID),
  label_size = 5,
  point_size = 5,
  s_vjust = 2,
  labelled_IDs = included_IDs,
  xmin = min(dataset$pt_data$E) - months(1),
  xmax = max(dataset$obs_data$O)
) {

  dataset <- dataset |> filter_data_by_ID(included_IDs)

  plot1 <-
    dataset$pt_data |>
    dplyr::filter(.data$ID %in% included_IDs) |>
    standard_ggplot() +
    geom_point(
      size = point_size,
      data = dataset$obs_data0 |>
        filter(.data$`HIV status` == "HIV-"),
      aes(
        x = .data$`O`,
        y = .data$ID,
        col = .data$`HIV status`
      ),
      alpha = .5
    ) +

    ggrepel::geom_text_repel(
      data = dataset$pt_data |>
        filter(.data$ID %in% labelled_IDs),
      size = label_size,
      aes(
        x = .data$E,
        y = .data$ID,
        label = "E"
      ),
      vjust = -1,
      parse = TRUE
    ) +

    ggrepel::geom_text_repel(
      data = dataset$pt_data |>
        filter(.data$ID %in% labelled_IDs),
      size = label_size,
      aes(
        x = .data$L,
        y = .data$ID,
        label = "L"
      ),
      vjust = -1,
      parse = TRUE
    ) +

    ggrepel::geom_text_repel(
      data = dataset$pt_data |> filter(.data$ID %in% labelled_IDs),
      size = label_size,
      aes(
        x = .data$R,
        y = .data$ID,
        label = "R"
      ),
      vjust = -1,
      parse = TRUE
    ) +

    geom_point(
      size = point_size,
      aes(
        x = .data$S,
        y = .data$ID,
        col = "Seroconversion date (S)"
      ),
      alpha = .5
    ) +

    ggrepel::geom_text_repel(
      data = dataset$pt_data |> filter(.data$ID %in% labelled_IDs),
      size = label_size,
      aes(
        x = .data$S,
        y = .data$ID,
        label = "S"
      ),
      vjust = s_vjust,
      parse = TRUE
    ) +


    geom_segment(
      aes(
        x = .data$L,
        xend = .data$R,
        y = .data$ID,
        yend = .data$ID,
        col = "Censoring interval"
      )
    ) +

    geom_point(
      size = point_size,
      data = dataset$obs_data,
      aes(
        x = .data$`O`,
        y = .data$ID,
        col = "HIV+",
        shape = .data$`MAA status`
      ),
      alpha = .5
    ) +

    ggrepel::geom_text_repel(
      data = dataset$obs_data |> filter(.data$ID %in% labelled_IDs),
      size = label_size,
      aes(
        x = .data$`O`,
        y = .data$ID,
        label = paste0("O[", .data$`Obs ID`, "]")
      ),
      vjust = 2,
      min.segment.length = 0,
      parse = TRUE
    ) +

    xlab("Event date") +
    ylab("Participant ID #") +
    xlim(
      xmin,
      xmax
    )

  return(plot1)
}
