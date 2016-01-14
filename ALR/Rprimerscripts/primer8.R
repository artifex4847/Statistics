###################################################
### chunk number 1: 
###################################################
library(alr3)
options(width=70,show.signif.stars=FALSE,digits=4)
.Sweave.cex=1


###################################################
### chunk number 2:  eval=FALSE
###################################################
## plot(predict(m1), residuals(m1, type="pearson"))
## plot(predict(m1), predict(m2))
## press <- residuals(m1) / (1 - hatvalues(m1))


###################################################
### chunk number 3:  eval=FALSE
###################################################
## decomp <- qr(cbind(rep(1,n),X))
## Hat <- qr.Q(decomp) %*% t(qr.Q(decomp))


###################################################
### chunk number 4: 7F6
###################################################
fuel2001 <- transform(fuel2001, Fuel = 1000 * FuelC / Pop,
  Dlic = 1000 * Drivers / Pop)
m1 <- lm(Fuel ~ Tax + Dlic + Income + log2(Miles), data=fuel2001)
residualPlots(m1)


###################################################
### chunk number 5:  eval=FALSE
###################################################
## residualPlots(m1, ~ log2(Miles), fitted=FALSE)
## residualPlots(m1, ~ 1, fitted=TRUE)


###################################################
### chunk number 6: 7F6a
###################################################
marginalModelPlot(m1, id.n=4)


###################################################
### chunk number 7:  eval=FALSE
###################################################
## plot(x, y)


###################################################
### chunk number 8:  eval=FALSE
###################################################
## identify(x, y, labels)


###################################################
### chunk number 9: 7F6
###################################################
residualPlots(m1)


###################################################
### chunk number 10: 
###################################################
m1 <- lm(photo ~ obs1, snowgeese)
sig2 <- sum(residuals(m1, type="pearson")^2) / 
            length(snowgeese$obs1)
U <- residuals(m1)^2 / sig2
m2 <- update(m1, U ~ .)
anova(m2)


###################################################
### chunk number 11: 
###################################################
ncvTest(m1)


###################################################
### chunk number 12: 
###################################################
m1 <- lm(Y ~ TankTemp + GasTemp + TankPres + GasPres, sniffer)
ncvTest(m1, ~ TankTemp, data=sniffer)
ncvTest(m1, ~ TankTemp + GasPres, data=sniffer)
ncvTest(m1, ~ TankTemp + GasTemp + TankPres + 
              GasPres, data=sniffer)
ncvTest(m1)


###################################################
### chunk number 13: 7F8
###################################################
c1 <- lm(Height ~ Dbh, ufcwc)
mmp(c1, ufcwc$Dbh, label="Diameter, Dbh", 
        col.line=c("blue", "red"))


###################################################
### chunk number 14: 7F9
###################################################
m1 <- lm(logFertility ~ logPPgdp + Purban, UN2)
mmps(m1)


###################################################
### chunk number 15: 7F10
###################################################
mmp(m1, u=randomLinComb(m1))


###################################################
### chunk number 16: 7F11
###################################################
mmp(m1, u=randomLinComb(m1, seed=254346576))


