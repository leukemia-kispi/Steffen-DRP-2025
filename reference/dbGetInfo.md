# Get info on database connection

`dbGetInfo` returns the name of the database, host and logged in user.

## Usage

``` r
dbGetInfo(con)
```

## Arguments

- con:

  A
  [DBIConnection-class](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
  object to a DRP database

## Value

A named list with `dbname`, `username`, `host`, `port` and `db.version`
as returned by
[`DBI::dbGetInfo()`](https://dbi.r-dbi.org/reference/dbGetInfo.html) on
a fetched connection
