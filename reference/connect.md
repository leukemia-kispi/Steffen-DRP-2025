# Establish a connection to a DBMS

`connect` is a wrapper around
[dbPool](http://rstudio.github.io/pool/reference/dbPool.md) to connect
to a SQLite or Postgres database using the specified driver and
additional authentication parameters (`host`, `user` and `password`).

## Usage

``` r
connect(dbname = "drp", driver = RPostgres::Postgres(), pool = TRUE, ...)
```

## Arguments

- dbname:

  Name of the database

- driver:

  Database driver to use, either `RSQLite::SQLite()` or
  [`RPostgres::Postgres()`](https://rpostgres.r-dbi.org/reference/Postgres.html)

- pool:

  Boolean indicating whether the package 'pool' (TRUE) or 'DBI' (FALSE)
  should be used for database connection

- ...:

  Additional arguments to pass to
  [dbPool](http://rstudio.github.io/pool/reference/dbPool.md), i.e.
  host, user, password, sslmode

## Value

A
[DBIConnection-class](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
object to a DRP database
