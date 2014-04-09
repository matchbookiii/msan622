library(shiny)
shinyUI(fluidPage(

  titlePanel("Life Expectancy"),

  sidebarLayout(

    sidebarPanel(

    width=2
    ,checkboxGroupInput(
                inputId="life",
                label="",
                choices=c("Short","Below Average","Above Average","Long"),
                selected=c("Short","Below Average","Above Average","Long")
            )
    ),

    mainPanel(
      tabsetPanel(
        tabPanel("Covariance", plotOutput("covariance", height=800)), 
        tabPanel("MultiLine", plotOutput("multiline", height=800)), 
        tabPanel("Heat", plotOutput("heat",height=800))
				 
				 
      )
    )
  )
))

