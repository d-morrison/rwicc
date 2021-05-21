#' rwicc: Regression with Interval-Censored Covariates
#'
#' The \code{rwicc} package implements a logistic regression model for a binary outcome Y with an
#' interval-censored covariate T, using an EM algorithm. This algorithm is described in "Regression with
#' Interval-Censored Covariates: Application to Cross-Sectional Incidence
#' Estimation" by Morrison, Laeyendecker, and Brookmeyer, \url{https://doi.org/10.1111/biom.13472}.
#' \cr\cr
#'
#' @section rwicc functions:
#' The main \code{rwicc} functions are:
#' \itemize{
#' \item \code{\link{simulate_interval_censoring}}
#' \item \code{\link{seroconversion_EM_algorithm}}
#' }
#'
#' @docType package
#' @name rwicc
NULL
#> NULL
