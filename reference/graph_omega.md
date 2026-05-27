# Graph seroconversion hazard model

Graph seroconversion hazard model

## Usage

``` r
graph_omega(omega)
```

## Arguments

- omega:

  a [data.frame](https://rdrr.io/r/base/data.frame.html) containing
  parameter values for the seroconversion hazard model

## Value

a [ggplot2::ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)

## Examples

``` r
example_model <-
  fs::path_package("rwicc", "extdata/example_model.rds") |>
  readRDS()
omega_est_EM <- example_model$Omega
omega_est_EM |> graph_omega()

```
