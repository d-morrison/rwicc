update_possible_subj_data <- function(
  obs_data_possibilities,
  MAA_model,
  participant_level_data,
  omega_hat
) {
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
          Y == 1,
          `P(Y=1|T=t)`,
          1 - `P(Y=1|T=t)`
        )
    ) |>
    dplyr::group_by(ID, S) |>
    dplyr::summarize(
      .groups = "drop",
      "P(Y=y|T=t)" = prod(`P(Y=y|T=t)`)
    ) |>
    dplyr::left_join(
      participant_level_data |>
        dplyr::select(ID, Stratum, `P(S>=l|E=e)`),
      by = "ID"
    ) |>
    # update `P(S=s|e,l,r,o,y)`:
    dplyr::left_join(
      omega_hat |> dplyr::select(c("S", "Stratum", "P(S=s|S>=s,E=e)", "P(S>s|S>=s,E=e)")),
      by = c("S", "Stratum")
    ) |>
    dplyr::group_by(ID) |>
    dplyr::mutate(
      "P(S>s|S>=l,E=e)" = cumprod(.data$`P(S>s|S>=s,E=e)`), # used for next calculation

      "P(S>=s|S>=l,E=e)" = dplyr::lag(.data$`P(S>s|S>=l,E=e)`, default = 1), # used for next calculation

      "P(S=s|S>=l,E=e)" = .data$`P(S=s|S>=s,E=e)` * .data$`P(S>=s|S>=l,E=e)`, # used in next two calculations

      "P(S=s|E=e)" = .data$`P(S=s|S>=l,E=e)` * .data$`P(S>=l|E=e)`, # used to compute likelihood

      "P(S=s|E=e,L=l,R=r)" = prop.table(.data$`P(S=s|S>=l,E=e)`), # used in next calculation

      "P(S=s|e,l,r,o,y)" = prop.table(.data$`P(Y=y|T=t)` * .data$`P(S=s|E=e,L=l,R=r)`), # used to estimate omega and theta

      "P(S>=s|e,l,r,o,y)" = rev(cumsum(rev(.data$`P(S=s|e,l,r,o,y)`))) # used to estimate omega
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
