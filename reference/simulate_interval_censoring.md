# Simulate a dataset with interval-censored seroconversion dates

`simulate_interval_censoring` generates a simulated data set from a
data-generating model based on the typical structure of a cohort study
of HIV biomarker progression, as described in Morrison et al (2021);
[doi:10.1111/biom.13472](https://doi.org/10.1111/biom.13472) .

## Usage

``` r
simulate_interval_censoring(
  study_cohort_size = 4500,
  hazard_alpha = 1,
  hazard_beta = 0.5,
  preconversion_interval_length = 84,
  theta = c(0.986, -3.88),
  probability_of_ever_seroconverting = 0.05,
  years_in_study = 10,
  max_scheduling_offset = 7,
  days_from_study_start_to_recruitment_end = 365,
  study_start_date = lubridate::ymd("2001-01-01")
)
```

## Arguments

- study_cohort_size:

  the number of participants to simulate (N_0 in the paper)

- hazard_alpha:

  the hazard (instantaneous risk) of seroconversion at the start date of
  the cohort study for those participants at risk of seroconversion

- hazard_beta:

  the change in hazard per calendar year

- preconversion_interval_length:

  the number of days between tests for seroconversion

- theta:

  the parameters of a logistic model (with linear functional from)
  specifying the probability of MAA-positive biomarkers as a function of
  time since seroconversion

- probability_of_ever_seroconverting:

  the probability that each participant is at risk of HIV seroconversion

- years_in_study:

  the duration of follow-up for each participant

- max_scheduling_offset:

  the maximum divergence of pre-seroconversion followup visits from the
  prescribed schedule

- days_from_study_start_to_recruitment_end:

  the length of the recruitment period

- study_start_date:

  the date when the study starts recruitment ("d_0" in the main text).
  The value of this parameter does not affect the simulation results; it
  is only necessary as a reference point for generating E, L, R, O, and
  S.

## Value

A list containing the following two tibbles:

- `pt_data`: a tibble of participant-level information, with the
  following columns:

  - `ID`: participant ID

  - `E`: enrollment date

  - `L`: date of last HIV test prior to seroconversion

  - `R`: date of first HIV test after seroconversion

- `obs_data`: a tibble of longitudinal observations with the following
  columns:

  - `ID`: participant ID

  - `O`: dates of biomarker sample collection

  - `Y`: MAA classifications of biomarker samples

## References

Morrison, Laeyendecker, and Brookmeyer (2021). "Regression with
interval-censored covariates: Application to cross-sectional incidence
estimation". Biometrics.
[doi:10.1111/biom.13472](https://doi.org/10.1111/biom.13472) .

## Examples

``` r
study_data <- simulate_interval_censoring()
participant_characteristics <- study_data$pt_data
longitudinal_observations <- study_data$obs_data
```
