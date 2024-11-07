library(tidyverse)
library(reactable)
library(leaflet)

# link definitions


instruction <- tags$a(
  shiny::icon("book-open"), "Metric Documents",
  href = "https://docs.google.com/document/d/1E5DgNGL7cl6N1c1wMPmNggmGbRV-p1ySpL_Y-D4akOs/edit?tab=t.0#heading=h.jsy537si89ig",
  target = "_blank"
)

source_code <- tags$a(
  shiny::icon("github"), "Source Code",
  href = "https://github.com/SajadGhashami/Appsilon_Dashboard",
  target = "_blank"
)

source_data <- tags$a(
  shiny::icon("database"), "Source Data",
  href = "https://drive.google.com/file/d/1l1ymMg-K_xLriFv1b8MgddH851d6n2sU/view",
  target = "_blank"
)

# Constants and utility functions
PRIMARY <- "#0675DD"
main_chart_color <- "#0675DD"
second_chart_color <- "#FF7B00"

color_palette <- colorFactor(
  c("#8DB6CD", "#EEA2AD", "#8B7D6B", "orange"), 
  levels = c("male", "female", "undetermined", NA)
)

# Bar chart helper
bar_chart <- function(label, width = "100%", height = "1rem", 
                      fill = "#CD661D", background = NULL) {
  bar <- div(style = list(background = fill, width = width, height = height))
  chart <- div(style = list(flexGrow = 1, marginLeft = "0.5rem", 
                            background = background), bar)
  div(style = list(display = "flex", alignItems = "center"), label, chart)
}

# Error graph
error_graph <- ggplot() +
  annotate("text", x = 1, y = 1,
           label = "The data does not exist. \nPlease change the filters.",
           size = 8, hjust = 0.5, vjust = 0.5) +
  theme_void()

# Column name conversion
convert_column_names <- function(df) {
  colnames(df) <- colnames(df) %>%
    str_replace_all("_", " ") %>%
    str_to_title()
  return(df)
}

# Round decimals
round_decimal_columns <- function(data) {
  for (col in names(data)) {
    if (is.numeric(data[[col]])) {
      data[[col]] <- round(data[[col]], 2)
    }
  }
  return(data)
}