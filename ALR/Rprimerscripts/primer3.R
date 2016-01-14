###################################################
### chunk number 1: 
###################################################
library(alr3)
data(forbes)
data(fuel2001)
options(width=70,show.signif.stars=FALSE,digits=4)
.Sweave.cex=1


###################################################
### chunk number 2: avp1
###################################################
m1 <- lm(log2(Fertility) ~ log2(PPgdp) + Purban, data=UN3)
avPlots(m1, id.n=0)


###################################################
### chunk number 3: 
###################################################
UN3$logFertility <- log2(UN3$Fertility)


###################################################
### chunk number 4: 
###################################################
fuel2001 <- transform(fuel2001, 
             Dlic=1000 * Drivers/Pop,
             Fuel=1000 * FuelC/Pop,
             Income = Income,
             logMiles = log2(Miles))
f <- fuel2001[,c(7, 8, 3, 10, 9)] # new data frame
summary(f)


###################################################
### chunk number 5: 
###################################################
apply(f, 2, sd)


###################################################
### chunk number 6: 
###################################################
round(cor(f),4)


###################################################
### chunk number 7: 
###################################################
cov(f)


###################################################
### chunk number 8: 
###################################################
f$Intercept <- rep(1, 51)  # a column of ones added to f
X <- as.matrix(f[, c(6, 1, 2, 3, 4)]) # reorder and drop fuel
xtx <- t(X) %*% X
xtxinv <- solve(xtx)
xty <- t(X) %*% f$Fuel
print(xtxinv, digits=4)


###################################################
### chunk number 9: 
###################################################
xty <- t(X) %*% f$Fuel
betahat <- xtxinv %*% xty
betahat


###################################################
### chunk number 10: 
###################################################
m1 <- lm(formula = Fuel ~ Tax + Dlic + Income + logMiles, 
         data = f)
summary(m1)


###################################################
### chunk number 11: 
###################################################
m2 <- update(m1, ~.-Tax)
anova(m2,m1)


###################################################
### chunk number 12: 
###################################################
m1 <- lm(Fuel ~ Tax + Dlic + Income + logMiles, data = f)
m2 <- update(m1, ~ Dlic + Tax + Income + logMiles)
m3 <- update(m1, ~ Tax + Dlic + logMiles + Income)


###################################################
### chunk number 13: 
###################################################
predict(m1, newdata=data.frame(
        Tax=c(20, 35), Dlic=c(909, 943), Income=c(16.3, 16.8),
        logMiles=c(15, 17)))


###################################################
### chunk number 14:  eval=FALSE
###################################################
## avPlots(m0, id.n=0)


