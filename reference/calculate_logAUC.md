# Calculate the logarithmic area-under-curve (logAUC)

`calculate_logAUC` computes the area-under-the-curve for the ll.2, ll.3
and ll.4 model An analytical solution for the ll.5 model is currently
not implemented.

## Usage

``` r
calculate_logAUC(b, c, d, logEC50, x1, x2)
```

## Arguments

- b:

  Inverse slope parameter

- c:

  Lower asymptote

- d:

  Upper asymptote

- logEC50:

  Logarithmic half-maximum effective concentration (relative EC50)

- x1:

  Numeric indicating the minimal tested logarithmic concentration (lower
  integration limit)

- x2:

  Numeric indicating the maximal tested logarithmic concentration (upper
  integration limit)

## Value

Area under the logarithmic dose response curve
