# Authors: Douglas Ezra Morrison, Oliver Laeyendecker, Ron Brookmeyer
# Email contact: dmorrison01@ucla.edu

# Title: Regression with Interval-Censored Covariates: Application to Cross-
#        Sectional Incidence Estimation

# Supporting Information: function seroconversion_inverse_survival_function()

# This function determines the seroconversion date corresponding to a provided
# probability of survival. See Supporting Information, Section A.4.

# Arguments:
# u: a vector of seroconversion survival probabilities
# e: a vector of time differences between study start and enrollment (in years)
# hazard_alpha: the instantaneous hazard of seroconversion on the study start date
# hazard_beta: the change in hazard per year after study start date

# Value: a vector of time differences between study start and seroconversion (in years)
###############################################################################

seroconversion_inverse_survival_function = function(
  u, 
  e,	
  hazard_alpha, 
	hazard_beta)
{
	
	if(hazard_beta != 0)
	{
		
			a = hazard_beta / 2
			b = hazard_alpha
			c = log(u) - ((a * (e^2)) + (b * e))
			
			# this is the quadratic formula:
			root = (-b + sqrt(b^2 - 4 * a * c)) / (2 * a)
			
			return(root)
		
	} else
	{
	  
			value = e + (-log(u) / hazard_alpha)
			# equivalent: value = e + qexp(p = u, rate = hazard_alpha, lower.tail = FALSE)	
			return(value)
			
	}
	
}