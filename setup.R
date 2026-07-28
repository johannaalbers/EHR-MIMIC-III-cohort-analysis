# Installs the packages this analysis needs.
# Run once:  source("setup.R")
#
# For a reproducible, version-pinned record instead, run renv::init()
# in this folder and commit the resulting renv.lock.

packages <- c(
  "DBI", "RMariaDB", "odbc", "data.table", "dplyr", "lubridate",
  "readr", "stringr", "tibble", "tidyr"
)

missing <- packages[!packages %in% rownames(installed.packages())]
if (length(missing)) install.packages(missing)
invisible(lapply(packages, library, character.only = TRUE))

cat("\n--- session info, paste into the README ---\n")
print(sessionInfo())
