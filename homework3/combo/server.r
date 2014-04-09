library(shiny)
# Load required packages
require(GGally)


library(ggplot2)
library(reshape)
library(plyr)
library(scales)


# This is based on the following example:
# http://learnr.wordpress.com/2010/01/26/ggplot2-quick-heatmap-plotting/

D = state.x77
colnames(D) = gsub(" ","",colnames(state.x77))
D = data.frame(D)

choices = c("LifeExp","Income","Illiteracy","Murder","HSGrad","Frost") 
D = D[choices]

lifeRange=c("Short","Below Average","Above Average","Long")
D[["age"]]=cut(D[,"LifeExp"],quantile(D[,"LifeExp"]),lifeRange,include.lowest=T)

# We need data in a long versus wide format (using melt) and in a
# format that we can sort rows. 
processData <- function(original) {
    # copy original dataset
    processed <- original
    
    # fix column names (replaces period with space)
    #colnames(processed) <- gsub("\\.", "", colnames(processed))
    
    # discard non-numeric data (optional)
    #processed <- processed[sapply(processed, is.numeric)]

    # rescale all the values to [0, 1]
    processed <- rescaler(processed, type = "range")

    # melt dataset (convert from wide to long format)
    processed$id <- 1:nrow(original)
    processed <- melt(processed, "id")

    # convert id column into factor for sorting later
    processed$id <- factor(processed$id,
        levels = 1:nrow(original), 
        ordered = TRUE)

    return(processed)
}

# We will sort the melted dataset by changing the factor levels
# of the ID column. We need the order from the original dataset
# to figure out what the level order should be.
sortMelted <- function(original, melted, sort1, sort2) {
    # get sort order of original dataset
    sortOrder <- order(original[[sort1]], original[[sort2]])

    # sort melted dataframe by modifying factor levels
    melted$id <- factor(melted$id,
        levels = sortOrder, 
        ordered = TRUE)
    return(melted)
}

# This will generate a heatmap with a diversing color scheme and
# a certain middle region that will "fall to the background" by
# being set to white. This will increase the focus on very large 
# and very small values.
getHeatMapOrig <- function(dataset, midrange) {
    # create base heatmap
    p <- ggplot(dataset, aes(x = id, y = variable))
    p <- p + geom_tile(aes(fill = value), colour = "white")
    p <- p + theme_minimal()
    
    # turn y-axis text 90 degrees (optional, saves space)
    p <- p + theme(axis.text.y = element_text(angle = 90, hjust = 0.5))

    # remove axis titles, tick marks, and grid
    p <- p + theme(axis.title = element_blank())
    p <- p + theme(axis.ticks = element_blank())
    p <- p + theme(panel.grid = element_blank())
    
    # remove legend (since data is scaled anyway)
    p <- p + theme(legend.position = "none")

    # remove padding around grey plot area
    p <- p + scale_x_discrete(expand = c(0, 0))
    p <- p + scale_y_discrete(expand = c(0, 0))    
    
    # optionally remove row labels (not useful depending on dataset)
    p <- p + theme(axis.text.x = element_blank())

    # get diverging color scale from colorbrewer
    # #008837 is green, #7b3294 is purple
    palette <- c("#E34A33", "#f7f7f7", "#f7f7f7", "#7b3294")
    
    if(midrange[1] == midrange[2]) {
        # use a 3 color gradient instead
        p <- p + scale_fill_gradient2(low = palette[1], mid = palette[2], high = palette[4], midpoint = midrange[1])
    }
    else {
        # use a 4 color gradient (with a swath of white in the middle)
        p <- p + scale_fill_gradientn(colours = palette, values = c(0, midrange[1], midrange[2], 1))
    }
    
    return(p)
}

getHeatMap=function(lifeToDisplay=lifeRange) {
# melt and process the iris data set and make it available
# globally by the shiny server
cat("heat:",lifeToDisplay,"\n")
myD=subset(D,age %in% lifeToDisplay)
myD=myD[choices]
melted <- processData(myD)

sorted <- sortMelted(myD, melted, 1, 1)
getHeatMapOrig(sorted, c(0.5, 0.5))
}




# Load datasets
#data(state.x77)

getMultiLine = function (lifeToDisplay=lifeRange) {
cat("multi:",lifeToDisplay,"\n")
myD = subset(D,age %in% lifeToDisplay)
myD["LifeExp"]=myD["age"]

# Generate basic parallel coordinate plot
p <- ggparcoord(data = myD, 
                
                # Which columns to use in the plot
                #columns = 1:4, 
                columns = sapply(setdiff(choices, "LifeExp"),function(name){which(name==colnames(D))}),
                
                # Which column to use for coloring data
                #groupColumn = 5, 
                groupColumn = which("LifeExp"==colnames(myD)),
                
                # Allows order of vertical bars to be modified
                #order = "anyClass",
                
                # Do not show points
                showPoints = FALSE,
                
                # Turn on alpha blending for dense plots
                alphaLines = 0.6,
                
                # Turn off box shading range
                shadeBox = NULL,
                
                # Will normalize each column's values to [0, 1]
                scale = "uniminmax" # try "std" also
)

# Start with a basic theme
p <- p + theme_minimal()

# Decrease amount of margin around x, y values
p <- p + scale_y_continuous(expand = c(0.02, 0.02))
p <- p + scale_x_discrete(expand = c(0.02, 0.02))

# Remove axis ticks and labels
p <- p + theme(axis.ticks = element_blank())
p <- p + theme(axis.title = element_blank())
p <- p + theme(axis.text.y = element_blank())

# Clear axis lines
p <- p + theme(panel.grid.minor = element_blank())
p <- p + theme(panel.grid.major.y = element_blank())

# Darken vertical lines
p <- p + theme(panel.grid.major.x = element_line(color = "#bbbbbb"))

# Move label to bottom
p <- p + theme(legend.position = "bottom")

# Figure out y-axis range after GGally scales the data
min_y <- min(p$data$value)
max_y <- max(p$data$value)
pad_y <- (max_y - min_y) * 0.1
p
}

getScatterPlot = function (lifeToDisplay=lifeRange) {
cat("scatter:",lifeToDisplay,"\n")

myD=subset(D,age %in% lifeToDisplay)
# Create scatterplot matrix
p <- ggpairs(myD, 
    # Columns to include in the matrix
    columns = sapply(choices,function(name){which(name==colnames(D))}),

    # What to include above diagonal
    # list(continuous = "points") to mirror
    # "blank" to turn off
    upper = "blank",
    
    # What to include below diagonal
    lower = list(continuous = "smooth"),
    
    # What to include in the diagonal
    diag = list(continuous = "density"),
    
    # How to label inner plots
    # internal, none, show
    axisLabels = "none",
    
    # Other aes() parameters
    colour = "age",
    #title = "correlation matrix for life expectancy",
	legends=F
)
# Remove grid from plots along diagonal
for (i in 1:4) {
    # Get plot out of matrix
    inner = getPlot(p, i, i);
    
    # Add any ggplot2 settings you want
    inner = inner + theme(panel.grid = element_blank()) + theme(legend.position=c(1,1));

    # Put it back into the matrix
    p <- putPlot(p, inner, i, i);
}
	p
}




shinyServer(function(input, output) {

    cat("Press \"ESC\" to exit...\n")

LifeExp = reactive ({
  cat("LifeExp=",input$life, "\n")
  if (length(input$life) == 0) {
	 lifeRange
  }
  else {
     input$life
  }
})
    
    # Can control size if want
    output$covariance <- renderPlot(
	  {
	     print(getScatterPlot(lifeToDisplay=LifeExp()))
	  }, width = 600, height = 800)

    output$multiline <- renderPlot(
      {
	     print(getMultiLine(lifeToDisplay=LifeExp()))
      }, 
      width = 600,
      height = 800)

    output$heat <- renderPlot(
      {
	     print(getHeatMap(lifeToDisplay=LifeExp()))
      }, 
      width = 600,
      height = 800)

})

