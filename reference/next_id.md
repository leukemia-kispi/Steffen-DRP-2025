# Get next ID

Get the next ID from the primary key column of a database table

## Usage

``` r
next_id(con, tbl, pk = NULL, exclude = NULL, named = FALSE)
```

## Arguments

- con:

  A
  [DBIConnection-class](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
  object to a DRP database

- tbl:

  A character string specifying the database table name

- pk:

  A character string specifying the primary key column name (if `NULL`
  look up the pk in the database)

- exclude:

  A numeric vector of IDs in the primary key to exclude from the search

- named:

  A logical indicating whether to return a named vector with the primary
  key name

## Value

An integer or named vector specifying the next free ID
