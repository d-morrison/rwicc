#' Plot true and estimated curves for P(Y=1|T=t)
#'
#' @param theta_true the coefficients of the data-generating model P(Y=1|T=t)
#' @param theta.hat_joint the estimated coefficients from the joint model
#' @param theta.hat_midpoint the estimated coefficients from midpoint imputation
#' @param theta.hat_uniform the estimated coefficients from uniform imputation
#'
#' @return a ggplot
#' @export
#'
#'
#' @importFrom ggplot2 ggplot geom_function aes xlim ylab xlab scale_colour_discrete scale_linetype_discrete theme element_blank element_line element_text
#' @importFrom scales label_parse
plot_phi_curves <- function(theta_true,
                            theta.hat_joint,
                            theta.hat_midpoint,
                            theta.hat_uniform) {
  mu_true <- compute_mu(theta_true)
  mu_est_EM <- compute_mu(theta.hat_joint)
  mu_est_midpoint <- compute_mu(theta.hat_midpoint)
  mu_est_imputed <- compute_mu(theta.hat_uniform)

  phi_true <- build_phi_function_from_coefs(theta_true)
  phi_est_joint_modeling <- build_phi_function_from_coefs(theta.hat_joint)
  phi_est_midpoint <- build_phi_function_from_coefs(theta.hat_midpoint)
  phi_est_imputed <- build_phi_function_from_coefs(theta.hat_uniform)

  true_model_label2 <- paste(
    sep = "",
    "'   data-generating model;'~mu == '",
    format(mu_true, digits = 1, nsmall = 1),
    "'~days"
  )

  midpoint_label <- paste(
    sep = "",
    "` midpoint imputation;`~hat(mu) == '",
    format(mu_est_midpoint, digits = 1, nsmall = 1),
    "'~days"
  )

  uniform_label <- paste(
    sep = "",
    "`uniform imputation;`~hat(mu) == '",
    format(mu_est_imputed, digits = 1, nsmall = 1),
    "'~days"
  )

  joint_modeling_label <- paste(
    sep = "",
    "'  joint modeling;'~hat(mu) =='",
    format(mu_est_EM, digits = 1, nsmall = 1),
    "'~days"
  )

  lwd1 <- 1


  plot2 <- ggplot2::ggplot(data = NULL) +
    ggplot2::geom_function(
      fun = phi_true,
      lwd = lwd1,
      ggplot2::aes(colour = true_model_label2, linetype = true_model_label2)
    ) +
    ggplot2::geom_function(
      fun = phi_est_midpoint,
      lwd = lwd1,
      ggplot2::aes(colour = midpoint_label, linetype = midpoint_label)
    ) +
    ggplot2::geom_function(
      fun = phi_est_imputed,
      lwd = lwd1,
      ggplot2::aes(colour = uniform_label, linetype = uniform_label)
    ) +
    ggplot2::geom_function(
      fun = phi_est_joint_modeling,
      lwd = lwd1,
      ggplot2::aes(colour = joint_modeling_label, linetype = joint_modeling_label)
    ) +
    ggplot2::xlim(0, 2) +
    ggplot2::ylab("Probability of an MAA-positive blood sample") +
    ggplot2::xlab("Time since seroconversion (years)") +
    ggplot2::scale_colour_discrete("", labels = scales::label_parse()) +
    ggplot2::scale_linetype_discrete("", labels = scales::label_parse()) +
    ggplot2::theme(
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      panel.background = ggplot2::element_blank(),
      axis.line = ggplot2::element_line(colour = "black")
    ) +
    ggplot2::theme(
      # axis.title.x = ggplot2::element_text(size = 20),
      # axis.text.x = ggplot2::element_text(size = 14),
      # axis.title.y = ggplot2::element_text(size = 18),
      # axis.text.y = ggplot2::element_text(size = 14),
      legend.text.align = 1,
      legend.box.just = "right",
      # legend.text = ggplot2::element_text(size = 16),
      legend.position = c(.65, .85),
      legend.title = ggplot2::element_blank()
    )
}
