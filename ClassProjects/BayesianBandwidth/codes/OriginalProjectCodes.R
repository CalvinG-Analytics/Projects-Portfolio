#Calvin Guan

#MA 578 Final Project
library(plotly)
library(plyr)
library(magrittr)
library(here)

#Read in data, keep only NBA National leagues, and replace 0's with missing values

A0 <- read.csv(here::here("ClassProjects\\BayesianBandwidth\\data\\team_season.txt"), header = 1)
A1 <- A0[A0$leag=='N',] ; A1[A1==0] <- NA
A2 <- A1[,c(2,4:18,34:36)]

A.sub <- function(var,yr){
  var[A2$year %in% yr]/(A2$won[A2$year %in% yr]+ A2$lost[A2$year %in% yr])
}

#Bayesian Posterior Smoothing Parameter
h.bayes <- function(x,X,a,b){
  l <- length(x); R <- numeric(l)
  for (i in 1:l){
    R[i] <- (gamma(a)/(gamma(a+.5)*sqrt(2*b)))*sum((1/(b*(X-x[i])^2+2))^a)/sum((1/(b*(X-x[i])^2+2))^(a+.5))
  } ; R
}

#Kernel Density Estimation using Bayesian Bandwidth and Gaussian Kernel
KDE <- function(x,h,X){
  n <- length(X); l <- length(x); R <- numeric(l)
  for (i in 1:l){
    R[i] <- sum(dnorm((X-x[i])/h[i]))/(n*h[i])
  } ; R
}

########################
#Histogram of points
s1 <- A.sub(A2$o_pts,1996:2005)
hist(s1, main = 'Histogram of Points Scored Per Game for Teams From 1996 - 2005', xlab = "Points Per Games")

########################
### Density Estimation for Points Scored

#Try 3 different parameters for h
#1. a = 2, b = 1
#2. a = 4, b = 2
#3. a = 1, b = .5

x <- seq(60,125,.1)
a <- 2; b <- 1
plot(x, KDE(x,h.bayes(x,s1,a,b),s1), type = 'l', main = "Effect of Prior Hyperparameters on Density Estimation - Points Per Game",
     ylab = 'Density', xlab = 'Points Per Game', ylim = c(-0.003,0.1),lwd = 2)
a <- 4; b <- 2
lines(x, KDE(x,h.bayes(x,s1,a,b),s1), lty = 2, lwd = 2, col="red")
a <- 1; b <- .5
lines(x, KDE(x,h.bayes(x,s1,a,b),s1), lty = 3, lwd = 2, col = "blue")
legend('topleft',bty='n',lty=c(3,1,2), col = c("blue","black","red"), lwd = 2,
       legend=c('Alpha = 1, Beta = .5','Alpha = 2, Beta = 1','Alpha = 4, Beta = 2'), seg.len=4, cex=1)

### Bandwidth Values for Points Scored

#Try 3 different parameters for h
#1. a = 2, b = 1
#2. a = 4, b = 2
#3. a = 1, b = .5

a <- 2; b <- 1
plot(x, h.bayes(x,s1,a,b), type = 'l', main = "PPG KDE, Bandwidth Length, Alpha = 2, Beta = 1",
     ylab = 'Bandwidth', xlab = 'Points Per Game', lwd = 2)
a <- 4; b <- 2
plot(x, h.bayes(x,s1,a,b), main = "PPG KDE, Bandwidth Length, Alpha = 4, Beta = 2",
     ylab = 'Bandwidth', xlab = 'Points Per Game', lty = 2, lwd = 2, col="red", type = 'l')
a <- 1; b <- .5
plot(x, h.bayes(x,s1,a,b), main = "PPG KDE, Bandwidth Length, Alpha = 1, Beta = .5",
     ylab = 'Bandwidth', xlab = 'Points Per Game', lty = 3, lwd = 2, col = "blue", type = 'l')
###Influence of Prior on Bandwidth DECREASES as the parameter values increases

###########################################
### Group Data By Decades
g1 <- A.sub(A2$o_pts,1946:1955)
g2 <- A.sub(A2$o_pts,1956:1965)
g3 <- A.sub(A2$o_pts,1966:1975)
g4 <- A.sub(A2$o_pts,1976:1985)
g5 <- A.sub(A2$o_pts,1986:1995)
g6 <- A.sub(A2$o_pts,1996:2005)

### Get Estimated Density for each Decade
x <- seq(60,125,.1); l <- length(x)
a <- 2; b <- 1
k1 <- KDE(x,h.bayes(x,g1,a,b),g1)
k2 <- KDE(x,h.bayes(x,g2,a,b),g2)
k3 <- KDE(x,h.bayes(x,g3,a,b),g3)
k4 <- KDE(x,h.bayes(x,g4,a,b),g4)
k5 <- KDE(x,h.bayes(x,g5,a,b),g5)
k6 <- KDE(x,h.bayes(x,g6,a,b),g6)
k <- c(k1,k2,k3,k4,k5,k6)

###Decade labels
yr <- c(rep("`46-`55",l),rep("`56-`65",l),rep("`66-`75",l),rep("`76-`85",l),rep("`86-`95",l),rep("`96-`05",l))
plot_ly(y = rep(x,6), z = k, x = yr, type = "scatter3d", mode = "lines", split = yr) %>%
  layout(
    title = "Estimated Points Per Game Density - Alpha = 2, Beta = 1",
    scene = list(
      yaxis = list(title = "Points Per Game"),
      xaxis = list(title = "Years"),
      zaxis = list(title = "Density")
    ))

#########################################
###Repeat for Field Goal Percentage
###Observation Level: Teams, Response: Overall FG Percentage in a season

########################
#Histogram of Field Goal Percentage
fg1 <- A.sub(A2$o_fgm,1996:2005)/A.sub(A2$o_fga,1996:2005)*100
hist(fg1, main = 'Histogram of Field Goal Percentage for Teams From 1996 - 2005', xlab = "Field Goal Percentage")

########################
### Density Estimation for Points Scored
#Try 3 different parameters for h
#1. a = 2, b = 4
#2. a = 4, b = 8
#3. a = 1, b = 2
x <- seq(38,52,.1); l <- length(x)
a <- 2; b <- 4
plot(x, KDE(x,h.bayes(x,fg1,a,b),fg1), type = 'l', main = "Effect of Prior Hyperparameters on Density Estimation - Field Goal Percent",
     ylab = 'Density', ylim = c(-0.001,0.28), xlab = 'Percent Field Goals Made', lwd = 2)
a <- 4; b <- 8
lines(x, KDE(x,h.bayes(x,fg1,a,b),fg1), lty = 2, lwd = 2, col="red")
a <- 1; b <- 2
lines(x, KDE(x,h.bayes(x,fg1,a,b),fg1), lty = 3, lwd = 2, col = "blue")
legend('topleft',bty='n',lty=c(3,1,2), col = c("blue","black","red"), lwd = 2,
       legend=c('Alpha = 1, Beta = 2','Alpha = 2, Beta = 4','Alpha = 4, Beta = 8'), seg.len=4, cex=1)

### Bandwidth Values for Points Scored
#Try 3 different parameters for h
#1. a = 2, b = 4
#2. a = 4, b = 8
#3. a = 1, b = 2
a <- 2; b <- 4
plot(x, h.bayes(x,fg1,a,b), type = 'l', main = "FG KDE, Bandwidth Length, Alpha = 2, Beta = 4",
     ylab = 'Bandwidth', xlab = 'Percent Field Goals Made', lwd = 2)
a <- 4; b <- 8
plot(x, h.bayes(x,fg1,a,b), main = "FG KDE, Bandwidth Length, Alpha = 4, Beta = 8",
     ylab = 'Bandwidth', xlab = 'Percent Field Goals Made', lty = 2, lwd = 2, col="red", type = 'l')
a <- 1; b <- 2
plot(x, h.bayes(x,fg1,a,b), main = "FG KDE, Bandwidth Length, Alpha = 1, Beta = 2",
     ylab = 'Bandwidth', xlab = 'Percent Field Goals Made', lty = 3, lwd = 2, col = "blue", type = 'l')

###########################################

### Group Data By Decades
f1 <- A.sub(A2$o_fgm,1946:1955)/A.sub(A2$o_fga,1946:1955)*100
f2 <- A.sub(A2$o_fgm,1956:1965)/A.sub(A2$o_fga,1956:1965)*100
f3 <- A.sub(A2$o_fgm,1966:1975)/A.sub(A2$o_fga,1966:1975)*100
f4 <- A.sub(A2$o_fgm,1976:1985)/A.sub(A2$o_fga,1976:1985)*100
f5 <- A.sub(A2$o_fgm,1986:1995)/A.sub(A2$o_fga,1986:1995)*100
f6 <- A.sub(A2$o_fgm,1996:2005)/A.sub(A2$o_fga,1996:2005)*100

### Get Estimated Density for each Decade
x <- seq(24,55,.1); l <- length(x)
a <- 2; b <- 4
j1 <- KDE(x,h.bayes(x,f1,a,b),f1)
j2 <- KDE(x,h.bayes(x,f2,a,b),f2)
j3 <- KDE(x,h.bayes(x,f3,a,b),f3)
j4 <- KDE(x,h.bayes(x,f4,a,b),f4)
j5 <- KDE(x,h.bayes(x,f5,a,b),f5)
j6 <- KDE(x,h.bayes(x,f6,a,b),f6)
j <- c(j1,j2,j3,j4,j5,j6)

###Decade labels
yr <- c(rep("`46-`55",l),rep("`56-`65",l),rep("`66-`75",l),rep("`76-`85",l),rep("`86-`95",l),rep("`96-`05",l))
plot_ly(y = rep(x,6), z = j, x = yr, type = "scatter3d", mode = "lines", split = yr) %>%
  layout(
    title = "Estimated Percent Field Goal Made Density - Alpha = 2, Beta = 4",
    scene = list(
      yaxis = list(title = "Percent Field Goals Made"),
      xaxis = list(title = "Years"),
      zaxis = list(title = "Density")
    ))

#########################################

###Repeat for Free Throw Percentage

###Observation Level: Teams, Response: Overall Free Throw Percentage in a season

########################

#Histogram of Field Goal Percentage
ft1 <- A.sub(A2$o_ftm,1996:2005)/A.sub(A2$o_fta,1996:2005)*100
hist(ft1, main = 'Histogram of Free Throw Percentage for Teams From 1996 - 2005', xlab = "Free Throw Percentage")

########################

### Density Estimation for Points Scored

#Try 3 different parameters for h
#1. a = 2, b = 2
#2. a = 4, b = 4
#3. a = 1, b = 1
x <- seq(66,84,.1); l <- length(x)

a <- 2; b <- 2
plot(x, KDE(x,h.bayes(x,ft1,a,b),ft1), type = 'l', main = "Effect of Prior Hyperparameters on Density Estimation - Free Throw Percent",
     ylab = 'Density', ylim = c(-0.001,0.20), xlab = 'Percent Free Throws Made', lwd = 2)

a <- 4; b <- 4
lines(x, KDE(x,h.bayes(x,ft1,a,b),ft1), lty = 2, lwd = 2, col="red")

a <- 1; b <- 1
lines(x, KDE(x,h.bayes(x,ft1,a,b),ft1), lty = 3, lwd = 2, col = "blue")
legend('topleft',bty='n',lty=c(3,1,2), col = c("blue","black","red"), lwd = 2,
       legend=c('Alpha = 1, Beta = 1','Alpha = 2, Beta = 2','Alpha = 4, Beta = 4'), seg.len=4, cex=1)

### Bandwidth Values for Points Scored
#Try 3 different parameters for h
#1. a = 2, b = 2
#2. a = 4, b = 4
#3. a = 1, b = 1
a <- 2; b <- 2
plot(x, h.bayes(x,ft1,a,b), type = 'l', main = "FT KDE, Bandwidth Length, Alpha = 2, Beta = 2",
     ylab = 'Bandwidth', xlab = 'Percent Free Throws Made', lwd = 2)

a <- 4; b <- 4
plot(x, h.bayes(x,ft1,a,b), main = "FT KDE, Bandwidth Length, Alpha = 4, Beta = 4",
     ylab = 'Bandwidth', xlab = 'Percent Free Throws Made', lty = 2, lwd = 2, col="red", type = 'l')

a <- 1; b <- 1
plot(x, h.bayes(x,ft1,a,b), main = "FT KDE, Bandwidth Length, Alpha = 1, Beta = 1",
     ylab = 'Bandwidth', xlab = 'Percent Free Throws Made', lty = 3, lwd = 2, col = "blue", type = 'l')

###########################################

### Group Data By Decades
h1 <- A.sub(A2$o_ftm,1946:1955)/A.sub(A2$o_fta,1946:1955)*100
h2 <- A.sub(A2$o_ftm,1956:1965)/A.sub(A2$o_fta,1956:1965)*100
h3 <- A.sub(A2$o_ftm,1966:1975)/A.sub(A2$o_fta,1966:1975)*100
h4 <- A.sub(A2$o_ftm,1976:1985)/A.sub(A2$o_fta,1976:1985)*100
h5 <- A.sub(A2$o_ftm,1986:1995)/A.sub(A2$o_fta,1986:1995)*100
h6 <- A.sub(A2$o_ftm,1996:2005)/A.sub(A2$o_fta,1996:2005)*100

### Get Estimated Density for each Decade
x <- seq(58,84,.1); l <- length(x)
a <- 2; b <- 2
m1 <- KDE(x,h.bayes(x,h1,a,b),h1)
m2 <- KDE(x,h.bayes(x,h2,a,b),h2)
m3 <- KDE(x,h.bayes(x,h3,a,b),h3)
m4 <- KDE(x,h.bayes(x,h4,a,b),h4)
m5 <- KDE(x,h.bayes(x,h5,a,b),h5)
m6 <- KDE(x,h.bayes(x,h6,a,b),h6)
m <- c(m1,m2,m3,m4,m5,m6)

###Decade labels
yr <- c(rep("`46-`55",l),rep("`56-`65",l),rep("`66-`75",l),rep("`76-`85",l),rep("`86-`95",l),rep("`96-`05",l))
plot_ly(y = rep(x,6), z = m, x = yr, type = "scatter3d", mode = "lines", split = yr) %>%
  layout(
    title = "Estimated Percent Free Throws Made Density - Alpha = 2, Beta = 2",
    scene = list(
      yaxis = list(title = "Percent Free Throws Made"),
      xaxis = list(title = "Years"),
      zaxis = list(title = "Density")
    ))

