###################################################
### chunk number 1: 
###################################################
library(alr3)
options(width=70,show.signif.stars=FALSE,digits=4)
.Sweave.cex=1


###################################################
### chunk number 2: 
###################################################
n1 <- nls(Gain ~ th1 + th2*(1-exp(-th3 * A)), data=turk0,
      start=list(th1=620, th2=200, th3=10))
summary(n1)


###################################################
### chunk number 3: 
###################################################
with(turk0, plot(A, Gain, xlab="Amount (percent of diet)", 
     ylab="Weight gain, g"))
x <- (0:44)/100
lines(x,predict(n1,data.frame(A=x)))


###################################################
### chunk number 4: 
###################################################
m1 <- lm(Gain ~ as.factor(A), turk0)
anova(n1,m1)


###################################################
### chunk number 5: 
###################################################
# create the indicators for the categories of S
turkey$S1 <- turkey$S2 <- turkey$S3 <- rep(0,dim(turkey)[1])
turkey$S1[turkey$S==1] <- 1
turkey$S2[turkey$S==2] <- 1
turkey$S3[turkey$S==3] <- 1
# compute the weighted response
turkey$wGain <- sqrt(turkey$m) * turkey$Gain
# fit the models
# common regressions
m4 <- nls(wGain ~ sqrt(m) * (th1 + th2*(1-exp(-th3 * A))),
           data=turkey, start=list(th1=620, th2=200, th3=10))
# most general
m1 <- nls( wGain ~ sqrt(m) * (S1 * (th11 + th21 * 
                   (1 - exp(-th31 * A))) +
                   S2 * (th12 + th22 * (1 - exp(-th32 * A)))+
                   S3 * (th13 + th23*(1 - exp(-th33 * A)))),
           data=turkey, start= list(th11=620, th12=620, th13=620,
                                    th21=200, th22=200, th23=200,
                                    th31=10, th32=10, th33=10))
# common intercept
m2 <- nls(wGain ~ sqrt(m) * (th1 +
                  S1 * (th21 * (1 - exp(-th31 * A)))+
                  S2 * (th22 * (1 - exp(-th32 * A)))+
                  S3 * (th23 * (1 - exp(-th33 * A)))),
          data=turkey, start= list(th1=620,
                              th21=200, th22=200, th23=200,
                              th31=10, th32=10, th33=10))
# common intercept and asymptote
m3 <- nls( wGain ~ sqrt(m) * (th1 + th2  * (
                   S1 * (1 - exp(-th31 * A))+
                   S2 * (1 - exp(-th32 * A))+
                   S3 * (1 - exp(-th33 * A)))),
          data=turkey,start= list(th1=620, th2=200,
                                 th31=10, th32=10, th33=10))


###################################################
### chunk number 6:  eval=FALSE
###################################################
## smod <- C ~ th0 + th1 * (pmax(0,Temp-gamma))
## s1 <- nls(smod, data=segreg, data = segreg,
##           start=list(th0=70, th1=.5, gamma=40))
## set.seed(10131985)
## s1.boot <- bootCase(s1, B=999)


###################################################
### chunk number 7:  eval=FALSE
###################################################
## scatterplot.matrix(s1.boot, diagonal="histogram", 
##    lwd=0.7, pch=".",
##    labels=c(expression(theta[1]), expression(theta[2]),
##             expression(gamma)),
##    ellipse=FALSE, smooth=TRUE, level=c(.90))


###################################################
### chunk number 8:  eval=FALSE
###################################################
## s1.boot.summary <- 
##   data.frame(rbind(
##    apply(s1.boot, 2, mean),
##    apply(s1.boot, 2, sd),
##    apply(s1.boot, 2, function(x){quantile(x, c(.025, .975))})))
## row.names(s1.boot.summary)<-c("Mean", "SD","2.5%", "97.5%")
## s1.boot.summary


