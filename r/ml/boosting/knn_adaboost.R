# Title     : AdaBoost.M1 with kNN as a weak learner
# Created by: Valerii Zuev
# Created on: 12/12/2020

library(types) # type hints
library(dplyr) # working with dataframes
library(pryr) # for `partial` (~ functools.partial in Python)

#' Weighted k nearest neighbors two-class classifier
#' @param x input point (a list of real numbers)
#' @param train_data data.frame with train samples:
#' train_data.x - input vectors (each is a list of the same length as `x`)
#' train_data.y - class labels ( each is an integer equal to either -1 or 1)
#' train_data.w - weights (each is a real number, typically between 0 and 1)
#' @param k tuning parameter (number of nearest points to take into account)
#' @returns A result of a weighted kNN classifier - a class label for `x` (-1 or 1)
#'
#' @details This could be relatively easily generalized in case of multi-class classification, but I do not need it
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

#' AdaBoost M1 for k nearest neighbors (two-class classification)
#' @param train_data data.frame with samples:
#' train_data.x - each cell is a list (feature vector)
#' train_data.y - corresponding class labels (-1 or 1)
#' @param k tuning parameter for kNN (see reference for `knn_w`)
#' @param m tuning parameter for AdaBoost (number of iterations)
#' @returns function(x = ? list) - a trained classifier. `x` is a vector of the same length as each of `train_data.x`
knn_adaboost <- function(train_data = ? data.frame, k = ? integer, m = ? integer) {
  train_data$w <- 1 / nrow(train_data) # initialize weights
  classifiers <- list()
  classifiers_weights <- list()
  err_threshold <- 1e-5
  for (i in 1:m) {
    weak_classifier <- partial(knn_w, train_data = train_data, k = k, .lazy = F)
    train_data$prediction <- lapply(seq_len(nrow(train_data)), function(i) weak_classifier(unlist(train_data$x[i]))) %>% unlist
    train_data <- train_data %>%
      mutate(contrib = (y != prediction) * w)
    err <- sum(train_data$contrib) / sum(train_data$w)
    alpha <- log((1 - err) / err)

    classifiers <- classifiers %>% append(weak_classifier)
    if (err < err_threshold) {
      classifiers_weights <- classifiers_weights %>% append(10000) # use a big weight & stop process
      break
    }
    if (err > 1 - err_threshold) {
      classifiers_weights <- classifiers_weights %>% append(0) # do not use this classifier & stop process
      break
    }
    classifiers_weights <- classifiers_weights %>% append(alpha) # if |alpha| is too high, use a fixed number instead
    train_data <- train_data %>% mutate(w = w * exp(alpha * (y != prediction))) # recalculating data weights
    train_data <- train_data %>% mutate(w = w / sum(w))
  }
  function(x = ? list) {
    result <- 0
    for (i in seq_along(classifiers)) {
      result <- result + classifiers[[i]](x) * classifiers_weights[[i]]
    }
    return(sign(result))
  }
}
