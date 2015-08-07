## Usage example
## > Rscript ploterrorrates.r
## 
## Creates two files: 

FILE1 = "errorrates_variant1.svg"
FILE2 = "errorrates_variant2.svg"

library(ggplot2)
library(RSvgDevice)

## calculated how many students have 1, 2, ... 6 plans correct. counts and percentages
allOk <- function(Uni) {
   counts <- cbind( count=table(apply(Uni, 1, function(x) length(x[x=='ok']))))
   c <- as.data.frame(counts)
   items <- sum(c$count)
   c$percent <- c$count/items
   return(c) 
}

# Read the data
Uni1 <- read.csv(file="data/Uni1.csv",head=TRUE,sep=",")
Uni2 <- read.csv(file="data/Uni2.csv",head=TRUE,sep=",")
Uni3 <- read.csv(file="data/Uni3.csv",head=TRUE,sep=",")


Uni1 <- cbind(Uni1,apply(Uni1, 1, function(x) length(x[x=='ok'])))
Uni2 <- cbind(Uni2,apply(Uni2, 1, function(x) length(x[x=='ok'])))
Uni3 <- cbind(Uni3,apply(Uni3, 1, function(x) length(x[x=='ok'])))

colnames(Uni1)[14] = 'okcount'
colnames(Uni2)[14] = 'okcount'
colnames(Uni3)[14] = 'okcount'

Uni1$uni="University 1"
Uni2$uni="University 2"
Uni3$uni="University 3"

All = rbind(Uni1,Uni2,Uni3)

# plans as categorical variables
cats= c("tinel", "negs", "sum", "count", "divzero", "average")

# the same plans as points (x=0, ok=3, all other=1)
points= c("t", "n", "s", "c", "d", "a")

plotErrorRates = function(All, filename, xtitle, ytitle) { 
  U1_agg <- allOk(subset(All, uni=="University 1"))
  U1_agg$percent =  round(U1_agg$percent,5) 
  U1_agg = U1_agg[rev(order(row.names(U1_agg))),]
  U1_agg$cumpercent = cumsum(U1_agg$percent) 
  U2_agg <- allOk(subset(All, uni=="University 2"))
  U2_agg$percent =  round(U2_agg$percent,5)   
  U2_agg = U2_agg[rev(order(row.names(U2_agg))),]
  U2_agg$cumpercent = cumsum(U2_agg$percent)  
  U3_agg <- allOk(subset(All, uni=="University 3"))
  U3_agg$percent =  round(U3_agg$percent,5)
  U3_agg = U3_agg[rev(order(row.names(U3_agg))),]   
  U3_agg$cumpercent = cumsum(U3_agg$percent) 
  All_agg <- allOk(All)
  All_agg$percent =  round(All_agg$percent,5)  
  All_agg = All_agg[rev(order(row.names(All_agg))),]   
  All_agg$cumpercent = cumsum(All_agg$percent) 

  ## TODO: onko -6 oikein, pitäisikö toisessa variantissa olla -5 XXX XXX
  All_agg$errors = abs(as.numeric(rownames(All_agg))-6)
  U1_agg$errors = abs(as.numeric(rownames(U1_agg))-6)
  U2_agg$errors = abs(as.numeric(rownames(U2_agg))-6)
  U3_agg$errors = abs(as.numeric(rownames(U3_agg))-6)
  All_agg$group="combined"
  U1_agg$group="Context 1"
  U2_agg$group="Context 2"
  U3_agg$group="Context 3"
  
  grouped = rbind(U1_agg, U2_agg, U3_agg)
  grouped$p = round(grouped$percent*100,0)

  #pdf(filename)

  #devSVG(file = filename, width = 5, height = 7,
  #bg = "white", fg = "black", onefile=TRUE, xmlHeader=TRUE)
  ggplot(data=grouped, aes(x=errors, y=p)) + 
         geom_bar(stat="identity", position=position_dodge()) + ylab(ytitle) + xlab(xtitle) + scale_fill_grey() + 
         theme_bw(base_size=24) +
         #theme_minimal(base_size=24) +
         ylim(0,100) + scale_x_continuous(breaks=0:6) +
         facet_wrap(~group, nrow=1)
  
}

         #scale_y_continuous(labels=percent)  

print("======================================================")
print("Error rates for the original assignment")
print("======================================================")
print(paste("Creating file", FILE1))
plotErrorRates(All, FILE1, "# of incorrect or missing plans", "Percentage of students")

print("======================================================")
print("Error rates when ignoring all xgp in divzero and all errors in negs")
print("======================================================")
All2=All
All2[All2$divzero=="xgp","divzero"]="ok"
All2[All2$divzero=="xgp","d"]=3
All2$negs="ok"
All2$n=3
print(paste("Creating file", FILE2))
plotErrorRates(All2, FILE2, "# of incorrect or missing plans (no Negative)", "")



