# Fit a drug response model

Fit a dose-response model using a
[drm](https://rdrr.io/pkg/drc/man/drm.html) package.

## Usage

``` r
fit(
  tbl,
  fixed = c(NA, NA, 1, NA, 1),
  lowerl = c(0.01, 0, 1e-04),
  upperl = c(2.5, 1, 1e+06),
  start = c(1, 0, 100)
)
```

## Arguments

- tbl:

  A tibble with the columns:

  - concentration

  - norm_response

- fixed:

  A numeric vector specifying the values of the parameters (b, c, d,
  e, f) that should be fixed in the drc model. Variable parameters
  should be specified as NA.

- lowerl:

  Lower boundaries of the variable parameters

- upperl:

  Upper boundaries of the variable parameters

- start:

  Starting values of the variable parameters (if NULL the model chooses
  starting values automatically)

## Value

A [drm](https://rdrr.io/pkg/drc/man/drm.html) model
