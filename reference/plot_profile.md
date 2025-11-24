# Plot drug response profiles

Plotting drug responses as a function of concentration.

## Usage

``` r
plot_profile(
  con,
  .drug_mask,
  .fg_sample_mask = FALSE,
  .bg_cohort_mask = TRUE,
  color_fill = abs_logEC50,
  label = lknumber,
  size = NULL,
  readout_id = c(1, 5),
  bg_readout_id = c(1, 5),
  transform = "identity",
  palette = NULL,
  limits = NULL,
  midpoint = NULL,
  quantiles = FALSE,
  lower_quantile = p10,
  upper_quantile = p90,
  sort_by = NULL,
  n_drugs = NULL,
  drop_missing_drugs = FALSE,
  lump_n = NULL,
  drop_l = NULL,
  na_as_other = FALSE,
  ylimits = c(0, 1.05),
  xlimits = NULL,
  save = FALSE,
  filename = NULL,
  color_fill_name = NULL,
  bg_color = NULL,
  show_na = TRUE,
  progressbar = TRUE,
  facet_samples = TRUE,
  nrow = NULL,
  ncol = NULL,
  width = 3.6,
  height = 2.5
)
```

## Arguments

- con:

  [DBIConnection-class](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
  object to a DRP database

- .drug_mask:

  \<[`data-masking`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  expression returning a logical vector and selecting the drugs to be
  displayed

- .fg_sample_mask:

  \<[`data-masking`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  expression returning a logical vector and selecting the samples
  displayed in the foreground based on the columns in plate_content_view

- .bg_cohort_mask:

  \<[`data-masking`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  expression to select the samples displayed in the background

- color_fill:

  \<`tidy-select`\> Name of the column to be used for color and fill

- label:

  \<`tidy-select`\> Name of a column to be used for labeling each drug
  curve

- size:

  Numeric specifying the line size

- readout_id:

  Integer or vector of integers specifying the id(s) of the readout in
  the foreground

- bg_readout_id:

  Integer or vector of integers specifying the id(s) of the readout in
  the background

- transform:

  For continuous scales the name of the transformation object (e.g.
  "log10") or the object itself ("identity")

- palette:

  A character vector specifying the color palette (discrete or
  continuous)

- limits:

  A numeric vector of lower and upper limits of the color/fill scale

- midpoint:

  Numeric specifying the midpoint of colorscale

- quantiles:

  Boolean indicating whether to draw a percentile interval instead of
  individual background curves

- lower_quantile:

  \<`tidy-select`\> Name of the lower percentile column in the
  `cohort_stats` table

- upper_quantile:

  \<`tidy-select`\> Name of the upper percentile column in the
  `cohort_stats` table

- sort_by:

  \<`tidy-select`\> Name of the column to be used for sorting facets

- n_drugs:

  Integer specifying the maximal number of drugs

- drop_missing_drugs:

  Boolean indicating whether to drop drugs that are missing in the
  `.fg_sample_mask`

- lump_n:

  Named vector of integers specifying the maximum number of levels for
  each feature (including the lumped "Other" category), e.g. c(diagnosis
  = 3)

- drop_l:

  Named list of character vectors specifying the levels to drop for each
  feature

- na_as_other:

  Boolean indicating whether to lump NA values into the "Other" category

- ylimits:

  Numeric vector of specifying the y-axis limits

- xlimits:

  Numeric vector specifying the x-axis limits

- save:

  Boolean indicating whether to write the plot to disk

- filename:

  Character string specifying the filename

- color_fill_name:

  Character string specifying an alternative name for the color/fill
  legend

- bg_color:

  Character specifying a uniform color for the background fit lines

- show_na:

  Boolean indicating whether to translate NA values

- progressbar:

  Boolean indicating whether to show a progressbar

- facet_samples:

  Boolean indicating whether to separate samples into individual facets

- nrow:

  Integer indicating the number of rows to use for facetting

- ncol:

  Integer indicating the number of columns to use for facetting

- width:

  Numeric specifying the width of the plot

- height:

  Numeric specifying the height of the plot

## Value

[ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html) object

## Examples

``` r
if (FALSE) { # interactive()
plot_profile(con,
  .drug_mask = drug_name %in% c("Venetoclax", "Navitoclax"),
  .fg_sample_mask = lknumber == "LK2000.001",
  color_fill = norm_logAUC,
  palette = "orange_blue",
  color_fill_name = "logAUC"
)
}
```
