# Create a ggplot with standard theme settings

Internal helper function that initializes a ggplot object with
consistent theme and styling settings used across multiple plotting
functions in the package.

## Usage

``` r
standard_ggplot(data)
```

## Arguments

- data:

  A data frame to be passed to
  [`ggplot2::ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html).

## Value

A
[`ggplot2::ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html)
object with standard theme settings applied, including a black and white
theme, custom axis styling, and legend positioning at the bottom.
