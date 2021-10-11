library(LinkageMapView)
a <- read.csv("linkage.csv")#输入文件
maxpos <- floor(max(a$Position[a$Group == "LG01" | a$Group == "LG02" | a$Group == "LG03" | a$Group == "LG04" | a$Group == "LG05" | a$Group == "LG06" | a$Group == "LG07" | a$Group == "LG08" | a$Group == "LG09" | a$Group == "LG10"]))
#LG系列是用户输入参数
at.axis <- seq(0, maxpos)
axlab <- vector()
for (lab in 0:maxpos) {
      if (!lab %% 10) {
    #10 是用户输入参数
            axlab <- c(axlab, lab)
    }
    else {
        axlab <- c(axlab, NA)
    }
}
outfile = file.path("")#输出路径及文件名
lmv.linkage.plot(a,outfile,mapthese=c("LG01","LG02","LG03","LG04","LG05","LG06","LG07","LG08","LG09","LG10"),denmap=TRUE, cex.axis = 1, at.axis = at.axis, labels.axis = axlab)
#LG系列是用户输入参数