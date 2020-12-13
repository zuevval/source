# Title     : testint knn_adaboost.R
# Created by: Valerii Zuev
# Created on: 12/12/2020

library(types) # type hints
library(here) # relative paths
library(testthat) # unit testing framework

abs_path <- function(filename = ? character) here("r/ml/boosting", filename)
source(abs_path("knn_adaboost.R"))

test_that("knn, 1 feature", {
  train_data <- data.frame(
    x = c(-2, -1, 1, 2),
    y = c(-1, -1, 1, 1),
    w = c(.25, .25, .25, .25)
  )
  result <- knn_w(1.5, train_data = train_data, k = 2)
  expect_equal(result, 1)
})

test_that("knn, 2 features", {
  train_data <- data.frame(
    x = I(list(c(-2, -1), c(-1, -2), c(1, 2), c(2, 1))),
    y = c(-1, -1, 1, 1),
    w = c(.25, .25, .25, .25)
  )
  result <- knn_w(c(1, 1), train_data = train_data, k = 2)
  expect_equal(result, 1)
})

test_that("AdaBoost, 1 feature", {
  train_data <- data.frame(
    x = c(-2, -1, 0, 1, 2),
    y = c(-1, -1, 1, -1, -1) # only one positive example
  )
  result <- knn_adaboost(train_data = train_data, k = 2, m = 10)
  expect_equal(result(0), 1)
  expect_equal(result(1), -1)
})

test_that("AdaBoost, 2 features", {
  train_data <- data.frame(
    x = I(list(c(-.5, -1), c(-1, -.5), c(1, 1))),
    y = c(-1, -1, 1)
  )
  result <- knn_adaboost(train_data = train_data, k = 2, m = 10)
  expect_equal(result(c(-1, 1)), 1)
})
