# Title     : AdaBoost.M1 with kNN as a weak learner
# Created by: Valerii Zuev
# Created on: 12/12/2020

library(types) # type hints
library(dplyr) # working with dataframes
library(pryr) # for `partial` (~ functools.partial in Python)

#' Weighted k nearest neighbors multiclass classifier
#' @param x input point (a list of real numbers)
#' @param train_data data.frame with train samples:
#' train_data.x - input vectors (each is a list of the same length as `x`)
#' train_data.y - class labels ( each is a factor)
#' train_data.w - weights (each is a real number, typically between 0 and 1)
#' @param k tuning parameter (number of nearest points to take into account)
#' @returns A result of a weighted kNN classifier - a class label for `x`
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
  closest_points <- train_data %>% slice_min(remoteness, n = k) # select `k` rows with lowest `remoteness`
  possible_classes <- unique(closest_points$y)
  classes_probabilities <- lapply(possible_classes, function(class) {
    closest_points %>%
      filter(y == class) %>%
      select(w) %>%
      sum # summarize all contributions of all points with appropriate class label
  })
  return(possible_classes[which.max(classes_probabilities)])
}

#' AdaBoost M1 for k nearest neighbors (multi-class classification)
#' @param train_data data.frame with samples:
#' train_data.x - each cell is a list (feature vector)
#' train_data.y - corresponding class labels (factors)
#' @param k tuning parameter for kNN (see reference for `knn_w`)
#' @param m tuning parameter for AdaBoost (number of iterations)
#' @param extended_return if TRUE, returns not a function, but
#' a data.frame with dataset + weights of points for each classifier
#' @returns if `extended_return` == FALSE:
#' function(x = ? list) - a trained classifier. `x` is a vector of the same length as each of `train_data.x`
#' otherwise: a data.frame
knn_adaboost <- function(train_data = ? data.frame, k = ? integer, m = ? integer, extended_return = F) {
  train_data$w <- 1 / nrow(train_data) # initialize weights
  classifiers <- list()
  classifiers_weights <- list()
  classifiers_params <- train_data
  err_threshold <- 1e-5
  for (i in 1:m) {
    weak_classifier <- partial(knn_w, train_data = train_data, k = k, .lazy = F)
    train_data$prediction <- lapply(seq_len(nrow(train_data)), function(i) weak_classifier(unlist(train_data$x[i]))) %>% unlist
    train_data <- train_data %>%
      mutate(contrib = (y != prediction) * w)
    err <- sum(train_data$contrib) / sum(train_data$w)
    alpha <- log((1 - err) / err)

    classifiers_params[[paste0("w=", round(alpha, 2))]] <- train_data$w # remember weights for extended_return
    classifiers_params[[paste0("ans_c", i)]] <- as.factor(train_data$prediction) # remember predictions for extended_return

    classifiers <- classifiers %>% append(weak_classifier)
    if (err < err_threshold) { # this is good
      classifiers_weights <- classifiers_weights %>% append(10000) # use a big weight & stop process
      break
    }
    if (err > 1 - err_threshold) { # this is strange
      classifiers_weights <- classifiers_weights %>% append(0) # do not use this classifier & stop process
      break
    }
    classifiers_weights <- classifiers_weights %>% append(alpha)
    train_data <- train_data %>% mutate(w = w * exp(alpha * (y != prediction))) # recalculating data weights
    train_data <- train_data %>% mutate(w = w / sum(w))
  }
  classifiers <- unlist(classifiers)
  classifiers_weights <- unlist(classifiers_weights)

  classifier_strong <- function(x = ? list) {
    classifiers_answers <- lapply(classifiers, function(classifier) classifier(x))
    classes <- unique(classifiers_answers)
    classes_weights <- lapply(classes, function(class) {
      classifiers_weights[classifiers_answers == class] %>% sum
    })
    return(classifiers_answers[[which.max(classes_weights)]])
  }
  if (!extended_return) return(classifier_strong)
  return(classifiers_params)
}
