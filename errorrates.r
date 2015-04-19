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
Uni1$uni="University 1"
Uni2$uni="University 2"
Uni3$uni="University 3"
All = rbind(Uni1,Uni2,Uni3)

# plans as categorical variables
cats= c("tinel", "negs", "sum", "count", "divzero", "average")

# the same plans as points (x=0, ok=3, all other=1)
points= c("t", "n", "s", "c", "d", "a")

printErrorRates = function(All) { 
  U1_agg <- allOk(subset(All, uni=="University 1")) 
  U2_agg <- allOk(subset(All, uni=="University 2")) 
  U3_agg <- allOk(subset(All, uni=="University 3"))
  All_agg <- allOk(All)

  ##########################################################################################################
  print("How many plans are correct - rowname is the number of plans without problems")
  print("University 1")
  print(U1_agg)
  print("University 2")
  print(U2_agg)
  print("University 3")
  print(U3_agg)
  print("Universities 1, 2 and 3")
  print(All_agg)

  ##########################################################################################################
  print("Average points and stds ****************")
  print("University 1")
  print(c(mean(Uni1$score),sd(Uni1$score)))
  print("University 2")
  print(c(mean(Uni2$score),sd(Uni2$score)))
  print("University 3")
  print(c(mean(Uni3$score),sd(Uni3$score)))
  print("Universities 1, 2 and 3")
  print(c(mean(All$score),sd(All$score)))
}


print("======================================================")
print("Error rates for the original assignment")
print("======================================================")
printErrorRates(All)

print("======================================================")
print("Error rates when ignoring all xgp in divzero and all errors in negs")
print("======================================================")
All2=All
All2[All2$divzero=="xgp","divzero"]="ok"
All2[All2$divzero=="xgp","d"]=3
All2$n=3

print("======================================================")
print("Error rates when ignoring all sentinel problems")
print("======================================================")
All3=All
All3$tinel="ok"
All3$t=3
printErrorRates(All3)

