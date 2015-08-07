## Usage example
## > Rscript interrater.r

library(ggplot2)

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

plotErrorRates = function(All, filename) { 
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

  pdf(filename)
  ggplot(data=grouped, aes(x=errors, y=p)) + geom_bar(stat="identity", position=position_dodge()) + ylab("") +  scale_fill_grey() + theme_bw(base_size=24) + facet_wrap(~group, nrow=1)
  dev.off()
}


print("======================================================")
print("Error rates for the original assignment")
print("======================================================")
plotErrorRates(All, "errorrates_variant1.pdf")

print("======================================================")
print("Error rates when ignoring all xgp in divzero and all errors in negs")
print("======================================================")
All2=All
All2[All2$divzero=="xgp","divzero"]="ok"
All2[All2$divzero=="xgp","d"]=3
All2$negs="ok"
All2$n=3
printErrorRates(All2, "errorrates_variant2.pdf")
