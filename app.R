# Appsilon Dashboard
# Created by Sajad Ghashami

# Load packages ----------------------------------------------------------------
library(shiny)
library(bslib)
library(tools)
library(thematic)
library(bsicons)
library(fontawesome)
library(plotly)
library(ggthemes)
library(shinyBS)
library(data.table)
library(vroom)
library(ggmap)
library(leaflet)
library(hrbrthemes)
library(reactable)
library(htmltools)
library(tidyverse)
library(dplyr)
library(magrittr)

# Helper functions and data loading --------------------------------------------
source("R/data_processing.R")
source("R/utils.R")
source("R/modules/map_module.R")
source("R/modules/locality_module.R")
source("R/modules/timeline_module.R")
source("R/modules/filter_module.R")

# UI -------------------------------------------------------------------------
ui <- page_navbar(
  selected = "Main Page",
  ### add css file
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
  ),
  title = tags$span(
    tags$img(src = "appsilon.png", width = "76px", height = "76px", 
             class = "me-3", alt = "Appsilon Dashboard", "Appsilon Dashboard"),
  ),
  id = "nav",
  theme = bs_theme(preset = "shiny", "primary" = PRIMARY),
  
  sidebar = filterUI("filters"),
  
  nav_spacer(),
  nav_panel("Main Page",
            value_box(
              showcase = bs_icon("geo-alt", class = "showcase-icon custom-icon-color"),
              title = "",
              value = h2(strong("Appsilon Homework:")),
              h5("Includes visualizing observed species. Data comes from the Global Biodiversity Information Facility.",
                 bs_icon("balloon")), 
              br(), "",
              theme = "warning",
              min_height = 150
            ),
            
            # First row
            layout_columns(
              fill = FALSE,
              mapUI("map"),
              localityUI("locality"),
              min_height = 600,
              col_widths = c(6, 6)
            ),
            
            # Second row
            layout_columns(
              fill = FALSE,
              timelineUI("timeline"),
              full_screen = TRUE,
              col_widths = c(12),
              min_height = 600
            ),
            br(),
  ),
  
  nav_item(input_dark_mode(id = "dark_mode", mode = "light")),
  nav_menu(
    title = "Links",
    align = "right",
    nav_item(instruction),
    nav_item(source_code),
    nav_item(source_data)
  )
)

# Server ---------------------------------------------------------------------
server <- function(input, output, session) {
  # Get filtered data from filter module
  filtered_data <- filterServer("filters", poland_data)
  
  # Pass filtered data to other modules
  mapServer("map", filtered_data)
  localityServer("locality", filtered_data)
  timelineServer("timeline", filtered_data)
}

shinyApp(ui, server)