library('ggplot2')
library('reshape')
library('Cairo')
library("grid")
library("scales")

args <- commandArgs(trailingOnly=TRUE)
repeats <- as.integer(args[1])

figure1 <- function(filename, data, plottitle, xlabel, ylabel, plotlabels)
{
  cairo_ps(filename, width=20, height=8)  
  base_size=24
  p<-ggplot(data, aes_string(x=names(data)[1], y=names(data)[3], colour=names(data)[2], shape=names(data)[2], linetype=names(data)[2]), 
	  labeller=label_parsed) + 
	  geom_point(size=5) + 
	  geom_line(size=1.5) + 
	  labs(title=plottitle) + 
	  xlab(xlabel ) + 
	  ylab(ylabel) + 
	  scale_colour_manual(values=c("black", "blue", "red", "green", "purple", "brown", "black", "blue"), name="", labels=plotlabels, guide=guide_legend(keyheight=unit(2, "line"), keywidth=unit(5, "line"), nrow=3, ncol=2)) +
  scale_shape_manual(values=c(19, 18, 17, 16, 15, 14, 14, 15), name="", labels=plotlabels, guide=guide_legend(keyheight=unit(2, "line"), keywidth=unit(5, "line"), nrow=3, ncol=2)) +
  scale_linetype_manual(values=c(19, 18, 17, 16, 15, 14, 19, 18), name="", labels=plotlabels, guide=guide_legend(keyheight=unit(2, "line"), keywidth=unit(5, "line"), nrow=3, ncol=2)) +
	  theme_gray(24) +
      scale_x_continuous(trans = log2_trans(),
      breaks = trans_breaks("log2", function(x) 2^x),
      labels = trans_format("log2", math_format(2^.x)))+
#	  scale_x_continuous(breaks=round(seq(1.0, 10.0, by=0.5), 1)) +
#	  scale_y_continuous(breaks=sort(c(round(seq(0, max(data$value)+1, by=20), 1)))) +
	  theme(legend.position="bottom")
	  
  print(p)
  dev.off()
}

computeMeans <- function(dataTable, r)
{
  dataTmp <- dataTable[seq(1, nrow(dataTable), r),]
  for ( i in 2:r ){
    dataTmp <- dataTmp + dataTable[seq(i, nrow(dataTable), r),]
  }
  dataTable <- dataTmp / r
}

linelabels <- c('Szekvenciális implementáció', 'OpenMP párhuzamosítás 2 szálon', 'OpenMP párhuzamosítás 4 szálon')

data0 <- read.table('./results/ranksort-szekv.txt')
data1 <- read.table('./results/ranksort-par-2.txt')
data2 <- read.table('./results/ranksort-par-4.txt')


data0 <- computeMeans(data0, repeats)
data1 <- computeMeans(data1, repeats)
data2 <- computeMeans(data2, repeats)



d <- data.frame(data0$V1, data0$V2, data1$V2, data2$V2)
colnames(d) <- c('sigma', 'runtime1', 'runtime2', 'runtime3')
dataa <- melt(d, id='sigma', variable_name='series')

figure1("./results/figure-n.eps", dataa, expression(paste("Futásidők a rendezendő minta nagyságának függvényében")), 'n', 'Futási idő (s)', linelabels)

