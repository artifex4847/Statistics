###################################################
### chunk number 1: 
###################################################
library(alr3)
options(width=70,show.signif.stars=FALSE,digits=4)
.Sweave.cex=1


###################################################
### chunk number 2: 
###################################################
set.seed(123456)
case1 <- data.frame(x1=rnorm(100), x2=rnorm(100),
                    x3=rnorm(100), x4=rnorm(100))
e <- rnorm(100)
case1$y <- 1 + case1$x1 + case1$x2 + e
m1 <- lm(y ~ ., data=case1)


###################################################
### chunk number 3: 
###################################################
Var2 <- matrix(c(1,   0, .95,   0,
                 0,   1,   0,-.95,
               .95,   0,   1,   0,
                 0,-.95,   0,   1), ncol=4)
library(mvtnorm)
X <- rmvnorm(100, sigma=Var2)
dimnames(X)[[2]] <- paste("x", 1:4, sep="")
case2 <- data.frame(X)
case2$y <- 1 + case2$x1 + case2$x2 + e
m2 <- lm(y ~ x1 + x2 + x3 + x4, data=case2)


###################################################
### chunk number 4: 
###################################################
vif(m1)
vif(m2)


###################################################
### chunk number 5:  eval=FALSE
###################################################
## extractAIC(m0, k=2) # give AIC
## extractAIC(m0, k=log(length(residuals(m0)))) # gives BIC
## extractAIC(m0, scale=sigmaHat(m1)^2) # gives Cp


###################################################
### chunk number 6: 
###################################################
PRESS <- sum((residuals(m1, type="pearson") /
             (1-ls.diag(m1)$hat))^2)


###################################################
### chunk number 7: 
###################################################
highway <- transform(highway, logLen=log2(Len),
           logADT=log2(ADT), logTrks=log2(Trks), 
           logSigs1=log2((Len*Sigs+1)/Len))
m1 <- lm(log2(Rate) ~ logLen + logADT + logTrks + logSigs1 +
         Slim + Shld + Lane + Acpt + Itg + Lwid + Hwy, 
         data=highway) 
m0 <- lm(log2(Rate) ~ logLen, data=highway)


###################################################
### chunk number 8: 
###################################################
ansf1 <- step(m0,scope=list(lower=~ logLen,
          upper=~logLen + logADT + logTrks + logSigs1 + 
                 Slim + Shld + Lane + Acpt + Itg +
                 Lwid + Hwy),
                 direction="forward", data=highway)
ansf1


###################################################
### chunk number 9: 
###################################################
ansf2 <- step(m1, scope=list(lower=~ logLen,
         upper=~logLen + logADT + logTrks + logSigs1 + Slim + 
                Shld + Lane + Acpt + Itg + Lwid + Hwy),
                direction="backward", data=highway,
                scale=sigmaHat(m1)^2)


###################################################
### chunk number 10:  eval=FALSE
###################################################
## loc <- "http://www.stat.umn.edu/alr/data/wm5.txt"
## wm5 <- read.table(loc, header=TRUE)


