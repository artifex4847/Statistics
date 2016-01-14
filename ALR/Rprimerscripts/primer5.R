###################################################
### chunk number 1: 
###################################################
library(alr3)
options(width=70,show.signif.stars=FALSE,digits=4)
.Sweave.cex=1
data(physics)
data(transact)
data(fuel2001)
data(UN2)


###################################################
### chunk number 2: 
###################################################
m1 <- lm(y ~ x, data=physics, weights=1/SD^2)
summary(m1) 
anova(m1)


###################################################
### chunk number 3: Rsupp61
###################################################
m1 <- lm(y ~ x, data=physics, weights=1/SD^2)
m2 <- update(m1, ~ . + I(x^2))
plot(y ~ x, data=physics, xlab=expression(x=s^{-1/2}), 
          ylab="Cross section, y")
abline(m1)
a <- seq(.05,.35,length=50)
lines(a, predict(m2, newdata=data.frame(x=a)), lty=2)


###################################################
### chunk number 4: 
###################################################
x <- c(1, 1, 1, 2, 3, 3, 4, 4, 4, 4)
y <- c(2.55, 2.75, 2.57, 2.40, 4.19, 4.70, 3.81, 4.87, 
       2.93, 4.52)
m1 <- lm(y ~ x)
anova(lm(y ~ x + as.factor(x)))


###################################################
### chunk number 5: 
###################################################
pureErrorAnova(m1)


###################################################
### chunk number 6: 
###################################################
fuel2001$Dlic <- 1000 * fuel2001$Drivers / fuel2001$Pop
fuel2001$Fuel <- 1000*  fuel2001$FuelC / fuel2001$Pop
fuel2001$Income <- fuel2001$Income / 1000
fuel2001$logMiles <- log2(fuel2001$Miles)
m1 <- lm(Fuel ~ Dlic + Income + logMiles + Tax, data=fuel2001)
m2 <- update(m1, ~ . - Dlic - Income)
anova(m2, m1)


###################################################
### chunk number 7: 
###################################################
m3 <- update(m2, ~ . - Tax)
anova(m3, m2, m1)


###################################################
### chunk number 8: Rsupp62
###################################################
m1 <- lm(logFertility ~ logPPgdp + Purban, data = UN2)
confidenceEllipse(m1, scheffe=TRUE)


###################################################
### chunk number 9:  eval=FALSE
###################################################
## estar <- ehat[sample(1:n, replace=TRUE)]


