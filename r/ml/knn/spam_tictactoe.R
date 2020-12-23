# Title     : kNN
# Created by: Valerii Zuev
# Created on: 12/15/2020

library(kknn)

data(iris)

n_samples <- nrow(iris)
pairs(iris[1:4], col = c("blue", "red", "black")) # produce a matrix of scatter plots
