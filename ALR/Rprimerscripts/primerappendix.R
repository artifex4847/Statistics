###################################################
### chunk number 1: 
###################################################
library(alr3)
options(width=70,show.signif.stars=FALSE,digits=4)
.Sweave.cex=1


###################################################
### chunk number 2: 13F1
###################################################
with(ufcwc, {
  plot(Height ~ Dbh)
  abline(lm(Height ~ Dbh),lty=3)
  lines(lowess(Dbh, Height, iter=1, f=.1), lty=4)
  lines(lowess(Dbh, Height, iter=1, f=2/3), lty=1)
  lines(lowess(Dbh, Height, iter=1, f=.95), lty=2)
  legend(700,200, legend=c("f=.1","f=2/3", "f=.95", "OLS"), 
    lty=c(4, 1, 2, 3))
  })


###################################################
### chunk number 3: 13F2
###################################################
with(ufcwc, {
  plot(Dbh, Height)
  abline(lm(Height ~ Dbh), lty=3)
  new <- seq(100, 1000, length=100)
  m1 <- loess(Height ~ Dbh, degree=1, span=.1)
  m2 <- loess(Height ~ Dbh, degree=1, span=2/3)
  m3 <- loess(Height ~ Dbh, degree=1, span=.95)
  lines(new, predict(m1, data.frame(Dbh=new)), lty=4, col="cyan")
  lines(new, predict(m2, data.frame(Dbh=new)), lty=1, col="red")
  lines(new, predict(m3, data.frame(Dbh=new)), lty=2, col="blue")
  legend(700, 200, legend=c("f=.1", "f=2/3", "f=.95", "OLS"),
    lty=c(4, 1, 2, 3))
  })


###################################################
### chunk number 4: 13F3
###################################################
with(ufcwc, {
  plot(Dbh, Height)
  loess.fit <- loess(Height ~ Dbh, degree=1, span=2/3) # gives same answers
  sqres <- residuals(loess.fit)^2
  loess.var.fit <- loess(sqres ~ Dbh, degree=1, span=2/3)
  new <- seq(min(Dbh), max(Dbh), length=100)
  lines(new, predict(loess.fit, data.frame(Dbh=new)))
  lines(new, predict(loess.fit, data.frame(Dbh=new)) +
             sqrt(predict(loess.var.fit, data.frame(Dbh=new))), lty=2)
  lines(new, predict(loess.fit,data.frame(Dbh=new)) -
             sqrt(predict(loess.var.fit, data.frame(Dbh=new))), lty=2)
  })


###################################################
### chunk number 5: 
###################################################
X <- matrix(c(1, 1, 1, 1, 2, 1, 3, 8, 1, 5, 4, 6), ncol=3, 
     byrow=FALSE)
y <- c(2, 3, -2, 0)
X
y
QR <- qr(X)


###################################################
### chunk number 6: 
###################################################
qr.Q(QR)
qr.R(QR)


###################################################
### chunk number 7: 
###################################################
qr.coef(QR,y)
qr.fitted(QR,y)
qr.resid(QR,y)


