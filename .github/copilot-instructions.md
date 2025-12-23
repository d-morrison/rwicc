# GitHub Copilot Instructions for rwicc

## Code Style and Conventions

### dplyr Grouping Operations

**Prefer per-operation grouping with `.by` over `group_by()`** where reasonable.

Use the `.by` argument for per-operation grouping instead of `group_by()` + `ungroup()` pattern:

**✅ Preferred:**
```r
data |>
  dplyr::summarize(
    .by = c(.data$ID, .data$Group),
    mean_value = mean(.data$value)
  )

data |>
  dplyr::mutate(
    .by = .data$ID,
    centered = .data$value - mean(.data$value)
  )
```

**❌ Avoid:**
```r
data |>
  dplyr::group_by(.data$ID, .data$Group) |>
  dplyr::summarize(
    .groups = "drop",
    mean_value = mean(.data$value)
  )

data |>
  dplyr::group_by(.data$ID) |>
  dplyr::mutate(
    centered = .data$value - mean(.data$value)
  ) |>
  dplyr::ungroup()
```

**Reference:** https://dplyr.tidyverse.org/reference/dplyr_by.html

**When to use `.by`:**
- Single operation that needs grouping (summarize, mutate, filter, slice, etc.)
- When you would immediately ungroup after the operation
- When the grouping is only relevant to one step in the pipeline

**When `group_by()` may still be appropriate:**
- Multiple sequential operations need the same grouping
- When you need to preserve grouping structure for downstream operations
- When using functions that don't yet support `.by`

### Non-Standard Evaluation

Always use `.data$` pronoun for column references in dplyr and ggplot2 functions to avoid R CMD check notes about global variables.

**Examples:**
```r
# In dplyr
dplyr::mutate(new_col = .data$old_col * 2)
dplyr::filter(.data$status == "active")

# In ggplot2
ggplot2::aes(x = .data$time, y = .data$value)
```
