# Drug response profiling (DRP) analysis

This repository accompanies the manuscript:

> Steffen et al. *Drug response profiling guides precision therapy in
> relapsed and refractory childhood acute lymphoblastic leukemia* (2025)

## Overview

This repository provides a step-by-step guide to drug response analysis:

- 📂 **Loading** perturbation measurements and drug layouts into a
  relational database
- 📉 **Fitting** log-logistic dose response models
- 🎯 **Computing** drug response metrics (logAUC, logEC50, Vres)
- 👍 **Scoring** individual drug fingerprints relative to a reference
  cohort
- 📊 **Visualizing** drug profiles and distributions

## Installation

1.  Install [Postgres](https://www.postgresql.org/) and setup a local
    DRP database with the following shell commands

> *Note*: If you would like to look at the data outside of R you may
> also want to get a database management tool like
> [DBeaver](https://dbeaver.io/)

``` sh
createdb steffen-drp-2025
psql -d steffen-drp-2025 -U postgres -f inst/ddl.sql
psql -d steffen-drp-2025 -U postgres -f inst/import_reference.sql
psql -d steffen-drp-2025 -U postgres -f inst/import_genes.sql 
psql -d steffen-drp-2025 -U postgres -f inst/import_drugs.sql 
```

2.  Install the `drpr` package in an R session, e.g. using `pak`

``` r
pak::local_install(".")
```

## Getting started

The DRP analytical workflow is divided into two sections:

- **Part 1**: [Loading data](articles/data_loading.md) into a Postgres
  database
- **Part 2**: [Fitting and scoring drugs](articles/analysis.md) for
  sensitivity and resistance
