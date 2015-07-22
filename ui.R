# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

# Fix tag("div", list(...)) : could not find function "showOut… 
library(rCharts)

#require(rCharts)

shinyUI(
  # Give the page a title
  navbarPage("Australian Population",
             
             tabPanel(  "Stats",
                      sidebarPanel(
                        sliderInput("range", 
                                    "Range:", 
                                    min = 1981, 
                                    max = 2014, 
                                    step = 1,
                                    value = c(1981, 2014))
                      ),
                      
                      mainPanel(
                        
                        tabsetPanel(
                          
                          # Overall
                          tabPanel( "Overall", 
                                    h3('Australian Population', align = "left"), 
                                    h6('( in Millions )', align = "left"),
                                    plotOutput("AussiePopulation") ),
                          
 #                         # Male / Female series data
                         tabPanel("By Sex", 
                                  h3('Australian Population By Sex', align = "left"), 
                                  h6('( in Millions )', align = "left"), 
                               showOutput("PopulationBySex","nvd3")   ),
                          
                          # another
                        tabPanel("By State", 
                                 h3('Australian Population By State', align = "left"), 
                                 h6('( in Millions )', align = "left"),
                                 showOutput("PopulationByState","nvd3") )

                        ) #  End of tabsePanel
                        )  #  End of MainPanel
),    # end of tabPanel "Stats

                          tabPanel("About",
                                mainPanel( includeMarkdown("about.Rmd"))
         
                          )  # end of tabPanel "About"
)  # end of navbarPage
)  # end of shinyUI
