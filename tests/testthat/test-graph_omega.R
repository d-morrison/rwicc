test_that("results are consistent", {
  example_model <-
    fs::path_package("rwicc", "extdata/example_model.rds")
  omega_est_EM <- EM_algorithm_outputs$Omega
  omega_est_EM |> graph_omega() |>
    vdiffr::expect_doppelganger(title = "example-model")
})
