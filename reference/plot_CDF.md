# plot estimated and true CDFs for seroconversion date distribution

plot estimated and true CDFs for seroconversion date distribution

## Usage

``` r
plot_CDF(true_hazard_alpha, true_hazard_beta, omega.hat)
```

## Arguments

- true_hazard_alpha:

  The data-generating hazard at the start of the study

- true_hazard_beta:

  The change in data-generating hazard per calendar year

- omega.hat:

  tibble of estimated discrete hazards

## Value

a ggplot

## Examples

``` r
if (FALSE) { # \dontrun{

hazard_alpha = 1
hazard_beta = 0.5
study_data <- simulate_interval_censoring(
  "hazard_alpha" = hazard_alpha,
  "hazard_beta" = hazard_beta)

# fit model:
EM_algorithm_outputs <- fit_joint_model(
  obs_level_data = study_data$obs_data,
  participant_level_data = study_data$pt_data
)
plot1 = plot_CDF(
  true_hazard_alpha = hazard_alpha,
  true_hazard_beta = hazard_beta,
  omega.hat = EM_algorithm_outputs$Omega)

print(plot1)
} # }
```
