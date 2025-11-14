#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom dplyr reframe
#' @importFrom ggplot2 aes
#' @importFrom ggplot2 element_text
#' @importFrom ggplot2 geom_abline
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 theme
#' @importFrom ggplot2 theme_classic
#' @importFrom ggplot2 xlab
#' @importFrom ggplot2 xlim
#' @importFrom ggplot2 ylim
#' @importFrom rlang .data
## usethis namespace: end

# Global variable declarations to suppress R CMD check notes
# These are non-standard evaluation variables used in dplyr pipelines and column names
utils::globalVariables(c(
  # Standard column names used throughout the package
  "ID", "Stratum", "L", "R", "S", "E",
  # Probability column names (with special characters) used in update_possible_subj_data.R
  "P(S=s|e,l,r,o,y)", "P(S=s|E=e)", "P(Y=y|T=t)",
  "P(S=s|E=e,L=l,R=r)", "P(S=s|S>=l,E=e)",
  # Time-related column names
  "years from study start to seroconversion",
  "seroconversion_time", "seroconversion_time_upper",
  "seroconversion_time_lower", "censoring_type"
))

NULL
