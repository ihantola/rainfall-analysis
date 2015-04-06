## Usage example
## > Rscript interrater.r

library(irr)

Sentinel <- read.csv(file="data/Rainfall- combined - Sentinel.csv",head=TRUE,sep=",")
Negs <- read.csv(file="data/Rainfall- combined - Negs.csv",head=TRUE,sep=",")
Sum <- read.csv(file="data/Rainfall- combined - Sum.csv",head=TRUE,sep=",")
Count <- read.csv(file="data/Rainfall- combined - Count.csv",head=TRUE,sep=",")
Divzero <- read.csv(file="data/Rainfall- combined - Divzero.csv",head=TRUE,sep=",")
Avg <- read.csv(file="data/Rainfall- combined - Avg.csv",head=TRUE,sep=",")
Grade <- read.csv(file="data/Rainfall- combined - Grade.csv",head=TRUE,sep=",")


source("analysis.r")
