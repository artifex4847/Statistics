###################################################
### chunk number 1: 
###################################################
library(alr3)
options(width=70,show.signif.stars=FALSE,digits=4)
.Sweave.cex=1


###################################################
### chunk number 2: 6F1
###################################################
with(cakes, plot(jitter(X1), jitter(X2)))


###################################################
### chunk number 3: 
###################################################
x <- 1:5
(xmat <- cbind(x^0, x, x^2, x^3))
as.data.frame(poly(x, 3, raw=TRUE))


###################################################
### chunk number 4: 
###################################################
as.data.frame(poly(x, 3))


###################################################
### chunk number 5: 
###################################################
qr.Q(qr(xmat))


###################################################
### chunk number 6: 
###################################################
m1 <- lm(Y ~ X1 + X2 + I(X1^2) + I(X2^2) + X1:X2, data=cakes)


###################################################
### chunk number 7: 
###################################################
cakes$X1sq <- cakes$X1^2
cakes$X2sq <- cakes$X2^2
cakes$X1X2 <- cakes$X1 * cakes$X2
m2 <- lm(Y ~ X1 + X2 + X1sq + X2sq + X1X2, data=cakes)


###################################################
### chunk number 8: 
###################################################
m3 <- lm(Y ~ poly(X1, X2, degree=2, raw=TRUE), data=cakes)


###################################################
### chunk number 9: 6F2
###################################################
with(cakes, plot(X1, Y, type="n", xlab="(a) X1"))
X1new <- seq(32, 38, len=50)
lines(X1new, predict(m1, 
     newdata=data.frame(X1=X1new, X2=rep(340, 50))))
lines(X1new, predict(m1, 
     newdata=data.frame(X1=X1new, X2=rep(350, 50))))
lines(X1new, predict(m1, 
     newdata=data.frame(X1=X1new, X2=rep(360, 50))))
text(34, 4.7, "X2=340", adj=0, cex=0.7)
text(32, 5.7, "X2=350" ,adj=0, cex=0.7)
text(32, 7.6, "X2=360", adj=0, cex=0.7)


###################################################
### chunk number 10: 
###################################################
m4 <- lm(Y ~ X2 + I(X2^2), data=cakes)
Var <- vcov(m4)
b0 <- coef(m4)[1]
b1 <- coef(m4)[2]
b2 <- coef(m4)[3]


###################################################
### chunk number 11: 
###################################################
xm <- "-b1/(2*b2)"
xm.expr <- parse(text=xm)
xm.expr


###################################################
### chunk number 12: 
###################################################
eval(xm.expr)


###################################################
### chunk number 13: 
###################################################
expr <- expression(-b2/(2*b3))
derivs <- c(D(xm.expr, "b0"), D(xm.expr,"b1"), D(xm.expr, "b2"))
derivs


###################################################
### chunk number 14: 
###################################################
eval.derivs<-c(eval(D(xm.expr, "b0")), eval(D(xm.expr, "b1")),
               eval(D(xm.expr, "b2")))
eval.derivs


###################################################
### chunk number 15: 
###################################################
sqrt(t(eval.derivs) %*% Var %*% eval.derivs)


###################################################
### chunk number 16: 
###################################################
deltaMethod(m4,"-b1/(2*b2)")


###################################################
### chunk number 17: 
###################################################
args(factor)


###################################################
### chunk number 18: 
###################################################
sleep1$D <- factor(sleep1$D)


###################################################
### chunk number 19: 
###################################################
sleep1$D <- factor(sleep1$D)
a1 <- lm(TS ~ D, sleep1)
a0 <- update(a1, ~ . -1)
summary(a0)
summary(a1)


###################################################
### chunk number 20: 6F3
###################################################
m <- pod(LBM~Ht+Wt+RCC, data=ais, group=Sex, mean.function="pod")
anova(m)
plot(m,pch=c("m","f"),colors=c("red","black"))


###################################################
### chunk number 21:  eval=FALSE
###################################################
## plot(x, colors = rainbow(nlevels(x$group)),
##     pch = 1:nlevels(x$group), key = FALSE,
##     xlab = "Linear Predictor",
##     ylab = as.character(formula(x)[[2]]), ...)


###################################################
### chunk number 22: 
###################################################
library(nlme)
library(lattice)
data(chloride)
xyplot(Cl ~ Month|Type, group=Marsh, data=chloride, 
       ylab="Cl (mg/liter)",
       panel.groups=function(x,y,...){
              panel.linejoin(x,y,horizontal=FALSE,...)
              }
       )
m1 <- lme(Cl ~ Month + Type, data=chloride, 
       random=~ 1 + Type|Marsh)
m2 <- update(m1, random= ~ 1|Marsh)


###################################################
### chunk number 23: 
###################################################
anova(m1,m2)
intervals(m2)


