

f=read.csv("busfix.csv")
pf=read.csv("pfix.csv")
f$bus=factor(f$bus)
pf$bus=factor(pf$bus)

doElevator = function(now) {

cat ("in doElevator",now,"\n")
rects=f[f$time==now & f$alg=="elevator",]
peeps=pf[pf$time==now & pf$alg=="elevator",]
p=ggplot()
p = p + coord_fixed()
p = p+geom_path(data=data.frame(x=c(1,1,10,10,1),y=c(-1,1,1,-1,-1)),aes(x=x,y=y),color="white")
p = p + theme(axis.ticks.y=element_blank())
p = p + theme(axis.ticks.x=element_blank())
p = p + theme(panel.grid.minor=element_blank())
p = p + theme(panel.grid.major=element_blank())
p = p  + scale_y_continuous(labels=NULL, breaks=c(-1,1), limits=c(-1.5,1.5))
p = p  + scale_x_continuous(labels=NULL,breaks=c(1,10),limits=c(0.5,10.5))
p = p + theme(legend.position="none")
p = p + labs(y=NULL,x=NULL,title="elevator")

if (nrow(peeps)>0) p = p + geom_point(data=peeps,aes(x=location,y=direction,color=bus),alpha=0.4,size=3,position="jitter")
if (nrow(rects)>0) p = p+geom_rect(data=rects,aes(xmin=location-0.50,xmax=location+0.50,ymin=direction-.43,ymax=direction+.43,fill=bus))
p
}

#shinyServer(function(input, output) {
#cat ("in bus shiny server\n")
    #output$mainPlot <- renderPlot({
        #print(doElevator(input$time))
    #})
    
#})
shinyServer(function(input, output) {
cat("in bus shinyServer\n")
    output$mainPlot <- renderPlot({
        print(plotArea(input$start, input$num))
    })
    
    output$overviewPlot <- renderPlot({
        print(plotOverview(input$start, input$num))
    })
})
