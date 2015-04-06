## Usage example
## > Rscript interrater.r

library(irr)

Sentinel <- read.csv(file="data/Rainfall- combined - Sentinel2.csv",head=TRUE,sep=",")
Negs <- read.csv(file="data/Rainfall- combined - Negs2.csv",head=TRUE,sep=",")
Sum <- read.csv(file="data/Rainfall- combined - Sum2.csv",head=TRUE,sep=",")
Count <- read.csv(file="data/Rainfall- combined - Count2.csv",head=TRUE,sep=",")
Divzero <- read.csv(file="data/Rainfall- combined - Divzero2.csv",head=TRUE,sep=",")
Avg <- read.csv(file="data/Rainfall- combined - Avg2.csv",head=TRUE,sep=",")
Grade <- read.csv(file="data/Rainfall- combined - Grade2.csv",head=TRUE,sep=",")


source("analysis.r")
