# DeSO Socioekonomiskt Index

A simple R script for matching RegSO Områdestyp (regional statistical areas) to DeSO (demographic statistical areas) codes and their socioeconomic index for 2022.

## Overview

This repository contains R code that links the Swedish DeSO geographic classification codes with socioeconomic index data from RegSO areas. It uses data.table for efficient data manipulation.

## Files

- `code/match_deso_to_index.R`: Main script for matching DeSO codes to socioeconomic indices
- `data_in/`: Contains input data files
  - `koppling-deso2018-regso2020.csv`: Mapping between DeSO and RegSO codes
  - `regso_socioekonomisk_index_2022.csv`: Socioeconomic index data for 2023
- `data_out/`: Contains the output data
  - `deso_with_index_2022.csv`: Final matched dataset

## Usage

Run the R script to generate the matched dataset:

```r
Rscript code/match_deso_to_index.R
```