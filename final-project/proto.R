library(ggplot2)
library(Hmisc)
library(reshape2)

raw1 = function() {
f=read.csv(file="pChart.csv")
indexes=order(f$distance,decreasing=F)
distances=f$distance[indexes]
labels=as.character(distances[seq(1,nrow(f),3)])
f$rider=factor(f$rider, levels=(f$rider[indexes]))

p = ggplot(f, aes(x=service.time,y=rider))
#p = p + geom_hline(yintercept=0)
p = p + geom_point(aes(color=alg))
#p = p + stat_summary(aes(color=alg),fun.data=mean_cl_normal,geom="pointrange",se=F)
#p = p + facet_grid(rider~.,margins=T)
p = p + labs(title="Raw Trials",x="service time (relative units)", y="length of trip (blocks)", color="algorithm")
p = p + scale_y_discrete(labels=labels) 
print(p)
}

raw2=function() {
f=read.csv(file="pChart.csv")
p = ggplot(f, aes(x=service.time,y=distance))
#p = p + geom_hline(yintercept=0)
p = p + geom_point(aes(color=alg))
#p = p + stat_summary(aes(color=alg),fun.data=mean_cl_normal,geom="pointrange",se=F)
#p = p + facet_grid(rider~.,margins=T)
p = p + labs(title="Raw Trials",x="service time (relative units)", y="length of trip (blocks)", color="algorithm")
p = p + scale_y_continuous(breaks=2:9,labels=c("2","3","4","5","6","7","8","9"))
print(p)
}


over=function() {
f=read.csv(file="pChartBig.csv")
p = ggplot(f, aes(y=service.time,x=distance, color=alg))
#p = p + geom_hline(yintercept=0)
#p = p + geom_point(aes(color=alg))
p = p + stat_summary(fun.data=mean_cl_normal,geom="errorbar",position="dodge")
#p = p + facet_grid(rider~.,margins=T)
p = p + labs(title="Average Service Time By Length of Trip",y="service time (relative units)", x="length of trip (blocks)", color="algorithm")
#p = p + xlim(c(2,9))
p = p + scale_x_continuous(breaks=2:9,labels=c("2","3","4","5","6","7","8","9"))
p = p+ coord_flip()
#p= p + ylim(c(8,20))
print(p)
}



gross=function(){
f=read.csv(file="gross.csv")
mf <- melt(
    f,
    id = c("alg"),
	measure=c("mean.service.time","total.run.time","total.bus.distance")
	)
p=ggplot(f,aes(x=mean.service.time))
p = p + geom_histogram(aes(y=..density..))
p = p+ facet_grid(alg~.,scales="free")
print(p)
}


pmult=function(){

f=read.csv("busfix.csv")
pf=read.csv("pfix.csv")
pf$bus=factor(pf$bus)
f$bus=factor(f$bus)
pal=scale_color_hue()
pal=pal$palette(5)

doIt = function(alg) {
   rects=f[f$time<=26 & f$alg==alg,]
   peeps=pf[pf$time<=26 & pf$alg==alg,]

   p=ggplot(rects)
   p = p+geom_rect(aes(xmin=location-0.50,xmax=location+0.50,ymin=direction-.43,ymax=direction+.43,fill=bus))
   p = p + coord_fixed()
   if (nrow(peeps)>0) {
      p = p + geom_point(data=peeps,aes(x=location,y=direction,color=bus),size=1,alpha=0.4)
      p = p + scale_color_manual(values=pal[which(table(peeps$bus)> 0)])
   }
   p = p + theme(legend.position="none")
   p = p + facet_grid(time~bus)
   p = p + labs(title=alg,x=NULL,y=NULL)
   p = p + theme(axis.ticks=element_blank())
   p = p  + scale_y_continuous(labels=NULL)
   p = p  + scale_x_continuous(labels=NULL)
   p
}


X11()
print(doIt("elevator"))
X11()
print(doIt("rope"))
X11()
print(doIt("chain"))
}



tryMovie= function() {
f=read.csv("busfix.csv")
pf=read.csv("pfix.csv")
f$bus=factor(f$bus)
pf$bus=factor(pf$bus)
now=1
pal=scale_color_hue()
pal=pal$palette(5)
rects=f[f$time==now & f$alg=="chain",]
peeps=pf[pf$time==now & pf$alg=="chain",]
p=ggplot(palette=pal)
p = p + coord_fixed()
p = p+geom_path(data=data.frame(x=c(1,1,10,10,1),y=c(-1,1,1,-1,-1)),aes(x=x,y=y),color="white")
p = p + theme(axis.ticks.y=element_blank())
p = p + theme(axis.ticks.x=element_blank())
p = p + theme(panel.grid.minor=element_blank())
p = p + theme(panel.grid.major=element_blank())
p = p  + scale_y_continuous(labels=NULL, breaks=c(-1,1), limits=c(-1.5,1.5))
p = p  + scale_x_continuous(labels=NULL,breaks=c(1,10),limits=c(0.5,10.5))
p = p + theme(legend.position="none")
p = p + labs(y=NULL,x=NULL)

if (nrow(peeps)>0) {
   p = p + geom_point(data=peeps,aes(x=location,y=direction,color=bus),alpha=0.4,size=3,position="jitter")
   p = p + scale_color_manual(values=pal[which(table(peeps$bus)> 0)])
}
if (nrow(rects)>0) {
   p = p+geom_rect(data=rects,aes(xmin=location-0.50,xmax=location+0.50,ymin=direction-.43,ymax=direction+.43,fill=bus))
   p = p + scale_fill_manual(values=pal[which(table(rects$bus)> 0)])
}
p
}
