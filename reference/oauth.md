# Generate an OAuth client

Read OAuth client ID, secret, and token/authentication URL from a (user)
config file and return a
[oauth_client](https://httr2.r-lib.org/reference/oauth_client.html).

## Usage

``` r
oauth(config_name = "api")
```

## Arguments

- config_name:

  Character string referring to the name of the configuration definition

## Value

A list with a
[oauth_client](https://httr2.r-lib.org/reference/oauth_client.html), the
auth_url, the redirect_uri and the scope
