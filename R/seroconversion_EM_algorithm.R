# Authors: Douglas Ezra Morrison, Oliver Laeyendecker, Ron Brookmeyer
# Title: Regression with Interval-Censored Covariates: Application to Cross-
#        Sectional Incidence Estimation
# Email contact: dmorrison01@ucla.edu
# Supplementary Material: Function "seroconversion_EM_algorithm()"
# ==============================================================================
# This function fits a logistic regression model for a binary outcome Y with an
# interval-censored covariate T, using an EM algorithm inspired by Gomez,
# Espinal and Lagakos (2003). This algorithm is described in "Regression with
# Interval-Censored Covariates: Application to Cross-Sectional Incidence
# Estimation" by Morrison, Laeyendecker, and Brookmeyer.

# This function originated as a modification of the code published as
# supplemental material for "Estimation and residual analysis with R for a
# linear regression model with an interval-censored covariate" by Klaus Langohr
# & Guadalupe Gomez (Biometrical Journal, 2014; doi.org/10.1002/bimj.201300204).
# It has since diverged from that method and now implements a somewhat different
# algorithm, as described in our paper.

# Arguments:

# `subject_level_data`: a data.frame or tibble with the following variables:
# - `ID`: participant ID
# - `E`: study enrollment date
# - `L`: date of last negative test for seroconversion
# - `R`: date of first positive test for seroconversion
# - `Cohort` (optional): this variable can be used to stratify the modeling of
# the seroconversion distribution.

# `obs_level_data`: a data.frame or tibble with the following variables:
# - `ID`: participant ID
# - `O`: biomarker sample collection dates
# - `Y`: MAA classifications (binary outcomes)

# `model_formula`: the functional form for the regression model for p(y|t) (as a
# formula() object)

# `mu_function`: a function taking a vector of regression coefficient estimates
# as input and outputting an estimate of mu (mean duration of MAA-positive
# infection).

# `bin_width`: the number of days between possible seroconversion dates (should
# be an integer)

# `denom_offset`: an offset value added to the denominator of the hazard
# estimates to improve numerical stability

# `initial_S_estimate_location`: determines how seroconversion date is guessed
# to initialize the algorithm; can be any decimal between 0 and 1; 0.5 =
# midpoint imputation, 0.25 = 1st quartile, 0 = last negative, etc.

# `EM_toler_loglik`: the convergence cutoff for the log-likelihood criterion
# ("Delta_L" in the paper)

# `EM_toler_est`: the convergence cutoff for the parameter estimate criterion
# ("Delta_theta" in the paper)

# `coef_change_metric`: a string indicating the type of parameter estimate
# criterion to use: "max abs rel diff coefs" is the "Delta_theta" criterion
# described in the paper. "max abs diff coefs" is the maximum absolute change in
# the coefficients (not divided by the old values); this criterion can be useful
# when some parameters are close to 0. "diff mu" is the absolute change in mu,
# which may be helpful in the incidence estimate calibration setting but not
# elsewhere.

# `EM_max_iterations`: the number of EM iterations to perform before giving up
# if still not converged. 

# `glm_tolerance`: the convergence cutoff for the glm fit in the M step

# `glm_maxit`: the iterations cutoff for the glm fit in the M step

# `verbose`: whether to print algorithm progress details to the console

# Value: a list with the following elements:
# - `Theta`: the estimated regression coefficients for the model of p(Y|T)
# - `Mu`: the estimated mean window period (a transformation of `Theta`)
# - `Omega`: a table with the estimated parameters for the model of p(S|E).
# - `converged`: indicator of whether the algorithm reached its cutoff criteria
# before reaching the specified maximum iterations. 1 = reached cutoffs, 0 = not.
# - `iterations`: the number of EM iterations completed before the algorithm
# stopped.
# - `convergence_metrics`: the four convergence metrics

# ==============================================================================

seroconversion_EM_algorithm = function(
  subject_level_data,
  obs_level_data,
  model_formula = formula(Y ~ T),
  mu_function = compute_mu_linear_ff,
  bin_width = 1,
  denom_offset = 0.1,
  EM_toler_loglik = 0.1,
  EM_toler_est = 0.0001,
  EM_max_iterations = Inf,
  glm_tolerance = 1e-7,
  glm_maxit = 20,
  initial_S_estimate_location = 0.25,
  coef_change_metric = "max abs rel diff coefs",
  verbose = FALSE)
{
  
  # setup
  {
    
    # starting message
    {
      if(verbose) 
        message(
          "Starting `seroconversion_EM_algorithm();`, mem used = ", 
          round(mem_used()/10^6), " MB")
      
    }
    
    # check for basic errors in the data
    {
      
      if (with(subject_level_data, any(L > R))) stop("L must be <= R!")
      
      if(with(subject_level_data, any(duplicated(ID)))) stop("duplicate IDs")
      
      # if `Stratum` is not provided in the input data, we create a placeholder:
      if(!is.element("Stratum", colnames(subject_level_data)))
      {
        subject_level_data$Stratum = "Cohort 1"
      }
      
    }
    
    # identify the set of unique (E,L) combinations and count occurrences
    {
      
      E_L_combinations = 
        subject_level_data %>% 
        group_by(Stratum, E, L) %>%
        dplyr::summarize(.groups = "drop", n_IDs = n())
      
    }
    
    # identify the set of possible seroconversion dates
    {
      
      # omega.hat will be a table of possible seroconversion dates, and their estimated hazards, etc:
      omega.hat = 
        subject_level_data %>%
        group_by(Stratum) %>% 
        dplyr::summarize(
          .groups = "drop",
          S = seq(min(L), max(R), by = bin_width))
      
      subject_level_data_possibilities = 
        subject_level_data %>% 
        dplyr::select(ID, Stratum, L, R) %>%
        left_join(omega.hat, by = "Stratum") %>%
        filter(L <= S, S <= R) %>%
        dplyr::select(-c(L, R))
      
      # here we remove from omega.hat any stratum:seroconversion date combinations 
      # that aren't in anyone's censoring interval; the best estimate for hazard 
      # in those cases is 0, which will drop out of all subsequent calculations:
      omega.hat %<>%
        semi_join(
          subject_level_data_possibilities,
          by = c("Stratum", "S"))
      
      # here we enumerate all possible (T,Y) combinations (this tibble gets large):
      obs_data_possibilities = 
        obs_level_data %>% 
        dplyr::select(ID, Y, O) %>% 
        left_join(
          subject_level_data_possibilities %>% dplyr::select(ID, S), 
          by = "ID") %>%
        mutate("T" = (O - S)/ddays(365)) %>%
        dplyr::select(-O)
      
    }
    
    # count the number of participants definitely at risk of seroconversion
    # (i.e. between E and L) for each time point S:
    {
      
      omega.hat %<>% 
        left_join(
          E_L_combinations,
          by = "Stratum") %>%
        group_by(Stratum, S) %>%
        dplyr::summarize(
          .groups = "drop", 
          "n_definitely_at_risk" = 
            denom_offset + 
            sum(n_IDs[E <= S & S < L])) %>% 
        ungroup()
      
    }
    
  }
  
  # Initial estimates of omega and theta
  {
    
    # initial guess for S
    {
      
      subject_level_data  %<>% 
        mutate(
          "S_hat - E" = initial_S_estimate_location * (R - L) + (L - E))
      # This duration is computed directly, since computing S_hat first
      # would result in rounding. There's no need for this level of
      # precision in calculating initial estimates, but I am leaving as-is
      # to allow the main-text results to be exactly reproduceable.
      
    }
    
    # Omega
    {
      
      est_hazard_by_stratum = 
        subject_level_data %>% 
        group_by(Stratum) %>%
        dplyr::summarize(
          .groups = "drop", 
          "P(S=s|S>=s,E=e)" = 1 - exp(-ddays(bin_width) / mean(`S_hat - E`))) %>%
        # this formula actually computes P(S in [s,s+bin_width]|S>=s), from the
        # CDF of an exponential dist. with mean parameter estimated using S_hat -
        # E as approximate event times
        
        mutate("P(S>s|S>=s,E=e)" = 1 - `P(S=s|S>=s,E=e)`)
      
      omega.hat %<>%
        left_join(
          est_hazard_by_stratum,
          by = "Stratum")
      
    }
    
    # Theta
    {
      
      obs_level_data %<>%
        left_join(
          subject_level_data %>%
            dplyr::select(ID, `S_hat - E`, E),
          by = "ID") %>%
        mutate(
          "T" = ((O - E) - (`S_hat - E`)) / ddays(365)) %>%
        dplyr::select(ID, T, Y)
      
      MAA_model = bigglm(
        formula = model_formula, 
        family = binomial(link = "logit"), 
        data = obs_level_data,
        maxit = glm_maxit,
        epsilon = glm_tolerance,
        quiet =  TRUE)
      # quiet = TRUE is used because fitted probabilities numerically 0 or 1 can
      # easily occur, since p(Y=1|T=t) drops quickly to essentially 0; not a
      # cause for concern
      
      theta.hat = coef(MAA_model)
      mu.hat = mu_function(theta.hat)
      
      if(verbose) 
      {
        message(
          "initial estimate for mu = ", 
          round(mu.hat, digits = -log10(EM_toler_est) + 1), 
          "; initial estimate for theta:\n")
        
        print(theta.hat)
      }
      
    }
    
  }
  
  # observed-data likelihood function, with terms that cancel out of
  # diff(logLik) formula removed (see Supporting Information A.3)
  {
    
    observed_data_log_likelihood = function(subject_level_data_possibilities)
    {
      
      log_L = subject_level_data_possibilities %>%
        group_by(ID) %>%
        dplyr::summarize(
          .groups = "drop", 
          "logL_i" = log(sum(`P(Y=y|T=t)` * `P(S=s|E=e)`))) %>%
        dplyr::summarize(
          "log_L" = sum(logL_i))
      
      return(log_L$log_L)
      
    }
    
  }
  
  # algorithm loop:
  current_iteration = 0
  while (current_iteration < EM_max_iterations)
  {
    
    # progress notifications
    {
      
      current_iteration = current_iteration + 1
      
      if(verbose) 
        message(
          Sys.time(), ": starting EM iteration (E step) ", current_iteration, 
          "; mem used = ", round(mem_used()/10^6), " MB")
      
    }
    
    # E step: calculate distribution of S, given omega, theta, and (E,L,R,O,Y)
    {
      
      # calculate P(S>=l|E=e) for each participant:
      {
        
        E_L_combinations %<>%
          left_join(
            omega.hat %>% dplyr::select(Stratum, S, `P(S>s|S>=s,E=e)`), 
            by = "Stratum") %>%
          group_by(Stratum, E, L) %>%
          dplyr::summarize(.groups = "drop",
                           "P(S>=l|E=e)" = prod(`P(S>s|S>=s,E=e)`[E <= S & S < L])) 
        # note: can't add `filter(E <= S, S < L)` before summarize() or we would
        # lose any (E,L) combinations where E == L.
        
        subject_level_data %<>%
          dplyr::select(-any_of(c("P(S>=l|E=e)"))) %>%
          left_join(
            E_L_combinations,
            by = c("Stratum", "E", "L"))
        
      }
      
      # update subject_level_data_possibilities and obs_data_possibilities:
      {
        
        subject_level_data_possibilities = 
          
          obs_data_possibilities %>% 
          
          mutate(
            # could speed up this step by implementing the needed computations
            # explicitly:
            "P(Y=1|T=t)" =
              as.numeric(predict(
                MAA_model,
                newdata = obs_data_possibilities,
                type = "response")),
            
            "P(Y=y|T=t)" = 
              if_else(
                Y == 1, 
                `P(Y=1|T=t)`, 
                1 - `P(Y=1|T=t)`)) %>% 
          
          group_by(ID, S) %>% 
          
          dplyr::summarize(.groups = "drop",
                           "P(Y=y|T=t)" = prod(`P(Y=y|T=t)`)) %>%
          
          left_join(
            subject_level_data %>% 
              dplyr::select(ID, Stratum, `P(S>=l|E=e)`), 
            by = "ID") %>% 
          
          # update `P(S=s|e,l,r,o,y)`:
          left_join(
            omega.hat %>% dplyr::select(c("S", "Stratum", "P(S=s|S>=s,E=e)", "P(S>s|S>=s,E=e)")),  
            by = c("S", "Stratum")) %>% 
          
          group_by(ID) %>%
          
          mutate(
            "P(S>s|S>=l,E=e)" = cumprod(`P(S>s|S>=s,E=e)`), # used for next calculation
            
            "P(S>=s|S>=l,E=e)" = lag(`P(S>s|S>=l,E=e)`, default = 1), # used for next calculation
            
            "P(S=s|S>=l,E=e)" = `P(S=s|S>=s,E=e)` * `P(S>=s|S>=l,E=e)`, # used in next two calculations
            
            "P(S=s|E=e)" =  `P(S=s|S>=l,E=e)` * `P(S>=l|E=e)`, # used to compute likelihood
            
            "P(S=s|E=e,L=l,R=r)" = prop.table(`P(S=s|S>=l,E=e)`), # used in next calculation
            
            "P(S=s|e,l,r,o,y)" = prop.table(`P(Y=y|T=t)` * `P(S=s|E=e,L=l,R=r)`), # used to estimate omega and theta
            
            "P(S>=s|e,l,r,o,y)" = rev(cumsum(rev(`P(S=s|e,l,r,o,y)`))) # used to estimate omega
            
          ) %>% 
          ungroup() %>% 
          dplyr::select(
            c(
              "ID", 
              "Stratum",
              "S",
              "P(Y=y|T=t)",          # used to compute likelihood
              "P(S=s|E=e)",          # used to compute likelihood
              "P(S=s|e,l,r,o,y)",    # used to estimate omega and theta
              "P(S>=s|e,l,r,o,y)"))  # used to estimate omega
        
        obs_data_possibilities %<>%
          dplyr::select(-any_of("P(S=s|e,l,r,o,y)")) %>%
          left_join(
            subject_level_data_possibilities %>% 
              dplyr::select(all_of(c("ID", "S", "P(S=s|e,l,r,o,y)"))), 
            by = c("ID", "S"))
        
      }
      
      if(verbose)
      {
        message('Ending E step.')
        
      }
      
    }
    
    # check for convergence
    {
      # we check for convergence between the E and M step because it is
      # convenient to compute the likelihood as part of the E step
      
      if(current_iteration > 1)
      {
        log_L_old = log_L
      }
      
      log_L = observed_data_log_likelihood(subject_level_data_possibilities)
      if(verbose) message('observed-data log-likelihood = ', round(log_L, 5))
      
      if(current_iteration > 1)
      {
        
        diff_log_L = log_L - log_L_old
        
        if(is.na(diff_log_L)) stop(message('`diff_log_L` = NA'))
        
        if(diff_log_L < 0)
        {
          warning(paste("log-likelihood is decreasing; change = ", diff_log_L)) 
		  # note: if denom_offset != 0, we may lose the guarantee of increasing log likelihood. 
        }
        
        # For algorithm diagnostic purposes, we compute three change metrics based on the coefficients, 
        # but only one is used to determine convergence, specified in the function inputs; see M step below:
        diff_coef = coef_diffs[coef_change_metric]
        
        converged = (diff_log_L < EM_toler_loglik)  & 
          (is.na(coef_change_metric) | (diff_coef < EM_toler_est))
        
        if (converged)
        {
          
          if(verbose) 
          {
            message(
              "EM algorithm converged, based on log-likelihood",
              if_else(!is.na(coef_change_metric), " and coefs", ""),
              ", to ", diff_log_L, " change in log-likelihood, in ", 
              current_iteration, " iterations.")
          }
          
          break
          
        } else
        {
          if(verbose) message("Change in log-likelihood = ", diff_log_L)
        }
        
      }
      
    }
    
    # M step: Updated estimation of theta, omega
    {
      
      if(verbose) 
      {
        message('Starting M step, mem used = ', round(mem_used()/10^6), " MB")
      }
      
      # update omega (hazard model):
      {
        
        omega.hat_old = omega.hat
        
        # sum the estimated at-risk and event probabilities by date:
        n_events_by_date = 
          subject_level_data_possibilities %>% 
          group_by_at(c("Stratum", "S")) %>% 
          dplyr::summarize(.groups = "drop",
                           "n_events" = sum(`P(S=s|e,l,r,o,y)`),
                           "risk_probabilities" = sum(`P(S>=s|e,l,r,o,y)`))
        
        if(any(with(n_events_by_date, n_events > risk_probabilities))) 
        {
          stop(message('more events than participants at risk'))
        }
        
        omega.hat %<>% 
          left_join(n_events_by_date, by = c("S", "Stratum")) %>%
          
          mutate(
            "n_at_risk" = risk_probabilities + n_definitely_at_risk,
            "P(S=s|S>=s,E=e)" = if_else(n_at_risk == 0, 1, n_events / n_at_risk)
            # if no one is left at risk, estimate the hazard as 1; won't matter
          ) %>% 
          
          dplyr::select(-c(risk_probabilities, n_events, n_at_risk))
        
        # handle numeric stability issues (should not occur if denom_offset > 0):
        {
          # this prevents occasional cases where the denominator approaches 0
          # for the person with the latest seroconversion window
          
          to_fix = (omega.hat$"P(S=s|S>=s,E=e)" > 1) | is.na(omega.hat$"P(S=s|S>=s,E=e)")
          if (any(to_fix)) 
          {
            message('Fixing ', sum(to_fix), " value(s) of omega.hat with NaNs.")
            omega.hat$"P(S=s|S>=s,E=e)"[to_fix] = 1 
            
          }
          
          }
        
        # compute P(S>s|S>=s,E=e) from P(S=s|S>=s,E=e):
        omega.hat %<>% mutate("P(S>s|S>=s,E=e)" = 1 - `P(S=s|S>=s,E=e)`)
        
      }
      
      # update theta (model of MAA classifications, Y~T):
      {
        
        MAA_model = try(bigglm(
          family = binomial(link = "logit"),
          maxit = glm_maxit,
          quiet =  TRUE,
          epsilon = glm_tolerance,
          start = theta.hat,
          formula = model_formula, 
          data = obs_data_possibilities,
          weight = ~ `P(S=s|e,l,r,o,y)`))
        
        if (inherits(MAA_model, "try-error"))
        {
          
          MAA_model = glm(
            family = quasibinomial(link = "logit"),
            maxit = glm_maxit,
            epsilon = glm_tolerance,
            start = theta.hat,
            formula = model_formula, 
            data = obs_data_possibilities,
            weight = `P(S=s|e,l,r,o,y)`)
          
        }
        
        mu.hat_old = mu.hat
        mu.hat = mu_function(coef(MAA_model))
        
        # we calculate three measures of change in the regression model here;
        # only one is used to assess convergence though ("max abs rel diff
        # coefs", by default):
        coef_diffs = 
          c(
            "diff mu" = 
              as.numeric(abs(mu.hat - mu.hat_old)),
            "max abs diff coefs" = 
              max(abs(coef(MAA_model) - theta.hat)), 
            "max abs rel diff coefs" = 
              max(abs(coef(MAA_model) - theta.hat) / abs(theta.hat)))
        
        theta.hat = coef(MAA_model)
        
      }
      
      # report new parameter estimates:
      if(verbose)
      {
        message(
          "Ending M step; mu = ", 
          round(mu.hat, digits = -log10(EM_toler_est) + 1), 
          "; theta = \n")
        
        print(theta.hat)
        
        message('\nChange in mu = ', coef_diffs["diff mu"])
        message('Max change in theta = ', coef_diffs["max abs diff coefs"])
        message('Max relative change in theta = ', coef_diffs["max abs rel diff coefs"])
        
      }
      
    }
    
    if(current_iteration == EM_max_iterations) 
    {
      warning('Maximum iterations reached without convergence.')
    }
    
  }
  
  to_return = list(
    Theta = theta.hat,
    Mu = mu.hat,
    Omega = omega.hat, 
    converged = as.numeric(converged),
    iterations = current_iteration,
    convergence_metrics = c("diff logL" = diff_log_L, coef_diffs))
  
  return(to_return)
  
}
