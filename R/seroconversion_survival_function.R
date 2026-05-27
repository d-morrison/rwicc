#' Seroconversion hazard function
#'
#' Linear instantaneous hazard of seroconversion, `intercept + slope * t`,
#' equal to zero before `entry_time`.
#'
#' @param t numeric vector of times since study start (years)
#' @param intercept hazard at study start
#' @param slope change in hazard per year
#' @param entry_time time of study entry; the hazard is zero before this
#' @returns a numeric vector of hazard values
#' @keywords internal
seroconversion_hazard_function <- function(
  t,
  intercept,
  slope,
  entry_time = 0
) {
  (t >= entry_time) * (intercept + slope * t)
}

#' Seroconversion cumulative hazard function
#'
#' Cumulative hazard obtained by integrating [seroconversion_hazard_function()].
#'
#' @inheritParams seroconversion_hazard_function
#' @returns a numeric vector of cumulative hazard values
#' @keywords internal
seroconversion_cumhaz_function <- function(
  t,
  intercept,
  slope,
  entry_time = 0
) {
  cumhaz <-
    (t > entry_time) * {
      intercept * (t - entry_time) + 1 / 2 * slope * (t^2 - entry_time^2)
    }

  return(cumhaz)
}

#' Seroconversion survival function
#'
#' Survival probability, `exp(-cumulative hazard)`.
#'
#' @param ... arguments passed to [seroconversion_cumhaz_function()]
#' @returns a numeric vector of survival probabilities
#' @keywords internal
seroconversion_survival_function <- function(...) {
  exp(-seroconversion_cumhaz_function(...))
}

#' Seroconversion density function
#'
#' Probability density, `survival * hazard`.
#'
#' @param ... arguments passed to [seroconversion_survival_function()] and
#'   [seroconversion_hazard_function()]
#' @returns a numeric vector of density values
#' @keywords internal
seroconversion_density_function <- function(...) {
  seroconversion_survival_function(...) *
    seroconversion_hazard_function(...)
}
