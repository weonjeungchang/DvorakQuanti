#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyWidgets)


# ==============================================================================
# Define UI for application that draws a histogram
# ==============================================================================
ui <- navbarPage(

    "DvorakQuanti",
    # shinythemes::themeSelector(),
    theme = shinythemes::shinytheme("darkly"),
    # theme = shinythemes::shinytheme("flatly"),

    source('output_PerformanceAttribution.R', local = TRUE)$value,
    source('output_AssetAllocation.R', local = TRUE)$value,
    source('output_Risk.R', local = TRUE)$value,
    source('output_Smoothing.R', local = TRUE)$value,
    source('output_author.R', local = TRUE)$value
)


# ==============================================================================
# Define server logic required to draw a histogram
# ==============================================================================
server <- function(input, output) {

    source('read_ui.R', local = TRUE)
}


# ==============================================================================
# Run the application 
# ==============================================================================
shinyApp(ui = ui, server = server)


