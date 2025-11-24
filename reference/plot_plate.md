# Draw a multi-well plate

Draw a multi-well plate

## Usage

``` r
plot_plate(
  plate,
  color,
  alpha,
  n_wells = NULL,
  row = row,
  col = col,
  label = NULL,
  label_size = 2,
  text = NULL,
  palette = "hue12",
  limits = NULL,
  midpoint = NULL,
  transform = "identity",
  show_legend = TRUE,
  save = FALSE,
  filename = NULL,
  width = 6,
  height = 4
)
```

## Arguments

- plate:

  A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with at
  least the following columns:

  - row

  - col and usually either

  - drug

  - concentration or

  - response/norm_response

- color:

  \<`tidy-select`\> Name of the column to map the color

- alpha:

  \<`tidy-select`\> Name of the column to map the opacity

- n_wells:

  Integer specifying the number of wells of the plate, if `NULL` derive
  the well number from `plate`

- row:

  \<`tidy-select`\> Name of the column to identify the plate rows

- col:

  \<`tidy-select`\> Name of the column to identify the plate columns

- label:

  \<`tidy-select`\> Name of a column to be used for labeling the well

- label_size:

  Integer specifying the size of the label

- text:

  Name of the column to be used for labeling the tooltips in the
  interactive plot

- palette:

  A character vector specifying the color palette (discrete or
  continuous)

- limits:

  A numeric vector of lower and upper limits of the color/fill scale

- midpoint:

  Numeric specifying the midpoint of colorscale

- transform:

  For continuous scales the name of the transformation object (e.g.
  "log10") or the object itself ("identity")

- show_legend:

  Boolean indicating whether to show the legend

- save:

  Boolean indicating whether to write the plot to disk

- filename:

  Character string specifying the filename

- width:

  Numeric specifying the width of the plot

- height:

  Numeric specifying the height of the plot

## Value

A [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html) object
