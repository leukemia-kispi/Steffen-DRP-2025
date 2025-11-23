# Drug response profiling (DRP) analysis

This repository accompanies the manuscript:

> Steffen et al. *Drug response profiling guides precision therapy in relapsed and refractory childhood acute lymphoblastic leukemia* (2025)

This repository provides source code to reproduce drug response analysis:

- combining perturbation measurements and drug layouts  
- log-logistic dose response fitting
- calculating drug response metrics (logAUC, logEC50, Vres)
- scoring individual drug responses relative to a reference cohort (drug fingerprints)
- visualize drug fingerprints


## Installation

1. Install the R package using `pak`
``` r
pak::local_install("Steffen-DRP-2025")
```

2. Setup the SQLlite database

``` r
db_file <- here::here("inst/db.sql")
sql <- readChar(db_file, file.info(db_file)$size)
DBI::dbExecute(con, sql)
```

3. Follow the steps outlined in `inst/analysis.Rmd`
