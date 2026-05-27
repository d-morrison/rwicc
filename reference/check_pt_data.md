# Validate participant-level data

Internal helper function that performs basic validation checks on
participant-level data to ensure data integrity before model fitting.

## Usage

``` r
check_pt_data(participant_level_data)
```

## Arguments

- participant_level_data:

  A data.frame or tibble containing participant-level data with at least
  the following columns:

  - `ID`: participant ID

  - `L`: date of last negative test for seroconversion

  - `R`: date of first positive test for seroconversion

## Value

NULL (invisibly). The function throws an error if validation fails.
