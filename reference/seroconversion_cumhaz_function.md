# Seroconversion cumulative hazard function

Cumulative hazard obtained by integrating
[`seroconversion_hazard_function()`](https://d-morrison.github.io/rwicc/reference/seroconversion_hazard_function.md).

## Usage

``` r
seroconversion_cumhaz_function(t, intercept, slope, entry_time = 0)
```

## Arguments

- t:

  numeric vector of times since study start (years)

- intercept:

  hazard at study start

- slope:

  change in hazard per year

- entry_time:

  time of study entry; the hazard is zero before this

## Value

a numeric vector of cumulative hazard values
