graph_simulated_survival_curves = function()
{

  ggplot() +
    theme_classic() +
    theme(
      text = element_text(size = 15),
      legend.position = "bottom"
    ) +
    ggplot2::geom_function(
      fun = seroconversion_survival_function,
      args = list(intercept = 0, slope = .5), aes(col = "0+0.5t")) +
    ggplot2::geom_function(
      fun = seroconversion_survival_function, args = list(intercept = 0, slope = 1), aes(col = "0+1t")) +
    ggplot2::geom_function(fun = seroconversion_survival_function, args = list(intercept = 0, slope = 2), aes(col = "0+2t")) +
    ggplot2::geom_function(fun = seroconversion_survival_function, args = list(intercept = 1, slope = 0), aes(col = "1+ 0t")) +
    ggplot2::geom_function(fun = seroconversion_survival_function, args = list(intercept = 1, slope = .5), aes( col = "1+0.5t")) +
    ggplot2::geom_function(alpha = .5, fun = seroconversion_survival_function, args = list(intercept = 10,slope = 0), aes(col = "10+ 0t")) +
    ggplot2::geom_function(linetype = 2, alpha = .5, fun = seroconversion_survival_function, args = list(intercept = 10,slope = .5), aes( col = "10+0.5t")) +
    xlim(0, 2) +
    xlab("Time since study start (years)") +
    ylim(0, 1) +
    ylab("p(S \u2265 s)") +
    # ggplot2::scale_y_log10() +
    ggplot2::labs(col = "")

 }
