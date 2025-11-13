test_that("results are consistent", {
  withr::local_seed(16);

  sim_data <- simulate_interval_censoring(
    study_cohort_size = 2,
    years_in_study = 10,
    probability_of_ever_seroconverting = 1)

  sim_plot <- sim_data |>
    plot_censoring_data(
      labelled_IDs = 1:2,
      min_n_MAA = 5,
      s_vjust = -1
    )

  sim_plot |> vdiffr::expect_doppelganger(title = "sim-plot")
})
