test_that("results are consistent", {
  example_model <-
    fs::path_package("rwicc", "extdata/example_model.rds") |>
    readr::read_rds()
  omega_est_EM <- example_model$Omega
  omega_est_EM |> graph_omega() |>
    vdiffr::expect_doppelganger(title = "example-model")
})
