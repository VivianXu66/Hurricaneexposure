library(tidyverse)
library(shiny)

# the hurricaneexposure package
## here is the package's Github page: https://github.com/geanders/hurricaneexposure
## here is the description document: https://cran.r-project.org/web/packages/hurricaneexposure/hurricaneexposure.pdf
## to see more details about the hurricaneexposure package: https://cran.r-project.org/web/packages/hurricaneexposure/vignettes/hurricaneexposure.html

# download the hurricaneexposure package
library(drat)
addRepo("geanders")
#install.packages("hurricaneexposuredata")
library(hurricaneexposuredata)

# use 2 datasets in the package
# attach the hurr_tracks data
data("hurr_tracks")
data_ht <- as.data.frame(hurr_tracks)
# add a column "year"
data_ht$year <- substr(data_ht$date, 1, 4)

# attach the rain data
data("rain")
data_rain <- as.data.frame(rain)

# attach the wind speed data
data("storm_winds")
data_winds<-as.data.frame(storm_winds)

# attach the estimated wind speed data
data("ext_tracks_wind")
data_estimate<-as.data.frame(ext_tracks_wind)


ui <- fluidPage(
    title = "Examples of Data Tables",
    sidebarLayout(
        tabsetPanel(
            conditionalPanel(
                'input.dataset === "data_ht"'),
            conditionalPanel(
                'input.dataset === "data_rain"'),
            conditionalPanel(
                'input.dataset === "data_winds"'),
            conditionalPanel(
                'input.dataset === "data_estimate"')
        ),
        mainPanel(
            tabsetPanel(
                id = 'dataset',
                tabPanel("Storm tracks for Atlantic basin storms data table",
                
                # Create a new Row in the UI for selectInputs
                fluidRow(
                    column(4,
                           selectInput("storm",
                                       "Storm ID:",
                                       c("All",
                                         unique(as.character(data_ht$storm_id))))
                    ),
                    column(4,
                           selectInput("year",
                                       "Year:",
                                       c("All",
                                         unique(data_ht$year)))
                    )
                ),
                # Create a new row for the table.
                DT::dataTableOutput("table1")),
                
                tabPanel("Rainfall for US counties during Atlantic basin tropical storms data table",
                
                # Create a new Row in the UI for selectInputs
                fluidRow(
                    column(4,
                           selectInput("storm_1",
                                       "Storm ID:",
                                       c("All",
                                         unique(as.character(data_rain$storm_id))))
                    ),
                    column(4,
                           selectInput("fips",
                                       "Fips:",
                                       c("All",
                                         unique(data_rain$fips)))
                    )
                ),
                # Create a new row for the table.
                DT::dataTableOutput("table2")),
                
                tabPanel("Modeled county wind speeds for Atlantic-basin storms data table",
                
                # Create a new Row in the UI for selectInputs
                fluidRow(
                    column(4,
                           selectInput("storm_2",
                                      "Storm ID:",
                                      c("All",
                                        unique(as.character(data_winds$storm_id))))
                    ),
                    column(4,
                           selectInput("fips_1",
                                       "Fips:",
                                       c("All",
                                         unique(data_winds$fips)))
                           )
                         ),
                # Create a new row for the table.
                DT::dataTableOutput("table3")),
                
                tabPanel("Estimated county wind speeds for Atlantic-basin storms data table",
                # Create a new Row in the UI for selectInputs
                fluidRow(
                    column(4,
                           selectInput("storm_3",
                                       "Storm ID:",
                                       c("All",
                                         unique(as.character(data_estimate$storm_id))))
                           ),
                    column(4,
                           selectInput("fips_2",
                                       "Fips:",
                                       c("All",
                                         unique(data_estimate$fips)))
                           )
                ),
                # Create a new row for the table.
                DT::dataTableOutput("table4"))
            )
        )
    )
)


server <- function(input, output) {
    
    # Filter data based on selections
    output$table1 <- DT::renderDataTable(DT::datatable({
        data <- data_ht
        if (input$storm != "All") {
            data <- data[data$storm_id == input$storm,]
        }
        if (input$year != "All") {
            data <- data[data$year == input$year,]
        }
        
        data
    }))
    
    # sorted columns are colored now because CSS are attached to them
    # Filter data based on selections
    output$table2 <- DT::renderDataTable(DT::datatable({
        data2 <- data_rain
        if (input$storm_1 != "All") {
            data2 <- data2[data_rain$storm_id == input$storm_1,]
        }
        if (input$fips != "All") {
            data2 <- data2[data_rain$fips == input$fips,]
        }
        
        data2
    }))
    
    output$table3 <- DT::renderDataTable(DT::datatable({
        data3 <- data_winds
        if (input$storm_2 != "All") {
            data3 <- data3[data_winds$storm_id == input$storm_2,]
        }
        if (input$fips_1 != "All") {
            data3 <- data3[data_winds$fips == input$fips_1,]
        }
        
        data3
    }))
    
    output$table4 <- DT::renderDataTable(DT::datatable({
        data4 <- data_estimate
        if (input$storm_3 != "All") {
            data4 <- data4[data_estimate$storm_id == input$storm_3,]
        }
        if (input$fips_2 != "All") {
            data4 <- data4[data_estimate$fips == input$fips_2,]
        }
        
        data4
    }))
}

# Run the application 
shinyApp(ui = ui, server = server)
