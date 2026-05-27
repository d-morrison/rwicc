# rwicc (development version)

* Replaced dependency on `pryr` with `lobstr`, 
since `pryr` is being archived (#11).

* Added `graph_omega()` (#11).

* Added functions to visualize the simulated data-generating model:
`graph_simulated_densities()`, `graph_simulated_hazards()`, and
`graph_simulated_survival_curves()` (#11).

* Fixed participant subsetting in `graph_S()` and several minor correctness
issues in `fit_joint_model()` and `simulate_interval_censoring()` (#11).

* Corrected two technical-accuracy details in the `reprexes` skill
documentation (the `callr` fresh-session mechanism and the role of
`tidyverse_update()`).

# rwicc 0.1.3
* Documentation improvements.

# rwicc 0.1.2
* Fixed contact info.

# rwicc 0.1.1
* Fixed some typos in documentation.

# rwicc 0.1.0
* Initial release.
