# Update subject-level data with posterior probabilities

Internal helper function that updates subject-level data by computing
various conditional probabilities used in the EM algorithm for fitting
the joint model. This function combines observation-level predictions
with participant-level data and omega estimates to compute posterior
probabilities needed for parameter estimation.

## Usage

``` r
update_possible_subj_data(
  obs_data_possibilities,
  MAA_model,
  participant_level_data,
  omega_hat
)
```

## Arguments

- obs_data_possibilities:

  A [data.frame](https://rdrr.io/r/base/data.frame.html) containing all
  possible observation-level data combinations, including ID, S
  (possible seroconversion dates), and Y (MAA classifications).

- MAA_model:

  A fitted [`stats::glm()`](https://rdrr.io/r/stats/glm.html) model
  object used to predict P(Y=1\|T=t), the probability of MAA-positive
  status given time since seroconversion.

- participant_level_data:

  A [data.frame](https://rdrr.io/r/base/data.frame.html) containing
  participant-level information, including ID, Stratum, and
  P(S\>=l\|E=e) (the probability that seroconversion occurs on or after
  the last negative test date).

- omega_hat:

  A [data.frame](https://rdrr.io/r/base/data.frame.html) containing
  estimated parameters for the seroconversion date distribution model,
  including S, Stratum, P(S=s\|S\>=s,E=e), and P(S\>s\|S\>=s,E=e).

## Value

A [data.frame](https://rdrr.io/r/base/data.frame.html) containing
updated subject-level data with the following columns:

- `ID`: Participant identifier

- `Stratum`: Stratification variable

- `S`: Possible seroconversion date

- `P(Y=y|T=t)`: Probability of observed MAA outcomes given time since
  seroconversion

- `P(S=s|E=e)`: Marginal probability of seroconversion at time s given
  enrollment date

- `P(S=s|e,l,r,o,y)`: Posterior probability of seroconversion at time s
  given all observed data (used to estimate omega and theta)

- `P(S>=s|e,l,r,o,y)`: Posterior probability that seroconversion occurs
  on or after time s (used to estimate omega)
