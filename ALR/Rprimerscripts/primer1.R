###################################################
### chunk number 1: 
###################################################
options(width=70,show.signif.stars=FALSE,digits=4)
.Sweave.cex=1


###################################################
### chunk number 2: F1-0
###################################################
library(alr3)
plot(Dheight ~ Mheight, data=heights)


###################################################
### chunk number 3:  eval=FALSE
###################################################
## plot(heights$Mheight, heights$Dheight)
## with(heights, plot(Mheight, Dheight))


###################################################
### chunk number 4: F1.1
###################################################
with(heights, plot(Mheight, Dheight, xlim=c(55, 75),
                   ylim=c(55,75), pch=20))


###################################################
### chunk number 5: F1.2
###################################################
sel <- with(heights, 
  (57.5 < Mheight) & (Mheight <= 58.5) |
  (62.5 < Mheight) & (Mheight <= 63.5) |
  (67.5 < Mheight) & (Mheight <= 68.5))
with(heights, plot(Mheight[sel], Dheight[sel], xlim=c(55,75),
                   ylim=c(55,75), pty="s", pch=20, cex=.3, 
                   xlab="Mheight", ylab="Dheight"))


###################################################
### chunk number 6: 
###################################################
oldpar <- par(mfrow=c(1, 2))


###################################################
### chunk number 7: F1.3
###################################################
m0 <- lm(Pressure ~ Temp, data=forbes)
plot(Pressure ~ Temp, data=forbes, xlab="Temperature",
     ylab="Pressure")
abline(m0)
plot(residuals(m0) ~ Temp, forbes, xlab="Temperature", 
     ylab="Residuals")
abline(a=0, b=0, lty=2)
par(oldpar)


###################################################
### chunk number 8: F1.5
###################################################
with(wblake, plot(Age, Length))
abline(lm(Length ~ Age, data=wblake))
with(wblake, lines(1:8, tapply(Length, Age, mean), lty=2))


###################################################
### chunk number 9: F1.7
###################################################
plot(Gain ~ A, data=turkey, pch=S, 
     xlab="Amount(percent of diet)",
     col=S, ylab="Weight gain, g")
legend("topleft", legend=c("1", "2", "3"), pch=1:3, 
     cex=.6, inset=0.02)


###################################################
### chunk number 10: F1.10
###################################################
plot(Dheight ~ Mheight, heights, cex=.1,pch=20)
abline(lm(Dheight ~ Mheight, heights), lty=1)
with(heights, lines(lowess(Dheight ~ Mheight, f=6/10, 
                    iter=1), lty=2))


###################################################
### chunk number 11: F1.11
###################################################
fuel2001 <- transform(fuel2001, 
             Dlic=1000 * Drivers/Pop,
             Fuel=1000 * FuelC/Pop,
             Income = Income/1000,
             logMiles = log2(Miles))
names(fuel2001)
pairs(~ Tax + Dlic + Income + logMiles + Fuel, data=fuel2001)


###################################################
### chunk number 12:  eval=FALSE
###################################################
## fuel2001$FuelPerDriver <- fuel2001$FuelC / fuel2001$Drivers 


###################################################
### chunk number 13:  eval=FALSE
###################################################
## pairs(fuel2001[, c(7,9,3,11,10)])


