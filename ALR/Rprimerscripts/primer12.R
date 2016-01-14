###################################################
### chunk number 1: 
###################################################
library(alr3)
options(width=70,show.signif.stars=FALSE,digits=4)
.Sweave.cex=1


###################################################
### chunk number 2:  eval=FALSE
###################################################
## glm(formula, family = binomial(link="logit"), data, weights,
##     subset, na.action, start = NULL)


###################################################
### chunk number 3: 
###################################################
m1 <- glm(y ~ logb(D, 2), family=binomial, data=blowBF)
summary(m1)


###################################################
### chunk number 4: 12F1
###################################################
with(blowBF, { 
  plot(jitter(log2(D), amount=.05),
      jitter(y, amount=0.02), pch=20,
      xlab=expression(paste("(a) ",Log[2](Diameter))),
      ylab="Blowdown indicator")
  xx <- seq(min(D), max(D), length=100)
  abline(lm(y~ log2(D)), lty=1)
  lo.fit <- loess(y ~ log2(D), degree=1)
  lines(log2(xx), predict(lo.fit, data.frame(D=xx)), lty=3)
  lines(log2(xx), predict(m1, data.frame(D=xx), type="response"), lty=2)
})


###################################################
### chunk number 5: 
###################################################
library(sm)


###################################################
### chunk number 6: 12F2
###################################################
library(sm)
with(blowBF, {
  sm.density.compare(log2(D), y, lty=c(1,2),
    xlab=expression(paste("(b) ", log[2](D))))
  legend("topright",legend=c("Y=0", "Y=1"), lty=c(1,2),cex=0.8)
})


###################################################
### chunk number 7: 
###################################################
m2 <- glm(y ~ log2(D) + S, family=binomial, data=blowBF)
m3 <- update(m2,~ . + log(D):S)
summary(m2)  
summary(m3)


###################################################
### chunk number 8: 12F3
###################################################
with(blowBF, {
  xa <- seq(min(D), max(D), len=99)
  ya <- seq(.01, .99, len=99)
  za <- matrix(nrow=99, ncol=99)
  for (i in 1:99) {
    za[,i] <- predict(m3, data.frame(D=rep(xa[i], 99), S=ya),
             type="response")}
  contour(log(xa), ya, za,
      xlab=expression(paste("(b) ", log[2](D))), ylab="S")
  points(jitter(log2(D), amount=.04), S,pch=y + 1, cex=.5)
  })


###################################################
### chunk number 9: 12F4
###################################################
xx <- with(blowBF, seq(min(log2(D)), max(log2(D)), length=100))
plot(2^(xx), exp(coef(m3)[3]/10 + coef(m3)[4] * xx/10), type="l",
        xlab="(b) D", ylab="Odds multiplier")


###################################################
### chunk number 10: 
###################################################
anova(m1, m2, m3, test="Chisq")


###################################################
### chunk number 11: 
###################################################
m1 <- glm(cbind(Surv, N-Surv) ~ Class + Age + Sex, data=titanic,
              family=binomial)


