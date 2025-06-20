#Calvin Guan
#MA 578 Final Project New Codes
### Libraries & Functions

### libraries
library(plotly)
library(plyr)
library(magrittr)
library(here)

### functions

#Substract to years
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

#Kernel Density Estimation using Bayesian Bandwidth and Gausian Kernel
KDE <- function(x,h,X){
  n <- length(X); l <- length(x); R <- numeric(l)
  for (i in 1:l){
    R[i] <- sum(dnorm((X-x[i])/h[i]))/(n*h[i])
  } ; R
}
