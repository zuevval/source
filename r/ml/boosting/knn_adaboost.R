# Title     : AdaBoost.M1 with kNN as a weak learner
# Created by: Valerii Zuev
# Created on: 12/12/2020

library(types) # type hints
library(dplyr) # working with dataframes

#' Weighted k nearest neighbors two-class classifier
#' @param x input point (a list of real numbers)
#' @param train_data data.frame with train samples:
#' train_data.x - input vectors (each is a list of the same length as `x`)
#' train_data.y - class labels ( each is an integer equal to -1 or 1)
#' train_data.w - weights (each is a real number between 0 and 1)
#' @return A result of a weighted kNN classifier
#'
#' @details This could be relatively easily generalized in case of multi-class classification, but I do not needed it
#' @examples
#' knn_w(
#'    x = c(0, 1),
#'    train_data = data.frame(
#'      x = I(list(c(-1, 1), c(1, 1))),
#'      y = c(-1, 1),
#'      w = c(.5, .5)),
#'    k = 2
#' )
knn_w <- function(x = ? list, train_data = ? data.frame, k = ? integer) {
  train_data$remoteness <- train_data$x %>% # `remoteness` = eucledian distance from `x`
    lapply(function(x1 = ? list) dist(rbind(x1, x))[[1]]) %>%
    unlist
  train_data %>%
    slice_min(remoteness, n = k) %>% # select `k` rows with lowest `remoteness`
    transmute(contrib = y * w) %>% # contribution = class label (-1 or 1) * weight
    sum %>% # summarize all contributions
    sign # return signum (-1 or 1)
}
