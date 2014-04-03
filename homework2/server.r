library (shiny)

library(ggplot2) 
data(movies) 

# movie transformations
movies = subset(movies,budget>0)
genre <- rep(NA, nrow(movies))
count <- rowSums(movies[, 18:24])
genre[which(count > 1)] = "Mixed"
genre[which(count < 1)] = "None"
genre[which(count == 1 & movies$Action == 1)] = "Action"
genre[which(count == 1 & movies$Animation == 1)] = "Animation"
genre[which(count == 1 & movies$Comedy == 1)] = "Comedy"
genre[which(count == 1 & movies$Drama == 1)] = "Drama"
genre[which(count == 1 & movies$Documentary == 1)] = "Documentary"
genre[which(count == 1 & movies$Romance == 1)] = "Romance"
genre[which(count == 1 & movies$Short == 1)] = "Short"

movies = cbind(movies,genre)
movies$mpaa = factor(movies$mpaa,levels=levels(movies$mpaa),labels=c("Not Rated","NC-17","PG","PG-13","R"))
#names(movies)[names(movies)=="mpaa"] = "MPAA rating"
mdlabels=floor((movies$year-1900)/10)*10 + 1900
movies$decade = factor(mdlabels,labels=paste(names(table(mdlabels)),"'s",sep=""))

defaultPallette=function(n){
  hcl(h=seq(15, 375-360/n, length=n)%%360, c=100, l=65) 
}

modifyPlotPallete=function(p,pallette) {
	if (pallette=="Default")   {
      p =  p+scale_color_manual(values=defaultPallette(nlevels(movies$mpaa)))
      return(p)
	}
	else { 
      p =  p+ scale_color_brewer(palette=pallette)
      return(p)
	}
}

mkPlot = function (genreLevels=levels(movies$genre), alpha=1, size=2, pallette=c("Set1"), shape=3) {
    moviesToPlot=subset(movies, genre %in% genreLevels)
    p=   ggplot(moviesToPlot,aes(budget,rating, color=mpaa)) 
    p=p+ geom_point(shape=shape, alpha=alpha, size=size)
    p=p+ ggtitle("Quality of Movies vs Budget, by Decade and Subject Maturity")
    p=p+ labs(x="budget, in dollars", y="quality rating",color="maturity rating")
    p=p+ facet_wrap(~ decade, drop=FALSE)
    p=p+ scale_x_log10()
    p=p+ scale_y_log10(breaks=c(1,3,5,7,10))
    
	p = modifyPlotPallete(p,pallette)

    p=p+ coord_fixed (ratio=6.5)
    p=p+ theme (legend.position=c(1,0), legend.justification=c(1,0))
	p
}
# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
cat("hello\n")
Genre = reactive ({
  cat("genre=",input$genre, class(input$genre),"\n")
  if (length(input$genre) == 0) {
	 levels(movies$genre)
  }
  else {
     input$genre
  }
})
Size = reactive ({
  cat("size=",input$size,"\n")
  input$size
})
Alpha = reactive ({
  cat("alpha=",input$alpha,"\n")
  input$alpha
})
Pallette = reactive ({
  cat("pallette=",input$pallette,class(input$pallette),input$pallette=="Default","\n")
  input$pallette
})

output$plot <- renderPlot({
    print(mkPlot(genreLevels=Genre(), alpha=Alpha(), size=Size(), pallette=Pallette()))
	#hist(rnorm(5))
  }
  #,height=800,width=600)
)
})


