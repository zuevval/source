# Title     : Logistic regression trained on partially labeled data
# Created by: Valerii Zuev
# Created on: 1/24/2021

library(here) # relative paths
library(tidyverse)

abs_path <- function(path) here("r/partially_labeled", path) -> character # path relative to the Git root

plot_dataset <- function(data = ? data.frame, title = ? character, filename = ? character) {
  ggplot(data = data, aes(x1, x2, color = y, shape = y)) +
    geom_point() +
    ggtitle(title) +
    theme_classic() +
    theme(plot.title = element_text(hjust = 0.5))
  ggsave(abs_path(filename), scale = .3)
}

eval_logreg <- function(data.train.part = ? data.frame, data.test = ? data.frame){
  data.logreg <- glm(y ~ x1 + x2, data = data.train.part, family = "binomial")
  data.train.part$predict_probab <- data.logreg$fitted.values
  data.train.part$predict <- (data.train.part$predict_probab >= .5) %>%
    as.integer %>%
    as.factor

  data.test$predict_probab <- predict(data.logreg, newdata = data.test, type = "response")
  data.test$predict <- (data.test$predict_probab >= .5) %>%
    as.integer %>%
    as.factor
  data.tbl <- table(data.test$predict, data.test$y)
  1 - sum(diag(data.tbl)) / sum(data.tbl)
} -> numeric

eval_part_labeled_learning <- function(data = ? data.frame, title = ? character) {
  set.seed(0)
  data <- data[sample(nrow(data)),] # shuffle the data
  n_samples <- nrow(data)
  data.train <- data[1:floor(.6 * n_samples),]
  data.validate <- data[floor(.6 * n_samples + 1):floor(.8 * n_samples),]
  data.test <- data[floor(.8 * n_samples + 1):n_samples,]

  stats <- data.frame(fraction = .05 * 1:10)
  stats$test_err <- stats$fraction %>%
    lapply(function(fraction = ? numeric) {
      n_train_part <- floor(nrow(data.train) * fraction)
      data.train.part <- data.train[1:n_train_part,]
      eval_logreg(data.train.part = data.train.part, data.test = data.test)
    } -> numeric) %>%
    unlist

  ggplot(data = stats, aes(x = fraction, y = test_err)) +
    geom_line() +
    ggtitle(paste("error on test data:", title)) +
    theme_classic() +
    theme(plot.title = element_text(hjust = 0.5))
  ggsave(abs_path(paste0(title, "_stats.png")), scale = .3)

  # data "without labels"
  n_train <- nrow(data.train)
  n_train_part <- 3 # initially using 3 samples to fit the model
  data.train.part <- data.train[1:n_train_part,]
  print(eval_logreg(data.train.part = rbind(data.train.part, data.validate), data.test = data.test))
  test_err <- eval_logreg(data.train.part = data.train.part, data.test = data.test)
  print(test_err)
  validate_err <- eval_logreg(data.train.part = data.train.part, data.test = data.validate)
  stats_added <- data.frame(added_samples = (n_train_part + 1):n_train,
                            test_err = test_err)
  for (i in stats_added$added_samples) {
    data.logreg <- glm(y ~ x1 + x2, data = data.train.part, family = "binomial")
    data.train$y[i] <- (predict(data.logreg, newdata = data.train.part, type = "response") > .5) %>%
      as.integer %>%
      as.factor
    data.train.part_new <- rbind(data.train.part, data.train[i,])
    validate_err_new <- eval_logreg(data.train.part = data.train.part_new, data.test = data.validate)
    if (validate_err_new < validate_err) {
      data.train.part <- data.train.part_new
      validate_err <- validate_err_new
    }
    stats_added$test_err[i - n_train_part] <- eval_logreg(data.train.part = data.train.part, data.test = data.test)
  }
  print(stats_added$test_err[n_train - n_train_part])

  ggplot(data = stats_added, aes(x = added_samples, y = test_err)) +
    geom_line() +
    ggtitle(paste("error on test data:", title)) +
    theme_classic() +
    theme(plot.title = element_text(hjust = 0.5))
  ggsave(abs_path(paste0(title, "_stats_added.png")), scale = .3)
}

set.seed(0) # for reproducibility

n_elem <- 70
art_data <- rbind(data.frame(x1 = rnorm(n_elem, mean = .5, sd = .5), x2 = rnorm(n_elem, mean = .7, sd = 1.5), y = rep(1, n_elem)),
                  data.frame(x1 = rnorm(n_elem, mean = -.7, sd = .5), x2 = rnorm(n_elem, mean = -1, sd = 1.5), y = rep(0, n_elem))) %>%
  mutate(y = as.factor(y))
plot_dataset(data = art_data, title = " data generated from 2 normal distributions ", filename = "art_data.png")
suppressWarnings(eval_part_labeled_learning(data = art_data, title = "normal"))

set.seed(0) # for reproducibility
n_elem <- 60
art_data2 <- rbind(data.frame(x1 = runif(n_elem, min = 0, max = 1), x2 = runif(n_elem, min = -.1, max = 1), y = rep(1, n_elem)),
                   data.frame(x1 = runif(n_elem, min = 0, max = 1), x2 = runif(n_elem, min = -1, max = .1), y = rep(0, n_elem))) %>%
  mutate(y = as.factor(y))
plot_dataset(data = art_data2, title = " data generated from 2 uniform distributions ", filename = "art_data_unif.png")
suppressWarnings(eval_part_labeled_learning(data = art_data2, title = "uniform"))
