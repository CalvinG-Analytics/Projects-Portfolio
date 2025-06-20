#Calvin Guan
#MA 578 Final Project New Codes
### Import

library(here)

#setwd(here::here("ClassProjects\\BayesianBandwidth\\codes"))

source("LibFuncs.R")

#############################

A0 <- read.csv(here::here("team_season.txt"), header = 1)
A1 <- A0[A0$leag=='N',] ; A1[A1==0] <- NA
A2 <- A1[,c(2,4:18,34:36)]

###########################################
### Group Data By Decades

g1 <- A.sub(A2$o_pts,1946:1955)
g2 <- A.sub(A2$o_pts,1956:1965)
g3 <- A.sub(A2$o_pts,1966:1975)
g4 <- A.sub(A2$o_pts,1976:1985)
g5 <- A.sub(A2$o_pts,1986:1995)
g6 <- A.sub(A2$o_pts,1996:2005)

