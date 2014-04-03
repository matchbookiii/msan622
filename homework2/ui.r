
library (shiny)

shinyUI(fluidPage(

  # Application title
  headerPanel("Hello Movies!")

  # Sidebar with a slider input for number of observations
  ,sidebarPanel(
    width=2

    ,checkboxGroupInput(
                inputId="genre",
                label="Genre",
                choices=c("Action", "Animation", "Comedy", "Documentary", "Drama", "Mixed", "None", "Romance", "Short"),
                selected=c("Action", "Animation", "Comedy", "Documentary", "Drama", "Mixed", "None", "Romance", "Short")
            )
    ,br()
    ,sliderInput("size", 
                "Size", 
                min = 1,
                max = 10, 
				step=1,
                value = 3)
    ,br()
    ,sliderInput("alpha", 
                "Alpha", 
                min = 0.1,
                max = 1, 
				step=0.1,
                value = 1)
     ,br()
     ,selectInput(inputId="pallette", "Color Pallette", 
				  choices=c("Default", "Accent", "Set1", "Set2", "Set3", "Dark2", "Pastel1", "Pastel2"), 
				  selected = "Default", multiple = FALSE, selectize = TRUE)


  )
  # Show a plot of the generated distribution
  ,mainPanel(
	#width=50,
	#height=50,
    plotOutput("plot"
			   , height="700px"
			)
  )
))

