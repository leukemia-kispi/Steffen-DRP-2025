# Calculate the normalized logEC50

`calculate_norm_logEC50()` computes the normalized (feature scaled)
logEC50. The minimal logEC50 is defined as `x1 - log_extra` and the
maximal logEC50 as `x2 + log_extra`, where `x1` and `x2` are the lowest
and highest tested logarithmic concentration.

## Usage

``` r
calculate_norm_logEC50(logEC50, x1, x2, log_extra)
```

## Arguments

- logEC50:

  Logarithmic area-under-the-curve

- x1:

  Numeric indicating the minimal tested logarithmic concentration

- x2:

  Numeric indicating the maximal tested logarithmic concentration

- log_extra:

  Integer indicating the extra log orders around the measured
  concentration range beyond which the logEC50 is clipped

## Value

Normalized EC50 for the logarithmic dose response curve
