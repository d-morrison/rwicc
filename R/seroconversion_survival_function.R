seroconversion_hazard_function = function(
    t,
    intercept,
    slope,
    entry_time = 0)
{
  (t >= entry_time) * (intercept + slope * t)
}

seroconversion_cumhaz_function = function(
    t,
    intercept,
    slope,
    entry_time = 0)
{

  cumhaz =
    (t > entry_time) *
    {
      intercept*(t-entry_time) + 1/2 * slope * (t^2 - entry_time^2)
    }

  return(cumhaz)
}

seroconversion_survival_function = function(...)
{
  exp(-seroconversion_cumhaz_function(...))
}

seroconversion_density_function = function(...)
{
  seroconversion_survival_function(...) *
    seroconversion_hazard_function(...)

}
