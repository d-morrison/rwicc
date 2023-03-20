#' Title
#'
#' @param dataset
#'
#' @return
#' @importFrom ggplot2 ggplot geom_segment geom_point xlab ylab
#' @importFrom plotly ggplotly
#' @export
#'

plot_censoring_data = function(
    dataset = simulate_interval_censoring()
    )
{

  plot1 =
    dataset$pt_data |>
    ggplot() +
    geom_point()
    geom_segment(
      aes(
        x = L,
        xend = R,
        y = E,
        yend = E)
      ) +
    xlab("Possible seroconversion dates") +
    ylab('Enrollment date')

}
