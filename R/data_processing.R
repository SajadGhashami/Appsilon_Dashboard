# Data processing functions
poland_data <- vroom::vroom("poland_data.csv", altrep = TRUE)

# Convert to date
convert_to_date <- function(data, columns) {
  data |>
    dplyr::mutate(across(all_of(columns), lubridate::ymd))
}

# Convert to DateTime
convert_to_datetime <- function(data, columns) {
  data |>
    dplyr::mutate(across(all_of(columns), ~ format(lubridate::ymd_hms(.), "%Y-%m-%d %H:%M:%S")))
}

# Convert to Factor
convert_to_factor <- function(data, columns) {
  data |>
    dplyr::mutate(across(all_of(columns), as.factor))
}

# Transform data
date_columns <- c("eventDate")
factor_columns <- c("vernacularName", "scientificName", "sex")

poland_data <- convert_to_date(poland_data, date_columns)
poland_data <- convert_to_factor(poland_data, factor_columns)

poland_data <- poland_data |>
  dplyr::mutate(
    eventDate_year = lubridate::year(eventDate),
    eventDate_month = lubridate::floor_date(eventDate, "month")
  )