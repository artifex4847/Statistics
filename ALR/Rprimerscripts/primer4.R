###################################################
### chunk number 1: 
###################################################
library(alr3)
options(width=70,show.signif.stars=FALSE,digits=4)
.Sweave.cex=1
data(sleep1)
data(transact)


###################################################
### chunk number 2:  eval=FALSE
###################################################
## data <- read.table("mydata.txt", header=TRUE, na.strings=".")


###################################################
### chunk number 3: 
###################################################
a <- 1:5            # set a to be the vector (1,2,3,4,5)
is.na(a) <- c(1,5)  # set elements 1 and 5 of a to NA
a                   # print a
is.na(a)            # for each element of a is a[j] = NA?


###################################################
### chunk number 4: 
###################################################
complete.cases(sleep1)


###################################################
### chunk number 5: 
###################################################
m1 <- lm(log(SWS) ~ log(BodyWt) + log(Life) + log(GP), 
         data=sleep1, na.action=na.omit)


###################################################
### chunk number 6: 
###################################################
m2 <- lm(log(SWS) ~ log(BodyWt) + log(GP), 
         data=sleep1, na.action=na.omit)


###################################################
### chunk number 7: 
###################################################
m3 <- lm(log(SWS) ~ log(BodyWt) + log(Life) + log(GP), data=sleep1,
         subset = complete.cases(sleep1))


###################################################
### chunk number 8:  eval=FALSE
###################################################
## m1 <- lm(Time~ T1 + T2, data=transact)
## betahat.boot <- bootCase(m1,B=999)


###################################################
### chunk number 9:  eval=FALSE
###################################################
## # bootstrap standard errors
## apply(betahat.boot,2,sd)
## # bootstrap 95% confidence intervals
## cl <- function(x) quantile(x,c(.025,.975))
## apply(betahat.boot,2,cl)
## coef(m1)


###################################################
### chunk number 10:  eval=FALSE
###################################################
## catchSim <- function(B=999){
##   ans <- NULL
##   for (i in 1:B) {
##     X <- npdata$Density + npdata$SEdens * rnorm(16)
##     Y <- npdata$CPUE + npdata$SECPUE * rnorm(16)
##     m0 <- lm(Y ~ X - 1)
##     ans <- c(ans, coef(m0))}
##   ans}


