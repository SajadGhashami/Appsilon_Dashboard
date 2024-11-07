


# Timeline Module

library(tidyverse)
library(reactable)
library(leaflet)

timelineUI <- function(id) {
  ns <- NS(id)
  navset_card_underline(
    full_screen = TRUE,
    title = h4(strong("Timeline (You can activate 'Log transform' on the right sidebar)")),
    sidebar = sidebar(
      position = "right",
      open = FALSE,
      checkboxInput(ns("log_transform"), "Log Transform", FALSE)
    ),
    nav_panel(h6("Monthly"),
              plotlyOutput(ns("timeline_monthly_output"))
    ),
    nav_panel(h6("Yearly"),
              plotlyOutput(ns("timeline_yearly_output"))
    )
  )
}

timelineServer <- function(id, filtered_data) {
  moduleServer(id, function(input, output, session) {
    monthly_trends_data <- reactive({
      filtered_data() %>%
        group_by(eventDate_month) %>%
        summarise(Frequency = n(),
                  total_indivdual_count = sum(individualCount, na.rm = TRUE))
    })
    
    yearly_trends_data <- reactive({
      filtered_data() %>%
        group_by(eventDate_year) %>%
        summarise(Frequency = n(),
                  total_indivdual_count = sum(individualCount, na.rm = TRUE))
    })
    
    output$timeline_monthly_output <- renderPlotly({
      data <- monthly_trends_data()
      
      if (is.null(data) || nrow(data) == 0) {
        return(ggplotly(error_graph))
      }
      
      p <- ggplot(data, aes(x=eventDate_month, y=Frequency)) +
        geom_line(color="#69b3a2", linewidth=1) +
        geom_point(aes(size=total_indivdual_count), color="#CD3700", alpha=0.5, show.legend=FALSE) +
        theme_ipsum() +
        ggtitle("Evolution of Occurrences") +
        xlab("Date") +
        ylab("Frequency") +
        theme_tufte() +
        theme(
          plot.title = element_text(hjust = 0.5, size = 16),
          axis.title.x = element_text(hjust = 0.5, size = 14),
          axis.title.y = element_text(hjust = 0.5, size = 14),
          axis.text.x = element_text(size = 12),
          axis.text.y = element_text(size = 12),
          plot.margin = unit(c(0, 0, 0, 0),"inches")
        ) +
        expand_limits(y = c(max(data$Frequency) - 1.2*max(data$Frequency), 
                            1.2*max(data$Frequency)))
      
      if(input$log_transform) {
        p <- p + scale_y_continuous(trans = "log10")
      }
      
      ggplotly(p) %>%
        layout(
          xaxis = list(
            rangeslider = list(type = "date", visible = TRUE)
          )
        )
    })
    
    output$timeline_yearly_output <- renderPlotly({
      data <- yearly_trends_data()
      
      if (is.null(data) || nrow(data) == 0) {
        return(ggplotly(error_graph))
      }
      
      data$eventDate_year <- as.numeric(as.character(data$eventDate_year))
      
      p <- ggplot(data, aes(x=eventDate_year, y=Frequency)) +
        geom_area(fill="#EE7621", alpha=0.5) +
        geom_line(color="#EE7621", linewidth=1) +
        geom_point(aes(size=total_indivdual_count), color="#FFE4C4", fill="#EE7621", show.legend=FALSE) +
        geom_text(aes(label=paste(round(Frequency/1000, 1), "k")),
                  vjust=-0.5, size=4, color="black", check_overlap=TRUE) +
        theme_ipsum() +
        ggtitle("Evolution of Occurrences") +
        xlab("Year") +
        ylab("Frequency") +
        theme_tufte() +
        theme(
          plot.title = element_text(hjust = 0.5, size = 16),
          axis.title.x = element_text(hjust = 0.5, size = 14),
          axis.title.y = element_text(hjust = 0.5, size = 14),
          axis.text.x = element_text(size = 12),
          axis.text.y = element_text(size = 12),
          plot.margin = unit(c(0, 0, 0, 0), "inches")
        ) +
        expand_limits(y = c(max(data$Frequency, na.rm=TRUE) - 1.2*max(data$Frequency, na.rm=TRUE),
                            1.2*max(data$Frequency, na.rm=TRUE)))
      
      if (input$log_transform) {
        p <- p + scale_y_continuous(trans = "log10")
      }
      
      ggplotly(p) %>%
        layout(
          xaxis = list(
            rangeslider = list(type = "date", visible = TRUE)
          )
        )
    })
  })
}