# Calculate relative logEC

`calculate_relative_logEC` computes the relative effect concentration
(e.g. relative logEC50 or logEC20) for the LL.2, LL.3 or LL.4 model. The
relative logEC50 is the concentration at which the effect is
half-maximal relative to the maximal effect (Emax). The Emax relates to
a residual cell population not affected by the drug. Note: logEC20 -\>
20% relative effect = 20% relative inhibition = 80% relative viability

## Usage

``` r
calculate_relative_logEC(effect, b, c, d, logEC50)
```

## Arguments

- effect:

  Percent relative effect (e.g. 50 or 20)

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

This is equivalent to `drc::ED(mdl, effect/100, type="relative")` where
`mdl` is a [`drc::drm()`](https://rdrr.io/pkg/drc/man/drm.html) object
