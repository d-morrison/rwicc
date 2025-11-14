# Fit model using uniform imputation

Fit model using uniform imputation

## Usage

``` r
fit_uniform_model(
  participant_level_data,
  obs_level_data,
  maxit = 1000,
  tolerance = 1e-08,
  n_imputations = 10
)
```

## Arguments

- participant_level_data:

  a data.frame or tibble with the following variables:

  - ID: participant ID

  - E: study enrollment date

  - L: date of last negative test for seroconversion

  - R: date of first positive test for seroconversion

  - Cohort\` (optional): this variable can be used to stratify the
    modeling of the seroconversion distribution.

- obs_level_data:

  a data.frame or tibble with the following variables:

  - ID: participant ID

  - O: biomarker sample collection dates

  - Y: MAA classifications (binary outcomes)

- maxit:

  maximum iterations, passed to `bigglm`

- tolerance:

  convergence criterion, passed to `bigglm`

- n_imputations:

  number of imputed data sets to create

## Value

a vector of logistic regression coefficient estimates

## Examples

``` r
sim_data = simulate_interval_censoring(
  "theta" = c(0.986, -3.88),
  "study_cohort_size" = 4500,
  "preconversion_interval_length" = 365,
  "hazard_alpha" = 1,
  "hazard_beta" = 0.5)

theta_est_midpoint = fit_uniform_model(
  obs_level_data = sim_data$obs_data,
  participant_level_data = sim_data$pt_data
)
```
