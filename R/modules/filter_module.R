
# Filter Module

library(tidyverse)
library(reactable)
library(leaflet)

filterUI <- function(id) {
  ns <- NS(id)
  sidebar(
    width = 350,
    open = list(desktop = "closed", mobile = "closed"),
    accordion(
      open = FALSE,
      accordion_panel(
        "Date Filters",
        icon = fontawesome::fa("calendar"),
        dateRangeInput(ns("eventDate"), "Event Date Filter:",
                       start = min(poland_data$eventDate, na.rm = TRUE),
                       end = max(poland_data$eventDate, na.rm = TRUE),
                       min = min(poland_data$eventDate, na.rm = TRUE),
                       max = max(poland_data$eventDate, na.rm = TRUE),
                       format = "yy/mm/dd",
                       separator = "to")
      ),
      accordion_panel(
        "Species Filters",
        icon = fontawesome::fa("feather-pointed"),
        selectizeInput(
          ns("vernacularName"), "Vernacular Name",
          multiple = TRUE,
          choices = character(0),
          options = list(maxOptions = 1000)
        ),
        selectizeInput(
          ns("scientificName"), "Scientific Name",
          multiple = TRUE,
          choices = character(0),
          options = list(maxOptions = 1000)
        )
      )
    ),
    input_task_button(ns("update_results"), "Update Data", 
                      type="success", icon=fontawesome::fa("play"))
  )
}

filterServer <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    
    # Update selectize inputs
    observe({
      updateSelectizeInput(
        session = session,
        inputId = "vernacularName",
        choices = unique(data$vernacularName),
        server = TRUE
      )
      
      updateSelectizeInput(
        session = session,
        inputId = "scientificName",
        choices = unique(data$scientificName),
        server = TRUE
      )
    })
    
    # Filter data based on inputs
    filtered_data <- eventReactive(input$update_results, {
      temp_data <- data
      
      if (!is.null(input$eventDate) && length(input$eventDate) == 2) {
        temp_data <- temp_data %>%
          filter((eventDate >= input$eventDate[1] & 
                    eventDate <= input$eventDate[2]) | is.na(eventDate))
      }
      
      if (!is.null(input$vernacularName) && length(input$vernacularName) > 0) {
        temp_data <- temp_data %>% 
          filter(vernacularName %in% input$vernacularName | 
                   is.na(vernacularName))
      }
      
      if (!is.null(input$scientificName) && length(input$scientificName) > 0) {
        temp_data <- temp_data %>% 
          filter(scientificName %in% input$scientificName | 
                   is.na(scientificName))
      }
      
      temp_data
    }, ignoreNULL = FALSE)
    
    return(filtered_data)
  })
}