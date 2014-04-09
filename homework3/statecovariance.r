# Load required packages
require(GGally)

# Load datasets
#data(state.x77)

D = state.x77
colnames(D) = gsub(" ","",colnames(state.x77))
D = data.frame(D)
D$age=cut(D[,"LifeExp"],quantile(D[,"LifeExp"]),c("Brief","Low","Short","Long"),include.lowest=T)


# Create scatterplot matrix
p <- ggpairs(D, 
    # Columns to include in the matrix
    columns = sapply(c("LifeExp","Income","Illiteracy","Murder","HSGrad","Frost"),function(name){which(name==colnames(D))}),

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
    title = "correlation matrix for life expectancy",
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
	p
}

# Show the plot
print(p)

