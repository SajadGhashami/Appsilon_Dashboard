

# Locality Module

library(tidyverse)
library(reactable)
library(leaflet)

localityUI <- function(id) {
  ns <- NS(id)
  card(
    card_header(h3(strong("Most frequent occurrences in local areas:"))),
    reactableOutput(ns("locality_output")),
    full_screen = TRUE
  )
}

localityServer <- function(id, filtered_data) {
  moduleServer(id, function(input, output, session) {
    locality_data <- reactive({
      filtered_data() %>%
        group_by(locality) %>%
        summarise(Frequency = n()) %>%
        arrange(-Frequency)
    })
    
    output$locality_output <- renderReactable({
      data <- locality_data()
      data <- convert_column_names(data)
      
      reactable(
        data,
        showPageSizeOptions = TRUE,
        pageSizeOptions = c(5, 7,10, 20),
        defaultPageSize = 7,
        filterable = TRUE,
        columns = list(
          Frequency = colDef(
            name = "Frequency",
            align = "center",
            headerStyle = list(textAlign = "center", color = "black"),
            cell = function(value) {
              width <- paste0(value / max(data$Frequency) * 100, "%")
              bar_chart(value, width = width)
            },
            style = list(color = "black", fontWeight = "bold")
          ),
          Locality = colDef(
            name = "Locality",
            minWidth = 50,
            headerStyle = list(textAlign = "center", color = "black"),
            style = list(color = "black", fontWeight = "bold")
          )
        ),
        resizable = TRUE,
        highlight = TRUE,
        bordered = TRUE,
        striped = TRUE
      )
    })
  })
}