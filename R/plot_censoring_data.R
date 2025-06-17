#' Pl
#'
#' @param dataset
#' @param label.size
#' @param point_size
#' @param min_n_MAA
#' @param use_shape
#' @param s_vjust test2
#' @param labelled_IDs test
#'
#' @return a ggplot
#' @importFrom ggplot2 ggplot geom_segment geom_point xlab ylab
#' @importFrom plotly ggplotly
#' @importFrom dplyr reframe bind_rows pull
#' @export
#'

plot_censoring_data = function(
    dataset = simulate_interval_censoring(),
    label.size = 5,
    point_size = 5,
    min_n_MAA = 5,
    use_shape = FALSE,
    s_vjust = 2,
    labelled_IDs = 2
)
{

  plot1 =
    dataset$pt_data |>
    standard_ggplot() +
    geom_point(
      size = point_size,
      data = dataset$obs_data0 |>
        filter(`HIV status` == "HIV-"),
      aes(
        x = .data$`O`,
        y = .data$ID,
        col = .data$`HIV status`,
        # if(use_shape) shape = .data$`HIV status`

      ),
      alpha = .5
    ) +

    # ggplot2::geom_text(
    #   data = dataset$obs_data0 |> filter(`HIV status` == "HIV-"),
    #   aes(
    #     x = .data$`O`,
    #     y = .data$ID,
    #     label = paste0("P[", `Obs ID`, "]")),
    #   vjust = 2,
    #   # label = "S_1",
    #   parse = TRUE
    # ) +


  ggrepel::geom_text_repel(
    data = dataset$pt_data |>
      filter(ID %in% labelled_IDs),
    size = label.size,
    aes(
      x = .data$E,
      y = .data$ID,
      # label = paste0("E[", `ID`, "]")
      label = "E"
    ),
    vjust = -1,
    parse = TRUE
  ) +

    ggrepel::geom_text_repel(
      data = dataset$pt_data |>
        filter(ID %in% labelled_IDs),
      size = label.size,
      aes(
        x = .data$L,
        y = .data$ID,
        # label = paste0("L[", `ID`, "]")
        label = "L"
      ),
      vjust = -1,
      # label = "S_1",
      parse = TRUE
    ) +

    ggrepel::geom_text_repel(
      data = dataset$pt_data |> filter(ID %in% labelled_IDs),
      size = label.size,
      aes(
        x = .data$R,
        y = .data$ID,
        # label = paste0("R[", `ID`, "]"),
        label = "R"
      ),
      vjust = -1,
      # label = "S_1",
      parse = TRUE
    ) +


    # ggpubr::geom_bracket(
    #   data = dataset$obs_data |> filter(ID %in% labelled_IDs),
    #   aes(
    #     xmin = S,
    #     xmax = O,
    #     y.position = ID - (`Obs ID` * .1),
    #     label = "T = O - S",
    #   ),
    #
    #   tip.length = 0.01
    # ) +

    geom_point(
      size = point_size,
      aes(
        x = .data$S,
        y = .data$ID,
        # if(use_shape) shape = "Seroconversion date (S)",
        col = "Seroconversion date (S)"
      ),
      alpha = .5

    ) +

    ggrepel::geom_text_repel(
      data = dataset$pt_data |> filter(ID %in% labelled_IDs),
      size = label.size,
      aes(
        x = .data$S,
        y = .data$ID,
        # label = paste0("(S[", ID, "])")
        label = "S"
      ),
      vjust = s_vjust,
      # hjust = 1,
      # label = "S_1",
      parse = TRUE
    ) +


    geom_segment(
      aes(
        x = .data$L,
        xend = .data$R,
        y = .data$ID,
        yend = .data$ID,
        # if(use_shape) shape = "Censoring interval",
        col = "Censoring interval")
    ) +

    geom_point(
      size = point_size,
      data = dataset$obs_data,
      aes(
        x = .data$`O`,
        y = .data$ID,
        # col = `MAA status`,
        col = "HIV+",
        shape = `MAA status`

      ),
      alpha = .5
    ) +

    ggrepel::geom_text_repel(
      data = dataset$obs_data |> filter(ID %in% labelled_IDs),
      size = label.size,
      aes(
        x = .data$`O`,
        y = .data$ID,
        # label = paste0("O[list(", `ID`,", ", `Obs ID`, ")]"),
        label = paste0("O[", `Obs ID`, "]")
      ),
      vjust = 2,
      min.segment.length = 0,
      # label = "S_1",
      parse = TRUE
    ) +

    xlab("Event date") +
    ylab('Participant ID #') +
    # ggplot2::scale_y_discrete(
    #   name = 'Participant ID #',
    #   # trans = "reverse",
    #   breaks = unique(dataset$pt_data$ID),
    #   limits = seq(0, nrow(dataset$pt_data) + 2) |> as.integer()
    # ) +
    # dplyr::expand_limits(y = c(0, nrow(dataset$pt_data) + 2)) +
    xlim(
      min(dataset$pt_data$E) - months(1),
      dataset$obs_data |> filter(`Obs ID` == min_n_MAA) |> pull(O) |> max())
    # ylab('Participant ID #') +



}
