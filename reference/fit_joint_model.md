# Fit a logistic regression model with an interval-censored covariate

This function fits a logistic regression model for a binary outcome Y
with an interval-censored covariate T, using an EM algorithm, as
described in Morrison et al (2021);
[doi:10.1111/biom.13472](https://doi.org/10.1111/biom.13472) .

## Usage

``` r
fit_joint_model(
  participant_level_data,
  obs_level_data,
  model_formula = stats::formula(Y ~ T),
  mu_function = compute_mu,
  bin_width = 1,
  denom_offset = 0.1,
  EM_toler_loglik = 0.1,
  EM_toler_est = 1e-04,
  EM_max_iterations = Inf,
  glm_tolerance = 1e-07,
  glm_maxit = 20,
  initial_S_estimate_location = 0.25,
  coef_change_metric = "max abs rel diff coefs",
  verbose = FALSE
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

- model_formula:

  the functional form for the regression model for p(y\|t) (as a
  formula() object)

- mu_function:

  a function taking a vector of regression coefficient estimates as
  input and outputting an estimate of mu (mean duration of MAA-positive
  infection).

- bin_width:

  the number of days between possible seroconversion dates (should be an
  integer)

- denom_offset:

  an offset value added to the denominator of the hazard estimates to
  improve numerical stability

- EM_toler_loglik:

  the convergence cutoff for the log-likelihood criterion ("Delta_L" in
  the paper)

- EM_toler_est:

  the convergence cutoff for the parameter estimate criterion
  ("Delta_theta" in the paper)

- EM_max_iterations:

  the number of EM iterations to perform before giving up if still not
  converged.

- glm_tolerance:

  the convergence cutoff for the glm fit in the M step

- glm_maxit:

  the iterations cutoff for the glm fit in the M step

- initial_S_estimate_location:

  determines how seroconversion date is guessed to initialize the
  algorithm; can be any decimal between 0 and 1; 0.5 = midpoint
  imputation, 0.25 = 1st quartile, 0 = last negative, etc.

- coef_change_metric:

  a string indicating the type of parameter estimate criterion to use:

  - "max abs rel diff coefs" is the "Delta_theta" criterion described in
    the paper.

  - "max abs diff coefs" is the maximum absolute change in the
    coefficients (not divided by the old values); this criterion can be
    useful when some parameters are close to 0.

  - "diff mu" is the absolute change in mu, which may be helpful in the
    incidence estimate calibration setting but not elsewhere.

- verbose:

  whether to print algorithm progress details to the console

## Value

a list with the following elements:

- `Theta`: the estimated regression coefficients for the model of
  p(Y\|T)

- `Mu`: the estimated mean window period (a transformation of `Theta`)

- `Omega`: a table with the estimated parameters for the model of
  p(S\|E).

- `converged`: indicator of whether the algorithm reached its cutoff
  criteria before reaching the specified maximum iterations. 1 = reached
  cutoffs, 0 = not.

- `iterations`: the number of EM iterations completed before the
  algorithm stopped.

- `convergence_metrics`: the four convergence metrics

## References

Morrison, Laeyendecker, and Brookmeyer (2021). "Regression with
interval-censored covariates: Application to cross-sectional incidence
estimation". Biometrics.
[doi:10.1111/biom.13472](https://doi.org/10.1111/biom.13472) .

## Examples

``` r
if (FALSE) { # \dontrun{

# simulate data:
study_data <- simulate_interval_censoring()

# fit model:
EM_algorithm_outputs <- fit_joint_model(
  obs_level_data = study_data$obs_data,
  participant_level_data = study_data$pt_data
)
} # }
```
