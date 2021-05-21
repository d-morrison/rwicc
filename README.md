
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rwicc

<!-- badges: start -->
<!-- badges: end -->

rwicc (“Regression With Interval-Censored Covariates”) is an R software
package implementing an analysis for a particular regression modeling
problem involving interval-censored covariates, as described in
“Regression with Interval-Censored Covariates: Application to
Cross-Sectional Incidence Estimation” by Morrison, Laeyendecker, and
Brookmeyer (2021) in Biometrics (<https://doi.org/10.1111/biom.13472>).

This analysis uses a joint model for the distributions of the outcome of
interest and the interval-censored covariates; the model is maximized
using an EM algorithm. The submodel used for the distribution of the
interval-censored covariate is somewhat specific to the application of
interest (estimation of the mean duration of a biomarker-defined window
period for cross-sectional incidence estimation), so this package may
not be immediately applicable to other problems. We are publishing it
with the goal of making the results in our paper easier to reproduce and
with the hope that others might adapt pieces of this code for their own
applications. Please feel free to [contact us](dezramorrison@gmail.com)
with any questions about the code or the paper!

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
install.packages("devtools")
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

Next, we perform alternative analyses using midpoint imputation and
uniform imputation:

``` r
max_iterations_for_glm_fits = 1000 
# bigglm's default maxit = 8, which is not large enough to ensure convergence for this data.
# I don't think any of the scenarios examined in our paper ever get close to 1000 iterations though; 
# this is effectively saying maxit = Inf.

# midpoint imputation:
{
  
  library(dplyr)
  library(magrittr)
  library(lubridate)
  library(biglm)
  
  sim_participant_data %<>%
    mutate(S_midpoint = L + (R - L) / ddays(2))
  
  sim_obs_data %<>%
    left_join(by = "ID",
              sim_participant_data %<>% dplyr::select(ID, S_midpoint)) %>%
    mutate(T_midpoint = (O - S_midpoint) / ddays(365))
  
  phi_model_est_midpoint =
    bigglm(
      epsilon = tolerance_for_glm_fits,
      maxit = max_iterations_for_glm_fits,
      quiet = TRUE,
      data = sim_obs_data,
      family = binomial(),
      Y ~ T_midpoint
    )
  
  mu_est_midpoint = compute_mu(coef(phi_model_est_midpoint))
  
}
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
#> 
#> Attaching package: 'lubridate'
#> The following objects are masked from 'package:base':
#> 
#>     date, intersect, setdiff, union
#> Loading required package: DBI

# uniform imputation:
{
  n_imputations = 100 # 10 would be enough
  
  # create a matrix to store the results from each imputed data set
  imputed_coef_ests = matrix(nrow = n_imputations,
                             ncol = 2,
                             dimnames = list(NULL, c("theta0", "theta1")))
  
  for (i in 1:n_imputations)
  {
    
    sim_participant_data %<>%
      mutate(S_imputed =
               L +
               runif(
                 n = n(),
                 min = 0,
                 max = (R - L) / ddays(1)
               ))
    
    sim_obs_data %<>%
      dplyr::select(-any_of("S_imputed")) %>%
      left_join(sim_participant_data %>% dplyr::select(ID, S_imputed),
                by = "ID") %>%
      mutate(T_imputed = (O - S_imputed) / ddays(365))
    
    phi_model_est_imputed =
      bigglm(
        epsilon = tolerance_for_glm_fits,
        maxit = max_iterations_for_glm_fits,
        quiet = TRUE,
        data = sim_obs_data,
        family = binomial(),
        Y ~ T_imputed
      )
    
    imputed_coef_ests[i, ] = coef(phi_model_est_imputed)
    
  }
  
  imputed_coef_ests_mean = colMeans(imputed_coef_ests)
  
  mu_est_imputed = compute_mu(imputed_coef_ests_mean)
  
}
```

Now, let’s graph the results. First, let’s plot the true and estimated
CDFs for the distribution of seroconversion date, for individuals who
enroll on the first calendar day of the cohort study:

``` r
library(ggplot2)
cum_haz_fn0 = function(years_since_study_start)
{
  hazard_alpha * years_since_study_start + hazard_beta / 2 * years_since_study_start^2
}

cum_haz_fn = function(years_since_study_start,
                      `years from study start to enrollment`)
{
  cum_haz_fn0(years_since_study_start) - cum_haz_fn0(`years from study start to enrollment`)
}

surv_fn = function(years_since_study_start,
                   `years from study start to enrollment`)
  exp(-cum_haz_fn(
    years_since_study_start,
    `years from study start to enrollment`
  ))

true_model_label = "Data-generating model"
est_model_label = "Estimated model"

lwd1 = 1
omega.hat = EM_algorithm_outputs$Omega %<>%
  mutate(
    "P(S>s|E=0)" = cumprod(`P(S>s|S>=s,E=e)`),
    "P(S>=s|E=0)" = lag(`P(S>s|E=0)`, default = 1) 
  )

plot1 = ggplot(
  aes(
    y = 1 - `P(S>=s|E=0)`,
    x = (S - ymd("2001-01-01")) / ddays(365)
  ),
  data = omega.hat %>% filter(S < max(S))) +
  
  geom_step(
    direction = "hv",
    aes(col = est_model_label,
        linetype = est_model_label),
    lwd = lwd1
  ) +
  
  xlab("Calendar time (years since start of study)") +
  ylab("Probability of seroconversion") +
  geom_function(
    fun = function(x)
      1 - surv_fn(x, 0),
    aes(col = true_model_label,
        linetype = true_model_label),
    lwd = lwd1
  ) +
  
  scale_colour_discrete("") +
  scale_linetype_discrete("") +
  theme(
    axis.title.x = element_text(size = 20),
    axis.text.x = element_text(size = 14),
    axis.title.y = element_text(size = 20),
    axis.text.y = element_text(size = 14),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(colour = "black"),
    legend.position = "top",
    legend.text =
      element_text(size = 14,
                   margin = margin(r = 10, unit = "pt"))
  )

print(plot1)
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />

We can see that our joint modeling approach does not always estimate
this distribution very accurately at this sample size. Nevertheless, the
next graph will show us that the joint model very accurately estimates
the true distribution for *P*(*Y*\|*T*) and the true value of *μ*:

``` r
library(scales)


mu_true = compute_mu(theta_true)
phi_true = build_phi_function_from_coefs(theta_true)
phi_est_joint_modeling = build_phi_function_from_coefs(EM_algorithm_outputs$Theta)
phi_est_midpoint = build_phi_function_from_coefs(coef(phi_model_est_midpoint))
phi_est_imputed = build_phi_function_from_coefs(imputed_coef_ests_mean)

true_model_label2 = paste(sep = "",
                          "'   data-generating model;'~mu == '",
                          format(mu_true, digits = 1, nsmall = 1),
                          "'~days"
)

midpoint_label = paste(sep = "",
                       "` midpoint imputation;`~hat(mu) == '",
                       format(mu_est_midpoint, digits = 1, nsmall = 1),
                       "'~days"
)

uniform_label = paste(sep = "",
                      "`uniform imputation;`~hat(mu) == '",
                      format(mu_est_imputed, digits = 1, nsmall = 1),
                      "'~days"
)

joint_modeling_label = paste(sep = "",
                             "'  joint modeling;'~hat(mu) =='",
                             format(mu_est_EM, digits = 1, nsmall = 1),
                             "'~days"
)

lwd1 = 1


  plot2 = ggplot(data = NULL) +
    geom_function(
      fun = phi_true,
      lwd = lwd1,
      aes(colour = true_model_label2, linetype = true_model_label2)
    ) +
    geom_function(
      fun = phi_est_midpoint,
      lwd = lwd1,
      aes(colour = midpoint_label, linetype = midpoint_label)
    ) +
    geom_function(
      fun = phi_est_imputed,
      lwd = lwd1,
      aes(colour = uniform_label, linetype = uniform_label)
    ) +
    geom_function(
      fun = phi_est_joint_modeling,
      lwd = lwd1,
      aes(colour = joint_modeling_label, linetype = joint_modeling_label)
    ) +
    xlim(0, 2) +
    ylab("Probability of an MAA-positive blood sample") +
    xlab("Time since seroconversion (years)") +
    scale_colour_discrete("",   labels = label_parse()) +
    scale_linetype_discrete("", labels = label_parse()) +
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.background = element_blank(),
      axis.line = element_line(colour = "black")
    ) +
    theme(
      axis.title.x = element_text(size = 20),
      axis.text.x = element_text(size = 14),
      axis.title.y = element_text(size = 18),
      axis.text.y = element_text(size = 14),
      legend.text.align = 1,
      legend.box.just = "right",
      legend.text = element_text(size = 16),
      legend.position = c(.65, .85),
      legend.title = element_blank()
    )


print(plot2)
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" />

This example can also be viewed via the R command
`vignette("how-to-use-rwicc")`).
