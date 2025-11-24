# Run Plumber API

Run a local Plumber API server with a predefined configuration to
connect to a local or remote Postgres database.

## Usage

``` r
runAPI(
  config_name = "default",
  port = 3840,
  background = FALSE,
  pkg_path = "."
)
```

## Arguments

- config_name:

  Character string referring to the name of the configuration definition

- port:

  Integer indicating the port of the API

- background:

  Boolean indicating whether to run the Shiny app in the background and
  free the R console.

- pkg_path:

  A character string specifying the (relative) path to the package
