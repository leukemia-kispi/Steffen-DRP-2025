# Invert the log-logistic curve

`inverse_ll4` calculates the concentration (x) for a given (absolute)
response (y) by solving the four-parameter log-logistic function for x.

## Usage

``` r
inverse_ll4(y, b, c, d, logEC50)
```

## Arguments

- y:

  Drug response

- b:

  Slope parameter

- c:

  Lower asymptote

- d:

  Upper asymptote

- logEC50:

  Logarithmic half-maximum effective concentration (relative EC50)

## Value

Concentration at which the given response is observed

## See also

[`calculate_absolute_logEC()`](calculate_absolute_logEC.md)
