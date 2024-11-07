
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
library(data.table)
library(furrr)
library(parallelly)
library(magrittr)

plan(multisession)  # Set up parallel processing

# This was is excluded form the repo
headers <- fread("extracted_data\\biodiversity-data\\occurence.csv", nrows = 0)
PL_data <- fread(cmd='findstr /r Poland \"extracted_data\\biodiversity-data\\occurence.csv"')
setnames(PL_data, names(headers))
write.csv(PL_data, "poland_data.csv")

