# Plot censoring data

Plot censoring data

## Usage

``` r
plot_censoring_data(
  dataset,
  included_IDs = unique(dataset$pt_data$ID),
  label_size = 5,
  point_size = 5,
  s_vjust = 2,
  labelled_IDs = included_IDs,
  xmin = min(dataset$pt_data$E) - 28,
  xmax = max(dataset$obs_data$O)
)
```

## Arguments

- dataset:

  output from
  [`simulate_interval_censoring()`](https://d-morrison.github.io/rwicc/reference/simulate_interval_censoring.md)

- included_IDs:

  [character](https://rdrr.io/r/base/character.html)
  [vector](https://rdrr.io/r/base/vector.html) of IDs from `dataset` to
  include

- label_size:

  [numeric](https://rdrr.io/r/base/numeric.html): passed to
  [`ggrepel::geom_text_repel()`](https://ggrepel.slowkow.com/reference/geom_text_repel.html)'s
  `size` argument

- point_size:

  [numeric](https://rdrr.io/r/base/numeric.html): passed to
  [ggplot2::geom_point](https://ggplot2.tidyverse.org/reference/geom_point.html)'s
  `size` argument

- s_vjust:

  passed to
  [ggrepel::geom_text_repel](https://ggrepel.slowkow.com/reference/geom_text_repel.html)'s
  `vjust` argument

- labelled_IDs:

  [character](https://rdrr.io/r/base/character.html)
  [vector](https://rdrr.io/r/base/vector.html) indicating which IDs to
  label events for

- xmin:

  minimum displayed value for x-axis

- xmax:

  maximum displayed value for x-axis

## Value

a ggplot
