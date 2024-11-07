# Testing the updated_poland_data Function
# Step 1: Prepare mock data for testing
library(testthat)
library(dplyr)
library(lubridate)

# Create sample data resembling `poland_data`
sample_data <- data.frame(
  eventDate = as.Date(c("2021-01-01", "2021-02-01", "2021-03-01", "2021-04-01", "2021-01-15")), 
  vernacularName = c("Species A", "Species B", "Species A", "Species C", NA),
  scientificName = c("Sci A", "Sci B", "Sci A", NA, "Sci C")
)

# Mock user inputs
input <- list(
  eventDate = as.Date(c("2021-01-01", "2021-03-01")),# even_date never can be empty because of the input restrictions
  vernacularName = c("Species A", "Species B"),
  scientificName = c("Sci A", "Sci B")
)

updated_poland_data <- function(data, input) {
  # Filter by eventDate if specified
  if (!is.null(input$eventDate) && length(input$eventDate) == 2) {
    data <- data %>%
      filter((eventDate >= input$eventDate[1] & eventDate <= input$eventDate[2]) | is.na(eventDate))
  }
  
  # Skip filtering for vernacularName if NULL
  if (!is.null(input$vernacularName) && length(input$vernacularName) > 0) {
    data <- data %>%
      filter(vernacularName %in% input$vernacularName | is.na(vernacularName) |is.null(vernacularName))
  }
  
  # Skip filtering for scientificName if NULL
  if (!is.null(input$scientificName) && length(input$scientificName) > 0) {
    data <- data %>%
      filter(scientificName %in% input$scientificName | is.na(scientificName)|is.null(vernacularName))
  }
  
  return(data)
}

# Tests for updated_poland_data

# Test that data is correctly filtered by date range
test_that("updated_poland_data filters by eventDate", {
  filtered_data <- updated_poland_data(sample_data, input)
  expect_true(all(filtered_data$eventDate >= input$eventDate[1] & filtered_data$eventDate <= input$eventDate[2], na.rm = TRUE))
})

# Test that data is filtered by vernacular name
test_that("updated_poland_data filters by vernacularName", {
  input$vernacularName <- "Species A"
  filtered_data <- updated_poland_data(sample_data, input)
  expect_true(all(filtered_data$vernacularName %in% input$vernacularName | is.na(filtered_data$vernacularName)))
})

# Test that data is filtered by scientific name
test_that("updated_poland_data filters by scientificName", {
  input$scientificName <- "Sci B"
  filtered_data <- updated_poland_data(sample_data, input)
  expect_true(all(filtered_data$scientificName %in% input$scientificName | is.na(filtered_data$scientificName)))
})


# Test empty input values for vernacular name
test_that("updated_poland_data returns all data when vernacularName is NULL", {
  input$vernacularName <- NULL
  filtered_data <- updated_poland_data(sample_data, input)
  expect_equal(nrow(filtered_data), 
               nrow(sample_data %>%
                 filter((eventDate >= input$eventDate[1] & eventDate <= input$eventDate[2]) | is.na(eventDate) | is.null(eventDate)) %>%
                 filter(scientificName %in% input$scientificName | is.na(scientificName)|is.null(vernacularName))
                 )
               )
})


# Test empty input values for scientific name (should return all data)
test_that("updated_poland_data returns all data when scientificName is NULL", {
  input$scientificName <- NULL
  filtered_data <- updated_poland_data(sample_data, input)
  expect_equal(nrow(filtered_data), 
               nrow(sample_data %>%
                      filter((eventDate >= input$eventDate[1] & eventDate <= input$eventDate[2]) | is.na(eventDate) | is.null(eventDate)) %>%
                      filter(vernacularName %in% input$vernacularName | is.na(vernacularName) |is.null(vernacularName))
               )
               )
})

# Testing Edge Cases
# Test when there is no matching data
test_that("updated_poland_data returns empty when no match", {
  input$vernacularName <- "Non-existent Species"
  filtered_data <- updated_poland_data(sample_data, input)
  expect_equal(nrow(filtered_data), 0)
})

# Test when all filterable columns contain NA values
test_that("updated_poland_data handles all NA values gracefully", {
  all_na_data <- sample_data %>%
    mutate(eventDate = NA, vernacularName = NA, scientificName = NA)
  filtered_data <- updated_poland_data(all_na_data, input)
  expect_equal(nrow(filtered_data), nrow(all_na_data))
})

# Test with an empty data frame
test_that("updated_poland_data returns empty data frame when input data is empty", {
  empty_data <- sample_data[0, ]
  filtered_data <- updated_poland_data(empty_data, input)
  expect_equal(nrow(filtered_data), 0)
})

# Test for dates completely out of range
test_that("updated_poland_data returns empty when date range has no matches", {
  input$eventDate <- as.Date(c("2023-01-01", "2023-12-31"))  # Future dates
  filtered_data <- updated_poland_data(sample_data, input)
  expect_equal(nrow(filtered_data), 0)
})
