# Build table of event date possibilities

Build table of event date possibilities

## Usage

``` r
build_event_date_possibilities_table(
  participant_level_data,
  bin_width = 1,
  omega_hat = build_omega_table(participant_level_data, bin_width = bin_width)
)
```

## Arguments

- participant_level_data:

  a [data.frame](https://rdrr.io/r/base/data.frame.html) with columns:

  - ID: participant identifier

  - Stratum: indicator for which population stratum the participant
    belongs to

  - E: study entry date

  - L: left censoring interval endpoint

  - R: right censoring interval endpoint

- bin_width:

  number of days per bin

- omega_hat:

  a [data.frame](https://rdrr.io/r/base/data.frame.html) from
  [`build_omega_table()`](https://d-morrison.github.io/rwicc/reference/build_omega_table.md)
  representing the seroconversion hazard model.

## Value

a [data.frame](https://rdrr.io/r/base/data.frame.html) with columns:

- ID: participant identifier

- Stratum: indicator for which population stratum the participant
  belongs to

- S: possible seroconversion dates

## Examples

``` r
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union
simulate_interval_censoring()$pt_data |>
  mutate(Stratum = 1) |>
  build_event_date_possibilities_table()
#> # A tibble: 17,558 × 3
#>    ID    Stratum S         
#>    <fct>   <dbl> <date>    
#>  1 1           1 2002-07-09
#>  2 1           1 2002-07-10
#>  3 1           1 2002-07-11
#>  4 1           1 2002-07-12
#>  5 1           1 2002-07-13
#>  6 1           1 2002-07-14
#>  7 1           1 2002-07-15
#>  8 1           1 2002-07-16
#>  9 1           1 2002-07-17
#> 10 1           1 2002-07-18
#> # ℹ 17,548 more rows
```
