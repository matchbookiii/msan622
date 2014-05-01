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
p = p + stat_summary(fun.data=mean_cl_normal,geom="pointrange")
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

