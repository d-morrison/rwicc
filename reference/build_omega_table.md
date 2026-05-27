# Build table of dates with possible seroconversions in dataset

Build table of dates with possible seroconversions in dataset

## Usage

``` r
build_omega_table(participant_level_data, bin_width = 1)
```

## Arguments

- participant_level_data:

  a [data.frame](https://rdrr.io/r/base/data.frame.html) with columns:

  - Stratum: indicator for which population stratum the participant
    belongs to

  - L: left censoring interval endpoint

  - R: right censoring interval endpoint

- bin_width:

  number of days per bin

## Value

a [data.frame](https://rdrr.io/r/base/data.frame.html)
