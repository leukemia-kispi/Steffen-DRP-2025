# Calculate absolute logEC50

`calculate_absolute_logEC` computes the absolute effect concentration
(e.g. absolute logEC50 or logEC20) for the LL.2, LL.3 or LL.4 model. The
absolute logEC50 is the concentration where the four-parameter
log-logistic function crosses the 50% effect treshold. Note: logEC20 -\>
20% effect = 20% inhibition = 80% viability

## Usage

``` r
calculate_absolute_logEC(effect, b, c, d, logEC50)
```

## Arguments

- effect:

  Percent absolute effect (e.g. 50 or 20)

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

## Note

This is equivalent to `drc::ED(mdl, effect/100, type="absolute")` where
`mdl` is a [`drc::drm()`](https://rdrr.io/pkg/drc/man/drm.html) object
