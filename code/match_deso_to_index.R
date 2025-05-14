# Load required libraries
library(data.table)
library(stringi)

# Set working directory to the project root
# Uncomment and modify if needed
# setwd("/Users/andreas/Code/deso_sociekonomiskt_index")

# Define paths to data files
koppling_path <- "data/koppling-deso2018-regso2020.csv"
index_path <- "data/regso_socioekonomisk_index_2023.csv"

# Read files with proper encoding
# Read koppling file - links DeSO to RegSO
koppling_dt <- fread(koppling_path, encoding = "UTF-8")

# Read socioeconomic index file
index_raw <- fread(index_path, encoding = "UTF-8", header = TRUE)

# Clean column names for the index file
names(index_raw) <- c("region", "index_2023")

# Clean up the data
index_dt <- index_raw[!is.na(index_2023) & nchar(region) > 0]

# Extract municipality name and RegSO name from the region column
# Format is typically "Municipality (RegSO name)"
index_dt[, `:=`(
  Kommunnamn = gsub("\\s*\\(.*\\)\\s*$", "", region),
  RegSO_2020 = gsub("^.*\\((.*)\\)\\s*$", "\\1", region)
)]

# Ensure encoding consistency for Swedish characters in both datasets
index_dt[, `:=`(
  Kommunnamn = stri_trans_general(Kommunnamn, "Latin-ASCII"),
  RegSO_2020 = stri_trans_general(RegSO_2020, "Latin-ASCII")
)]

koppling_dt[, `:=`(
  Kommunnamn = stri_trans_general(Kommunnamn, "Latin-ASCII"),
  RegSO_2020 = stri_trans_general(RegSO_2020, "Latin-ASCII")
)]

# Join the datasets to match DeSO codes with socioeconomic index
# Use both municipality name and RegSO name to ensure correct matching
result_dt <- koppling_dt[index_dt, on = .(Kommunnamn, RegSO_2020), nomatch = 0]

# Keep only the essential columns
final_dt <- result_dt[, .(
  Kommun,
  Kommunnamn,
  DeSO_2018,
  RegSO_2020,
  RegSOkod_2020,
  socioekonomiskt_index = index_2023
)]

# Check for any DeSO codes without a matching index
missing_matches <- koppling_dt[!final_dt, on = .(DeSO_2018)]
if (nrow(missing_matches) > 0) {
  message("Warning: ", nrow(missing_matches), " DeSO areas without a matching index")
  print(head(missing_matches))
}

# Save the result to a new CSV file
output_path <- file.path("data_out", "deso_with_index_2023.csv")
fwrite(final_dt, output_path)
