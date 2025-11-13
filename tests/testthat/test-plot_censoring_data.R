test_that("results are consistent", {
  withr::local_seed(16);

  sim_data <- simulate_interval_censoring(
    study_cohort_size = 2,
    years_in_study = 10,
    probability_of_ever_seroconverting = 1)

  sim_data$obs_data <-
    sim_data$obs_data |>
    filter(.data$O <= lubridate::ymd("2003-01-01"))

  sim_plot <- sim_data |>
    plot_censoring_data(
      labelled_IDs = 1:2,
      s_vjust = -1
    )

  sim_plot |> vdiffr::expect_doppelganger(title = "sim-plot")
})
