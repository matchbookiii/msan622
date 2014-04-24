require(reshape2) # melt
require(ggplot2)

df = data.frame()
mkdata = function() {

data(Seatbelts)

d=data.frame(Seatbelts)
d$time=as.numeric(time(Seatbelts))
d$month <- factor(
    month.abb[cycle(time(Seatbelts))],
    levels = month.abb,
    ordered = TRUE
)
d$year <- factor(floor(time(Seatbelts)),ordered=TRUE)
d$driver=with(d,1000*drivers/kms)
d$"frontpassenger"=with(d,1000*front/kms)
d$"rearpassenger"=with(d,1000*rear/kms)
d$total = with(d,(drivers+rear+front)*1000/kms)
d$killed = with(d,DriversKilled*1000/kms)
d$VanKilled = with(d,VanKilled*1000/kms)
df <<- d
molten <<- melt(
    d,
    id = c("year", "month", "time")
)
#molten$variable = factor(molten$variable,levels=

#c("DriversKilled","drivers","front","rear",
#"kms","PetrolPrice","VanKilled","law",
#"total","driver","frontpassenger","rearpassenger", "killed"
#), 
#labels=
#c("DriversKilled","drivers","front","rear",
#"distance travelled","price of petrol","VanKilled","law",
#"any","driver","front passenger","rear passenger", "killed"
#))
						 
#molten <<- molten
d
}

pal=scale_color_hue()
pal=pal$palette

serious=function() {
p = ggplot(df,aes(time))
#p = p + geom_point(aes(y=total,color="any"),alpha=0.4)
p = p + geom_line(aes(y=total,color="any"),alpha=0.4)
p = p + geom_smooth(aes(y=total,color="any"),alpha=1,size=0.70,se=F)

#p = p + geom_point(aes(y=driver,color="driver"),alpha=0.4)
p = p + geom_line(aes(y=driver,color="driver"),alpha=0.4)
p = p + geom_smooth(aes(y=driver,color="driver"),alpha=1,size=0.70,se=F)

#p = p + geom_point(aes(y=frontpassenger,color="front passenger"),alpha=0.4)
p = p + geom_line(aes(y=frontpassenger,color="front passenger"),alpha=0.4)
p = p + geom_smooth(aes(y=frontpassenger,color="front passenger"),size=0.70,se=F)

#p = p + geom_point(aes(y=rearpassenger,color="rear passenger"),alpha=0.4)
p = p + geom_line(aes(y=rearpassenger,color="rear passenger"),alpha=0.4)
p = p + geom_smooth(aes(y=rearpassenger,color="rear passenger"),size=0.70,alpha=1,se=F)

p = p + scale_color_manual(name="position in car",breaks=c("any","driver","front passenger","rear passenger"), values=pal(4))

p = p + labs(x=NULL,y="per 1000 km travelled",title="Serious Car Injuries in England, 1969-1984")

p = p + theme(
            #legend.direction = "horizontal",
            legend.position = c(1, 1),
            legend.justification = c(1, 1),
            #legend.title = element_blank(),
            legend.background = element_blank(),
            legend.key = element_blank()
        )

print(p)
}

serious2=function() {
p = ggplot(subset(molten,time>1979&variable %in% c("total","driver","frontpassenger","rearpassenger")),
    aes(
        x = month, 
        y = value, 
        group = year, 
        color = variable
    ))
p <- p  + geom_line(size=1)
p <- p  + scale_x_discrete(labels=NULL)
p <- p + facet_grid(variable ~ year, scales="free_y")
p <- p + labs(x=NULL, y="injuries per 1000km travelled",title="Serious Car Injuries in England, 1979-1984")
#p <- p + scale_colour_brewer(palette = "Set1")
 #p <- p + facet_wrap(~ year, ncol = 6)
 p <- p + theme(legend.position="none")
p = p + theme(axis.ticks.x=element_blank())
print(p)
}

petrol = function() {
p = ggplot(subset(molten,variable %in% c("PetrolPrice","kms")),
    aes(
        x = month, 
        y = value, 
        group = year, 
        color = variable
    ))
p <- p  + geom_line(size=1)
p <- p  + scale_x_discrete(labels=NULL)
p <- p + facet_grid(variable ~ year, scales="free_y")
p <- p + labs(x=NULL, y=NULL,title="Petrol Prices vs. Distance Driven, 1969-1984")
#p <- p + scale_colour_brewer(palette = "Set1")
 #p <- p + facet_wrap(~ year, ncol = 6)
 p <- p + theme(legend.position="none")
p = p + theme(axis.ticks.x=element_blank())
print(p)
}

hw5 = function() {
  mkdata()
  serious()
  X11()
  serious2()
  X11()
  petrol()
}

hw5()

