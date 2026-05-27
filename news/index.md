# Changelog

## rwicc (development version)

- Replaced dependency on `pryr` with `lobstr`, since `pryr` is being
  archived ([\#11](https://github.com/d-morrison/rwicc/issues/11)).

- Added
  [`graph_omega()`](https://d-morrison.github.io/rwicc/reference/graph_omega.md)
  ([\#11](https://github.com/d-morrison/rwicc/issues/11)).

- Added functions to visualize the simulated data-generating model:
  [`graph_simulated_densities()`](https://d-morrison.github.io/rwicc/reference/graph_simulated_densities.md),
  [`graph_simulated_hazards()`](https://d-morrison.github.io/rwicc/reference/graph_simulated_hazards.md),
  and
  [`graph_simulated_survival_curves()`](https://d-morrison.github.io/rwicc/reference/graph_simulated_survival_curves.md)
  ([\#11](https://github.com/d-morrison/rwicc/issues/11)).

- Fixed participant subsetting in
  [`graph_S()`](https://d-morrison.github.io/rwicc/reference/graph_S.md)
  and several minor correctness issues in
  [`fit_joint_model()`](https://d-morrison.github.io/rwicc/reference/fit_joint_model.md)
  and
  [`simulate_interval_censoring()`](https://d-morrison.github.io/rwicc/reference/simulate_interval_censoring.md)
  ([\#11](https://github.com/d-morrison/rwicc/issues/11)).

- Corrected two technical-accuracy details in the `reprexes` skill
  documentation (the `callr` fresh-session mechanism and the role of
  `tidyverse_update()`).

## rwicc 0.1.3

CRAN release: 2022-03-09

- Documentation improvements.

## rwicc 0.1.2

- Fixed contact info.

## rwicc 0.1.1

- Fixed some typos in documentation.

## rwicc 0.1.0

- Initial release.
