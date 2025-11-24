# Calculate the normalized area-under-curve (norm. logAUC)

`calculate_norm_logAUC` computes the normalized AUC from the logAUC
within the lower/upper integration limits

## Usage

``` r
calculate_norm_logAUC(logAUC, x1, x2)
```

## Arguments

- logAUC:

  Logarithmic area-under-the-curve

- x1:

  Numeric indicating the minimal tested logarithmic concentration (lower
  integration limit)

- x2:

  Numeric indicating the maximal tested logarithmic concentration (upper
  integration limit)

## Value

Normalized area under the logarithmic dose response curve
