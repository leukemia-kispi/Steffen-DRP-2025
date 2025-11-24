# Httr2 request wrapper

A helper function to send a
[httr2](https://httr2.r-lib.org/reference/httr2-package.html) request to
the DRP API.

## Usage

``` r
request(uri, method = "get", body = NULL, oa = NULL)
```

## Arguments

- uri:

  A string specifying the URI endpoint. Supports
  [glue](https://glue.tidyverse.org/reference/glue.html) syntax.

- method:

  A string specifying the HTTP method ("post" or "put")

- body:

  A list or [tibble](https://tibble.tidyverse.org/reference/tibble.html)
  to send as the body

- oa:

  An OAuth list return by [`oauth()`](oauth.md) with a
  [oauth_client](https://httr2.r-lib.org/reference/oauth_client.html),
  the auth_url, the redirect_uri and the scope

## Value

An atomic vector, list or `NULL`
