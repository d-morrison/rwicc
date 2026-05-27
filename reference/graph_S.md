# Plot the estimated seroconversion-date distribution for one participant

Plot the estimated seroconversion-date distribution for one participant

## Usage

``` r
graph_S(subject_level_data_possibilities, id = 1)
```

## Arguments

- subject_level_data_possibilities:

  a [data.frame](https://rdrr.io/r/base/data.frame.html) of per-subject
  seroconversion-date possibilities with their estimated probabilities

- id:

  the participant ID to plot

## Value

a [ggplot2::ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)
