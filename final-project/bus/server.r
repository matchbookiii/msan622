
f=read.csv("busfix.csv")
pf=read.csv("pfix.csv")
f$bus=factor(f$bus)
pf$bus=factor(pf$bus)

ptSize=4
ptAlpha=1
pal=scale_color_hue()
pal=pal$palette(5)

doIt = function(now,alg) {
   rects=f[f$time==round(now) & f$alg==alg,]
   peeps=pf[pf$time==round(now) & pf$alg==alg,]
   #browser()
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
   p = p + labs(y=NULL,x=NULL,title=NULL)
   p = p + scale_fill_manual(values=pal[which(table(rects$bus)> 0)])
   p = p + scale_color_manual(values=pal[which(table(peeps$bus)> 0)])

   if (nrow(peeps)>0) {
      p = p + geom_point(data=peeps,aes(x=location,y=direction,color=bus),alpha=ptAlpha,size=ptSize,position="jitter")
      p = p + scale_color_manual(values=pal[which(table(peeps$bus)> 0)])
   }
   if (nrow(rects)>0) {
      p = p+geom_rect(data=rects,aes(xmin=location-0.50,xmax=location+0.50,ymin=direction-.43,ymax=direction+.43,fill=bus))
      p = p + scale_fill_manual(values=pal[which(table(rects$bus)> 0)])
   }
   p
}

doElevator = function(now) {
  doIt(now,"elevator")
}
doRope = function(now) {
  doIt(now,"rope")
}
doChain = function(now) {
  doIt(now, "chain")
}

shinyServer(function(input, output) {
cat("in bus shinyServer\n")
    output$elPlot <- renderPlot({
        print(doElevator(input$start))
    })
    output$ropePlot <- renderPlot({
        print(doRope(input$start))
    })
    output$chainPlot <- renderPlot({
        print(doChain(input$start))
    })
    
})
