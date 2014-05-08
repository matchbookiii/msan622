shinyUI(pageWithSidebar(
    headerPanel(""),
    
    sidebarPanel(
        
        sliderInput(
            "start", 
            "Time:",
            min = 1, 
            max = 78,
            value = 1, 
            step = 1,
            round = FALSE, 
            ticks = TRUE,

            animate = animationOptions(
                interval = 800, 
                loop = FALSE
            )
        ),
        
        width = 1
    ),
    
    mainPanel(
	  h1("Elevator"),
        plotOutput(
            outputId = "elPlot", 
            width = "100%", 
            height = "250px"
        ),
	  h1("Rope"),
        plotOutput(
            outputId = "ropePlot", 
            width = "100%", 
            height = "250px"
        ),
	  h1("Chain"),
        plotOutput(
            outputId = "chainPlot", 
            width = "100%", 
            height = "250px"
        ),
        
        
        width = 11
    )
))
