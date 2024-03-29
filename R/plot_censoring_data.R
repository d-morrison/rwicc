#' Title
#'
#' @param dataset
#' @param label.size
#' @param point_size
#' @param min_n_MAA
#' @param use_shape
#' @param s_vjust
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
    s_vjust = 2
)
{

  plot1 =
    dataset$pt_data |>
    ggplot() +

    geom_point(
      size = point_size,
      data = dataset$obs_data0 |> filter(`HIV status` == "HIV-"),
      aes(
        x = .data$`O`,
        y = .data$ID,
        col = .data$`HIV status`,
        if(use_shape) shape = .data$`HIV status`

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
      size = label.size,
      aes(
        x = .data$L,
        y = .data$ID,
        label = paste0("L[", `ID`, "]")),
      vjust = -1,
      # label = "S_1",
      parse = TRUE
    ) +

    ggrepel::geom_text_repel(
      size = label.size,
      aes(
        x = .data$R,
        y = .data$ID,
        label = paste0("R[", `ID`, "]")),
      vjust = -1,
      # label = "S_1",
      parse = TRUE
    ) +



    geom_point(
      size = point_size,
      aes(
        x = .data$S,
        y = .data$ID,
        if(use_shape) shape = "Seroconversion date (S)",
        col = "Seroconversion date (S)"
      ),
      alpha = .5

    ) +

    ggrepel::geom_text_repel(
      size = label.size,
      aes(
        x = .data$S,
        y = .data$ID,
        label = paste0("(S[", ID, "])")),
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
        if(use_shape) shape = "censoring interval",
        col = "censoring interval")
    ) +

    geom_point(
      size = point_size,
      data = dataset$obs_data,
      aes(
        x = .data$`O`,
        y = .data$ID,
        # col = `MAA status`,
        col = "HIV+",
        if(use_shape) shape = `MAA status`

      ),
      alpha = .5
    ) +

    ggrepel::geom_text_repel(
      size = label.size,
      data = dataset$obs_data,
      aes(
        x = .data$`O`,
        y = .data$ID,
        label = paste0("O[list(", `ID`,", ", `Obs ID`, ")]")),
      vjust = 2,
      min.segment.length = 0,
      # label = "S_1",
      parse = TRUE
    ) +

    xlab("Event date") +
    ggplot2::scale_y_discrete(
      name = 'Participant ID #',
      # trans = "reverse",
      breaks = unique(dataset$pt_data$ID) |> rev(),
      limits = seq(0, nrow(dataset$pt_data) + 1) |> as.integer()
    ) +
    xlim(
      min(dataset$pt_data$E) - months(1),
      dataset$obs_data |> filter(`Obs ID` == min_n_MAA) |> pull(O) |> max()) +
    # ylab('Participant ID #') +
    ggplot2::theme_bw() +
    ggplot2::scale_color_discrete(name = "") +
    ggplot2::scale_shape_discrete(name = "") +
    ggplot2::theme(
      panel.border = element_blank(),
      # panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.line = element_line(colour = "black"),
      legend.position="bottom",
      text = element_text(size = 15)
    )


}
