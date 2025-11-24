# Four-parameter log-Logistic model

The log-logistic four-parameter model (ll.4) as implemented by the
[drm](https://rdrr.io/pkg/drc/man/drm.html) package and decribed from
Ritz et al. PLOS ONE 2015.

## Usage

``` r
ll4(x, b, c, d, logEC50)
```

## Arguments

- x:

  Logarithmic concentration

- b:

  Inverse slope parameter

- c:

  Lower asymptote

- d:

  Upper asymptote

- logEC50:

  Logarithmic half-maximum effective concentration (relative EC50)

## Value

Predicted effect
