## First, looking all categories independently

print("**** Light interrater reliabilities ******")
print("Sentinel **********************************")
kappam.light(Sentinel)
print("Negs **************************************")
kappam.light(Negs)
print("Sum ***************************************")
print("irr library fails to calculate this, perferct agreement")
#kappam.light(Sum)
print("Count *************************************")
kappam.light(Count)
print("Divzero ***********************************")
kappam.light(Divzero)
print("Avg ***************************************")
print("irr library fails to calculate this, perferct agreement")
#kappam.light(Avg)

## Then, combine plans together - each combination is one category
combined <- cbind(Sentinel,Negs,Sum,Count,Divzero,Avg)

combined$rater1 <- do.call(paste, as.list(combined[,c(1,4,7,10,13,16)])) 
combined$rater2 <- do.call(paste, as.list(combined[,c(2,5,8,11,14,17)])) 
combined$rater3 <- do.call(paste, as.list(combined[,c(3,6,9,12,15,18)]))

print("")
print("***************************************")
print("combination of the plans as one observation - light")

print(kappam.light(combined[,c('rater1','rater2','rater3')]))
print("combination of the plans as one observation - iota")
print(iota(list(Sentinel, Negs, Sum, Count, Divzero, Avg)))


### icc for the grade, arguments
## 't' two way as graders are not random
## 'a' agreement means that we would like to seek whether grades are the same, i.e. even consistent bias is not allowed
## 's' Estimating the reliability of single measure - vs. 'a' that would estimate the reliability of the average of the graders
print("")
print("***************************************")
print("ICC for the grade")
print(icc(Grade,'t','a','s'))

Grade$A <- Grade$A>17
Grade$E <- Grade$E>17
Grade$J <- Grade$J>17
print("")
print("***************************************")
print("All plans ok or not?")
#kappam.light(Grade)
print(icc(Grade,'t','a','s'))