# Connect to DB using a configuration file

`connect_with_config` uses connection variables defined in a
configuration file to establish a connection to a DBMS.

## Usage

``` r
connect_with_config(
  config_name = "default",
  user_file = system.file("config.user.yml", package = PKG_NAME),
  driver = RPostgres::Postgres(),
  cache = FALSE,
  pool = TRUE
)
```

## Arguments

- config_name:

  Name of the configuration definition

- user_file:

  Name of the user configuration file (default: config.user.yml; base
  configurations are present in config.yml)

- driver:

  Database driver to use

- cache:

  Boolean indicating whether to use caching with \`R.cache“

- pool:

  Boolean indicating whether the package 'pool' (TRUE) or 'DBI' (FALSE)
  should be used for database connection

## Value

A
[DBIConnection-class](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
object to a DRP database
