
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rwicc

<!-- badges: start -->
<!-- badges: end -->

The goal of rwicc (“Regression With Interval-Censored Covariates”) is to
implement a regression modeling analysis with an interval-censored
covariate, as described in “Regression with Interval-Censored
Covariates: Application to Cross-Sectional Incidence Estimation” by
Morrison, Laeyendecker, and Brookmeyer (2021) in Biometrics
(<https://doi.org/10.1111/biom.13472>).

## Installation

You can install the released version of rwicc from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("rwicc")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("d-morrison/rwicc")
```

## Example of use

Here, we simulate some data:

``` r
library(rwicc)
#> Registered S3 method overwritten by 'pryr':
#>   method      from
#>   print.bytes Rcpp

theta_true = c(0.986, -3.88)
study_cohort_size = 4500
preconversion_interval_length = 365
hazard_alpha = 1
hazard_beta = 0.5

set.seed(1)
sim_data = simulate_interval_censoring(
  theta = theta_true,
  "study_cohort_size" = study_cohort_size,
  "preconversion_interval_length" = preconversion_interval_length,
  "hazard_alpha" = hazard_alpha,
  "hazard_beta" = hazard_beta)

# extract the participant-level and observation-level simulated data:
sim_participant_data = sim_data$pt_data
sim_obs_data = sim_data$obs_data
rm(sim_data)
```

Here, we apply our proposed analysis (this takes a couple of minutes;
use argument `verbose = TRUE` to print progress messages):

``` r
# this call runs the estimation algorithm for the joint modeling approach:
EM_algorithm_outputs = seroconversion_EM_algorithm(
  obs_level_data = sim_obs_data,
  subject_level_data = sim_participant_data,
  bin_width = 7,
  verbose = FALSE)

# extract the estimated mean window period duration from the algorithm's results:
mu_est_EM = EM_algorithm_outputs$Mu
```
