# Seroconversion hazard function

Linear instantaneous hazard of seroconversion, `intercept + slope * t`,
equal to zero before `entry_time`.

## Usage

``` r
seroconversion_hazard_function(t, intercept, slope, entry_time = 0)
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

a numeric vector of hazard values
