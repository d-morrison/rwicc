test_that("simulated-model graphs are consistent", {
  vdiffr::expect_doppelganger(
    "sim-densities",
    graph_simulated_densities()
  )
  vdiffr::expect_doppelganger(
    "sim-hazards",
    graph_simulated_hazards()
  )
  vdiffr::expect_doppelganger(
    "sim-survival-curves",
    graph_simulated_survival_curves()
  )
})
