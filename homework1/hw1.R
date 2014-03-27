library(ggplot2) 
library(reshape)
data(movies) 
data(EuStockMarkets)

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

# stock market transformations
eu <- transform(data.frame(EuStockMarkets), time = time(EuStockMarkets))


# scatter plot
p = ggplot(movies,aes(budget,rating)) + 
   geom_point(shape=3) +
   ggtitle("Movie Budget vs Ratings, 1906-2005") +
   xlab("budget, in dollars") +
   ylab("rating") +
   scale_x_log10() +
   scale_y_log10(breaks=c(1,2,3,4,5,6,7,8,9,10))

print(p)
ggsave ("hw1-scatter.png")

# bar chartType
movies$genre=factor(movies$genre,names(sort(table(movies$genre))))

p = ggplot(movies,aes(genre)) + 
   geom_bar() +
   ggtitle("The Number of Movies Made, by Genre, 1906-2005") +
   xlab("") +
   ylab("")
print(p)
ggsave("hw1-bar.png")


# small multiples
#movies$quart=cut(movies$budget,quantile(movies$budget), labels=c("1st","2nd","3rd","4th"))
mdlabels=floor((movies$year-1900)/10)*10 + 1900
movies$decade = factor(mdlabels,labels=paste(names(table(mdlabels)),"'s",sep=""))
p = ggplot(movies,aes(budget,rating)) + 
   geom_point(shape=3) +
   ggtitle("Quality of Movies vs Budget, by Decade") +
   xlab("budget, in dollars") +
   ylab("rating") +
   facet_wrap(~ decade) +
   scale_x_log10() +
   scale_y_log10(breaks=c(1,3,5,7,10))

print(p)
ggsave ("hw1-multiples.png")

# multi-line chart
p <- ggplot(eu,aes(time))+
  geom_line(aes(y=DAX,colour="DAX")) +
  geom_line(aes(y=SMI,colour="SMI")) +
  geom_line(aes(y=CAC,colour="CAC")) +
  geom_line(aes(y=FTSE,colour="FTSE")) +
  scale_colour_hue("Exchange")+
  ggtitle("Daily Closes on International Stock Exchanges, 1991-1999") +
  ylab("") +
  xlab("") +
  scale_x_continuous(breaks=c(1991, 1993, 1995, 1997, 1999), limits=c(1991,1999)) 

print(p)
ggsave ("hw1-multiline.png")
