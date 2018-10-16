#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(tidyverse)
states <- unique(Pollution_test$State)
cities <- unique(Pollution_test[Pollution_test$State==states[1], "City"])
# Define UI for application that draws a histogram
shinyUI(
   fluidPage(
     tabsetPanel(
       tabPanel("Pollution Calandar",
                titlePanel("Pollution in the USA"),
                sidebarLayout(
                  sidebarPanel(
                    fluidRow( 
                      column(4,
                             selectizeInput(inputId="State",label="State",
                                            choices=states, 
                                            selected = states[1])),
                      column(4,
                             selectizeInput(inputId="City",label="City",
                                            choices=cities)),
                      column(4,selectizeInput(inputId="Chemical",label="Chemical",
                                              choices=c("NO2.AQI","SO2.AQI","O3.AQI","CO.AQI"))),
                      column(8,dateRangeInput(inputId="Date_range", label = h3("Date range"),start='2000-01-01',end='2010-12-31')))
                    ),
                    
                  mainPanel(
                    fluidRow(
                      column(2,htmlOutput("AirQuality")))
                    )
       )),
       tabPanel("BoxPlots",
                sidebarLayout(
                  sidebarPanel(
                    fluidRow( 
                      column(4,
                             selectizeInput(inputId="state",label="State",
                                            choices=states, 
                                            selected = states[1])),
                      column(4,
                             selectizeInput(inputId="city",label="City",
                                            choices=cities)),
                      
                      column(6,selectizeInput(inputId="chemical",label="Chemical",
                                              choices=c("median_NO2","median_SO2","median_O3","median_CO"))),
                      column(8,dateRangeInput(inputId="date_range", label = h3("Date range"),start='2000-01-01',end='2010-12-31')))),
                    mainPanel(
                      fluidRow(       
                      column(12, plotOutput("Boxplot_chemical"))
                      
                    ),
                    
                    fluidRow(column(12,plotOutput("top_citiesBC"))),
                    fluidRow(column(12,plotOutput("Bottom_citiesBC")))
                    
                  )))
       
     )))
  # # Application title
  # titlePanel("Pollution in the USA"),
  # sidebarLayout(
  #    sidebarPanel(
  #           fluidRow( 
  #                 column(4,
  #                       selectizeInput(inputId="State",label="State",
  #                         choices=states, 
  #                         selected = states[1])),
  #                 column(4,
  #                       selectizeInput(inputId="City",label="City",
  #                         choices=cities)),
  #                 column(4,selectizeInput(inputId="Chemical",label="Chemical",
  #                         choices=c("NO2.AQI","SO2.AQI","O3.AQI","CO.AQI"))),
  #                 column(8,dateRangeInput(inputId="Date_range", label = h3("Date range"),start='2000-01-01',end='2010-12-31'))),
  #              fluidRow(       
  #               column(12, plotOutput("Boxplot_chemical"))
  #             
  #           ),
  #       
  #             fluidRow(column(12,plotOutput("top_citiesBC")))
  #           
  #    ),
  #           
  #       
  #   
  #     mainPanel(
  #    
  #    fluidRow(
  #     column(2,htmlOutput("AirQuality"))
  #     
  #     )
  #   
  #            
  #  
  #     )
  #   
  # )
  
  #)
#)

  
      
     
       

    
    
    
         
   
    
    
    
 
  

  


  


