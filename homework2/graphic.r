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


# small multiples
#movies$quart=cut(movies$budget,quantile(movies$budget), labels=c("1st","2nd","3rd","4th"))
movies$mpaa = factor(movies$mpaa,levels=levels(movies$mpaa),labels=c("Not Rated","NC-17","PG","PG-13","R"))
#names(movies)[names(movies)=="mpaa"] = "MPAA rating"
mdlabels=floor((movies$year-1900)/10)*10 + 1900
movies$decade = factor(mdlabels,labels=paste(names(table(mdlabels)),"'s",sep=""))
genreLevels=c("Comedy", "Mixed")
moviesToPlot=subset(movies, genre %in% genreLevels)
p = ggplot(moviesToPlot,aes(budget,rating, color=mpaa)) + 
   geom_point(shape=3, alpha=1, size=4) +
   ggtitle("Quality of Movies vs Budget, by Decade and Subject Maturity") +
   labs(x="budget, in dollars", y="quality rating",color="maturity rating") +
   facet_wrap(~ decade, drop=FALSE)  +
   scale_x_log10()+
   scale_y_log10(breaks=c(1,3,5,7,10)) +
   scale_color_manual(values=c("#F8766D","#A3A500","#00BF7D","#00B0F6","#E76BF3"))+
   scale_color_brewer(palette="Set2") +
   coord_fixed (ratio=6.5) +
   theme (legend.position=c(1,0), legend.justification=c(1,0))
print(p)
