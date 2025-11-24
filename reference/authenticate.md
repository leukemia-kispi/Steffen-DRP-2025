# Authenticate to API

`authenticate` is a wrapper around
[req_oauth_auth_code](https://httr2.r-lib.org/reference/req_oauth_auth_code.html).
It receives a [request](https://httr2.r-lib.org/reference/request.html)
and a OAuth list, returning a modified request.

## Usage

``` r
authenticate(req, oal = NULL)
```

## Arguments

- req:

  A [request](https://httr2.r-lib.org/reference/request.html)

- oal:

  An OAuth list return by [`oauth()`](oauth.md) with a
  [oauth_client](https://httr2.r-lib.org/reference/oauth_client.html),
  the auth_url, the redirect_uri and the scope

## Value

A modified HTTP
[request](https://httr2.r-lib.org/reference/request.html) that will use
OAuth;
