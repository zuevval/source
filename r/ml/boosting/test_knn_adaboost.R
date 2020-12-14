# Title: testint knn_adaboost.R
# Created by: Valerii Zuev
# Created on: 12/12/2020

library(types) # type hints
library(here) # relative paths
library(testthat) # unit testing framework
library(ggplot2)

abs_path <- function(filename = ? character) here("r/ml/boosting", filename)
source(abs_path("knn_adaboost.R"))

test_that("knn, 1 feature", {
  train_data <- data.frame(
    x = c(-2, -1, 1, 2),
    y = c(-1, -1, 1, 1),
    w = c(.25, .25, .25, .25)
  )
  expect_equal(knn_w(1.5, train_data, k = 2), 1)
  expect_equal(knn_w(-1.5, train_data, k = 2), -1)
  expect_equal(knn_w(-.5, train_data, k = 2), -1)
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

test_that("knn, multi-class", {
  train_data <- data.frame(
    x = I(list(c(-3, -2.5), c(-3, -3), c(-2.5, -2.5), c(0, -1), c(-.5, -1.5), c(-.5, -.5), c(2, 3), c(3, 2), c(2.5, 2.5))),
    y = c("a", "a", "a", "b", "b", "b", "c", "c", "c")
  )
  train_data$w <- 1 / nrow(train_data)
  result <- knn_w(c(0, 0), train_data = train_data, k = 3)
  expect_equal(result, "b")
})

test_that("AdaBoost, 1 feature", {
  train_data <- data.frame(
    x = c(-2, -1, 0, 1, 2),
    y = c(-1, -1, 1, -1, -1) # only one positive example
  )
  result <- knn_adaboost(train_data = train_data, k = 2, m = 10)
  result(0)
  expect_equal(result(0), 1)
  expect_equal(result(1), -1)
})

test_that("AdaBoost, 2 features", {
  train_data <- data.frame(
    x = I(list(c(-.5, -1), c(-1, -.5), c(1, 1))),
    y = c(-1, -1, 1)
  )
  result <- knn_adaboost(train_data = train_data, k = 2, m = 10)
  expect_equal(result(c(-1, -1)), -1)
  expect_equal(result(c(1, 1)), 1) # this impossible with k=2 for a usual non-weighted kNN
})

test_that("AdaBoost, multiclass", {
  train_data <- data.frame(
    x = c(1, 2, 3, 4, 5, 6),
    y = c(1, 1, 2, 3, 2, 3)
  )
  result <- knn_adaboost(train_data = train_data, k = 3, m = 10)

  result(3)
  expect_equal(result(1), 1)
  expect_equal(result(2), 1)
  expect_equal(result(3), 2)
  expect_equal(result(6), 3)

})

test_that("AdaBoost, three_samples_to_visualize", {
  train_data <- data.frame(
    x = c(1, 2, 3, 3.5, 4, 5),
    y = c(1, -1, 1, -1, 1, 1)
  )
  plot <- function(k = ? integer, train_data = ? data.table) {
    data_weights <- knn_adaboost(train_data = train_data, k = k, m = 5, extended_return = T) %>% select(-w)
    data_weights$class <- as.factor(data_weights$y)
    data_weights$prediction <- as.factor(data_weights[[4]])
    data_weights$weight <- data_weights[[3]]
    x_offset <- 1.2
    p <- ggplot(data = data_weights) +
      geom_point(mapping = aes(x = x, y = 0, size = weight, shape = class, color = prediction)) +
      annotate("text", x = x_offset, y = -.3, label = colnames(data_weights)[3], color = "#993333", size = 10) +
      geom_point(mapping = aes(x = x, y = -1, size = data_weights[[5]], shape = class, color = as.factor(data_weights[[6]]))) +
      annotate("text", x = x_offset, y = -1.3, label = colnames(data_weights)[5], color = "#993333", size = 10) +
      geom_point(mapping = aes(x = x, y = -2, size = data_weights[[7]], shape = class, color = as.factor(data_weights[[8]]))) +
      annotate("text", x = x_offset, y = -2.3, label = colnames(data_weights)[7], color = "#993333", size = 10) +
      geom_point(mapping = aes(x = x, y = -3, size = data_weights[[9]], shape = class, color = as.factor(data_weights[[10]]))) +
      annotate("text", x = x_offset, y = -3.3, label = colnames(data_weights)[9], color = "#993333", size = 10) +
      scale_size(range = c(3, 20))
    theme(axis.ticks.y = element_blank(),
          axis.text.y = element_blank(),
          axis.title.y = element_blank(),
          plot.background = element_rect(fill = "white"))
    print(p)
    print(data_weights)
  }
  plot(2, train_data)
  plot(3, train_data)
  plot(5, train_data)
})
