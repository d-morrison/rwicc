test_that("results are consistent", {
  example_model <-
    system.file("extdata", "example_model.rds", package = "rwicc") |>
    readRDS()
  omega_est_EM <- example_model$Omega
  omega_est_EM |>
    graph_omega() |>
    vdiffr::expect_doppelganger(title = "example-model")
})
