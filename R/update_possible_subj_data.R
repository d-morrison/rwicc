#' Update subject-level data with posterior probabilities
#'
#' Internal helper function that updates subject-level data by computing
#' various conditional probabilities used in the EM algorithm for
#' fitting the joint model. This function combines observation-level
#' predictions with participant-level data and omega estimates to compute
#' posterior probabilities needed for parameter estimation.
#'
#' @param obs_data_possibilities A [data.frame] containing all possible
#'   observation-level data combinations, including ID, S (possible
#'   seroconversion dates), and Y (MAA classifications).
#' @param MAA_model A fitted [stats::glm()] model object used to predict
#'   P(Y=1|T=t), the probability of MAA-positive status given time since
#'   seroconversion.
#' @param participant_level_data A [data.frame] containing participant-level
#'   information, including ID, Stratum, and P(S>=l|E=e) (the probability
#'   that seroconversion occurs on or after the last negative test date).
#' @param omega_hat A [data.frame] containing estimated parameters for the
#'   seroconversion date distribution model, including S, Stratum, P(S=s|S>=s,E=e),
#'   and P(S>s|S>=s,E=e).
#'
#' @returns A [data.frame] containing updated subject-level data with the
#'   following columns:
#' \itemize{
#'   \item `ID`: Participant identifier
#'   \item `Stratum`: Stratification variable
#'   \item `S`: Possible seroconversion date
#'   \item `P(Y=y|T=t)`: Probability of observed MAA outcomes given time since
#'     seroconversion
#'   \item `P(S=s|E=e)`: Marginal probability of seroconversion at time s given
#'     enrollment date
#'   \item `P(S=s|e,l,r,o,y)`: Posterior probability of seroconversion at time s
#'     given all observed data (used to estimate omega and theta)
#'   \item `P(S>=s|e,l,r,o,y)`: Posterior probability that seroconversion occurs
#'     on or after time s (used to estimate omega)
#' }
#'
#' @keywords internal
update_possible_subj_data <- function(
    obs_data_possibilities,
    MAA_model,
    participant_level_data,
    omega_hat) {
  obs_data_possibilities |>
    dplyr::mutate(
      # could speed up this step by implementing the needed computations
      # explicitly:
      "P(Y=1|T=t)" =
        as.numeric(stats::predict(
          MAA_model,
          newdata = obs_data_possibilities,
          type = "response"
        )),
      "P(Y=y|T=t)" =
        dplyr::if_else(
          .data$Y == 1,
          .data$`P(Y=1|T=t)`,
          1 - .data$`P(Y=1|T=t)`
        )
    ) |>
    dplyr::summarize(
      .by = c("ID", "S"),
      "P(Y=y|T=t)" = prod(.data$`P(Y=y|T=t)`)
    ) |>
    dplyr::left_join(
      participant_level_data |>
        dplyr::select("ID", "Stratum", "P(S>=l|E=e)"),
      by = "ID"
    ) |>
    # update `P(S=s|e,l,r,o,y)`:
    dplyr::left_join(
      omega_hat |> dplyr::select(
        c("S", "Stratum", "P(S=s|S>=s,E=e)", "P(S>s|S>=s,E=e)")
      ),
      by = c("S", "Stratum")
    ) |>
    dplyr::group_by("ID") |>
    dplyr::mutate(
      "P(S>s|S>=l,E=e)" = cumprod(.data$`P(S>s|S>=s,E=e)`),
      # used for next calculation

      "P(S>=s|S>=l,E=e)" = dplyr::lag(.data$`P(S>s|S>=l,E=e)`, default = 1),
      # used for next calculation

      "P(S=s|S>=l,E=e)" = .data$`P(S=s|S>=s,E=e)` * .data$`P(S>=s|S>=l,E=e)`,
      # used in next two calculations

      "P(S=s|E=e)" = .data$`P(S=s|S>=l,E=e)` * .data$`P(S>=l|E=e)`,
      # used to compute likelihood

      "P(S=s|E=e,L=l,R=r)" = proportions(.data$`P(S=s|S>=l,E=e)`),
      # used in next calculation

      "P(S=s|e,l,r,o,y)" = proportions(.data$`P(Y=y|T=t)` *
                                         .data$`P(S=s|E=e,L=l,R=r)`),
      # used to estimate omega and theta

      "P(S>=s|e,l,r,o,y)" = rev(cumsum(rev(.data$`P(S=s|e,l,r,o,y)`)))
      # used to estimate omega
    ) |>
    dplyr::ungroup() |>
    dplyr::select(
      c(
        "ID",
        "Stratum",
        "S",
        "P(Y=y|T=t)", # used to compute likelihood
        "P(S=s|E=e)", # used to compute likelihood
        "P(S=s|e,l,r,o,y)", # used to estimate omega and theta
        "P(S>=s|e,l,r,o,y)"
      )
    ) # used to estimate omega
}
