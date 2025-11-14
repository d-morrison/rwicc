# Filter dataset by participant IDs

Internal helper function that filters all data frames within a dataset
structure to include only the specified participant IDs.

## Usage

``` r
filter_data_by_ID(dataset, included_IDs)
```

## Arguments

- dataset:

  A list containing data frames output from
  [`simulate_interval_censoring()`](https://d-morrison.github.io/rwicc/reference/simulate_interval_censoring.md),
  including `pt_data`, `obs_data0`, and `obs_data` components.

- included_IDs:

  A [character](https://rdrr.io/r/base/character.html)
  [vector](https://rdrr.io/r/base/vector.html) of participant IDs to
  retain in the filtered dataset.

## Value

A list with the same structure as `dataset`, but with all data frames
filtered to include only rows where the ID is in `included_IDs`.
