###################################################
### chunk number 1: 
###################################################
library(alr3)
options(width=70,show.signif.stars=FALSE,digits=4)
.Sweave.cex=1


###################################################
### chunk number 2: 7F1
###################################################
with(ufcwc, plot(Dbh, Height))
lam <-c(1, 0, -1)
new.dbh <- with(ufcwc, seq(min(Dbh), max(Dbh), length=100))
for (j in 1:3){
   m1 <- lm(Height ~ bcPower(Dbh,lam[j]), data=ufcwc)
   lines(new.dbh, 
      predict(m1, data.frame(Dbh=new.dbh)), lty=j, col=j)
   }
legend("bottomright", inset=.03, legend = as.character(lam),
       lty=1:3, col=1:3)


###################################################
### chunk number 3: 7F2
###################################################
with(ufcwc, invTranPlot(Dbh, Height))


###################################################
### chunk number 4: 
###################################################
unlist(with(ufcwc, invTranEstimate(Dbh,Height)))


###################################################
### chunk number 5:  eval=FALSE
###################################################
## bcPower(U, lambda, jacobian.adjusted=FALSE)


###################################################
### chunk number 6:  eval=FALSE
###################################################
## plot(bcPower(U, 0, jacobian.adjusted=FALSE), Y)


###################################################
### chunk number 7: 7F3
###################################################
highway <- transform(highway, logLen=log2(Len),
           logADT=log2(ADT), logTrks=log2(Trks), 
           logSigs1=log2((Len*Sigs+1)/Len))
m2 <- lm(Rate ~ logLen + logADT + logTrks + Slim + Shld + logSigs1,
         data=highway)
invTranPlot(highway$Rate,predict(m2))
unlist(invTranEstimate(highway$Rate,predict(m2)))


###################################################
### chunk number 8: 7F5
###################################################
invResPlot(m2)


###################################################
### chunk number 9: 6Fboxcox
###################################################
boxCox(m2, xlab=expression(lambda[y]))
summary(powerTransform(m2))


###################################################
### chunk number 10:  eval=FALSE
###################################################
## pairs(~ Rate + Len + ADT + Trks + Slim + Shld +
##         Sigs, data=highway)


###################################################
### chunk number 11: 7F6
###################################################
scatterplotMatrix( ~ Rate + Len + ADT + Trks + Slim + Shld + 
                  Sigs, data=highway)


###################################################
### chunk number 12: 
###################################################
highway$Sigs1 <- 
     (round(highway$Sigs*highway$Len) + 1)/highway$Len
ans <- powerTransform(cbind(Len, ADT, Trks, Shld, Sigs1) ~ 1, 
     data=highway)
summary(ans)


###################################################
### chunk number 13: 
###################################################
testTransform(ans,lambda=c(0, 0, -1, 1, 0))


###################################################
### chunk number 14: 
###################################################
highway <- transform(highway,
       basicPower(highway[,names(coef(ans))], 
             coef(ans, round=TRUE)))


