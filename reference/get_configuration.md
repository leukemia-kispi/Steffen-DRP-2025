# Get configuration settings

Load configuration settings from `inst/config.yml"` file and optionally
from a user-defined configuration file (by default
`inst/config.user.yml`).

## Usage

``` r
get_configuration(
  config_name = "default",
  user_file = system.file("config.user.yml", package = PKG_NAME)
)
```

## Arguments

- config_name:

  String specifying the configuration name

- user_file:

  Path to a user defined configuration file (default: config.user.yml
  located under /inst)

## Value

A list with the configuration settings
