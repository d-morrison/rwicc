# rwicc 0.2.0

* Replaced the dependency on `pryr` (which has been archived on CRAN) with
`lobstr` (#11). This restores CRAN compatibility.

* Added `graph_omega()` to plot the estimated seroconversion hazard model
(#11).

* Added functions to visualize the simulated data-generating model:
`graph_simulated_densities()`, `graph_simulated_hazards()`, and
`graph_simulated_survival_curves()` (#11).

* Fixed participant subsetting in `graph_S()` and several minor correctness
issues in `fit_joint_model()` and `simulate_interval_censoring()` (#11).

# rwicc 0.1.3
* Documentation improvements.

# rwicc 0.1.2
* Fixed contact info.

# rwicc 0.1.1
* Fixed some typos in documentation.

# rwicc 0.1.0
* Initial release.
