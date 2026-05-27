test_that("fit_joint_model returns the expected structure", {
  withr::local_seed(1)

  study_data <- simulate_interval_censoring(
    study_cohort_size = 30,
    years_in_study = 5,
    probability_of_ever_seroconverting = 1
  )

  # cap iterations for speed; suppress the resulting "max iterations" notice
  # and dplyr's many-to-many join message (this test checks structure, not
  # convergence or messaging)
  result <- suppressWarnings(
    fit_joint_model(
      participant_level_data = study_data$pt_data,
      obs_level_data = study_data$obs_data,
      bin_width = 30,
      EM_max_iterations = 3
    )
  )

  expect_named(
    result,
    c(
      "Theta", "Mu", "Omega", "converged", "iterations",
      "convergence_metrics", "convergence_stats"
    )
  )

  # convergence_stats is built from a per-iteration log-likelihood vector:
  # one row per completed iteration, with Iteration and logL columns.
  expect_s3_class(result$convergence_stats, "data.frame")
  expect_named(result$convergence_stats, c("Iteration", "logL"))
  expect_equal(nrow(result$convergence_stats), result$iterations)
  expect_true(result$iterations >= 1)
})
