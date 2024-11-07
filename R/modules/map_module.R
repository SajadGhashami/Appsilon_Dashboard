
library(tidyverse)
library(reactable)
library(leaflet)

# Map Module
mapUI <- function(id) {
  ns <- NS(id)
  card(
    card_header(h3(strong("Occurrence Map:"))),
    leafletOutput(ns("map_output")),
    card_footer(
      class = "fs-6",
      "A pop-up shows up when each observation is clicked"
    ),
    full_screen = TRUE
  )
}

mapServer <- function(id, filtered_data) {
  moduleServer(id, function(input, output, session) {
    output$map_output <- renderLeaflet({
      data <- filtered_data()
      
      if (is.null(data) || nrow(data) == 0) {
        return(error_graph)
      }
      
      leaflet(data) %>%
        addProviderTiles("CartoDB.Positron") %>%
        addCircleMarkers(
          lng = ~longitudeDecimal, lat = ~latitudeDecimal,
          radius = 8,
          color = ~color_palette(sex),
          fillColor = ~color_palette(sex),
          fillOpacity = 0.8,
          stroke = TRUE,
          weight = 1,
          clusterOptions = markerClusterOptions(interactive = TRUE),
          popup = ~paste(
            "<strong>Vernacular Name:</strong>", vernacularName, "<br>",
            "<strong>Scientific Name:</strong>", scientificName, "<br>",
            "<strong>Sex:</strong>", sex, "<br>",
            "<a href='", occurrenceID, "' target='_blank'>View Observation</a>"
          )
        ) %>%
        setView(lng = 19.1451, lat = 52.0692, zoom = 6) %>%
        addControl(
          "Clustered Occurrences",
          position = "topright"
        ) %>%
        addLegend("bottomright",
                  pal = color_palette,
                  values = ~sex,
                  title = "Sex",
                  opacity = 1)
    })
  })
}