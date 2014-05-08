shinyUI(pageWithSidebar(
    headerPanel("Bus"),
    
    sidebarPanel(
        
        sliderInput(
            inputId="time", 
            label="Time",
            min = 1, 
            max = 100,
            value = 1, 
            step = 1,
            round = TRUE, 
            ticks = TRUE,
            format = "###"#,
            #animate = animationOptions(
             #   interval = 1, 
              #  loop = FALSE
            #)
        ),
        
        width = 3
    ),
    
    mainPanel(
        plotOutput(
            outputId = "mainPlot", 
            width = "100%", 
            height = "400px"
        ),
        
        
        width = 9
    )
))
