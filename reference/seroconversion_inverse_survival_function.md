# Inverse survival function for time-to-event variable with linear hazard function

This function determines the seroconversion date corresponding to a
provided probability of survival. See
[doi:10.1111/biom.13472](https://doi.org/10.1111/biom.13472) ,
Supporting Information, Section A.4.

## Usage

``` r
seroconversion_inverse_survival_function(u, e, hazard_alpha, hazard_beta)
```

## Arguments

- u:

  a vector of seroconversion survival probabilities

- e:

  a vector of time differences between study start and enrollment (in
  years)

- hazard_alpha:

  the instantaneous hazard of seroconversion on the study start date

- hazard_beta:

  the change in hazard per year after study start date

## Value

numeric vector of time differences between study start and
seroconversion (in years)

## References

Morrison, Laeyendecker, and Brookmeyer (2021). "Regression with
interval-censored covariates: Application to cross-sectional incidence
estimation". Biometrics,
[doi:10.1111/biom.13472](https://doi.org/10.1111/biom.13472) .
