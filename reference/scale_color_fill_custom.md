# Add custom color and fill scale

Add a custom color and/or fill scale depending on the type of input data

## Usage

``` r
scale_color_fill_custom(
  data,
  color_fill,
  aesthetics = c("color", "fill"),
  palette = NULL,
  limits = NULL,
  midpoint = NULL,
  transform = "identity",
  color_fill_name = NULL,
  show_na = TRUE,
  na.value = "gray"
)
```

## Arguments

- data:

  [tibble](https://tibble.tidyverse.org/reference/tibble.html) of the
  dataset passed to
  [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)

- color_fill:

  \<`tidy-select`\> color and/or fill aesthetics

- aesthetics:

  Character string or vector specifying the names of the aesthetics to
  use for the scale. This is useful to a set the same color settings to
  multiple aesthetics simultaneously.

- palette:

  Color palette specified by either:

  - a character string specifying a colormap from colorbrewer

  - a character string from the global variable "palettes"

  - a character string specifying a colormap from
    paletteer::paletteer_d()

  - a character vector of HEX colors starting with "#"

  - a character vector of built-in colors specifying

- limits:

  Numeric vector specifying the limits of the color scale

- midpoint:

  Numeric specifying the midpoint of colorscale

- transform:

  Character string specifying the transformation to be applied to the
  color scale, e.g. "log10"

- color_fill_name:

  Character string specifying the name of the color scale. If NULL use
  the name of the color_fill tidy-selection

- show_na:

  Boolean indicating whether to show NA in the legend

- na.value:

  Character indicating the color to use for NA values

## Value

List of ggplot2 color and/or fill scale(s)
