# convert a pair of simple logistic regression coefficients into P(Y\|T) curve:

convert a pair of simple logistic regression coefficients into P(Y\|T)
curve:

## Usage

``` r
build_phi_function_from_coefs(coefs)
```

## Arguments

- coefs:

  numeric vector of coefficients

## Value

function(t) P(Y=1\|T=t)
