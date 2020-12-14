# Title     : Bagging & AdaBoost.M1 for Glass data
# Created by: Valerii Zuev
# Created on: 12/14/2020

library(rpart)
library(mlbench)
library(adabag)

library(here)
library(tidyverse) # tidyr, dplyr, ggplot2, ...
source(here("r/ml/boosting/knn_adaboost.R"))

data(Glass)
set.seed(2) # for reproducibility
n_samples <- nrow(Glass)
train_indices <- sample(1:n_samples, .7 * n_samples)
test_indices <- -train_indices
max_tree_depth <- 5

# Building a single random tree classifier

Glass.rpart <- rpart(Type ~ ., data = Glass[train_indices,], maxdepth = max_tree_depth)
Glass.rpart.predictions <- predict(Glass.rpart, newdata = Glass[test_indices,], type = "class")
tb <- table(Glass.rpart.predictions, Glass$Type[test_indices])
Glass.rpart.error <- 1 - sum(diag(tb)) / sum(tb)
Glass.rpart.error

# Building and evaluating several AdaBoost'ed random tree classifiers

bagging_errors <- data.frame(n_trees = numeric(0), error_train = numeric(0), error_test = numeric(0))
for (max_iter in seq(from = 1, to = 301, by = 10)) {
  print(max_iter)
  Glass.bagging <- bagging(Type ~ ., data = Glass[train_indices,], mfinal = max_iter, maxdepth = max_tree_depth)
  pred_test <- predict.bagging(Glass.bagging, newdata = Glass[test_indices,])
  pred_train <- predict.bagging(Glass.bagging, newdata = Glass[train_indices,])
  bagging_errors[nrow(bagging_errors) + 1,] <- list(max_iter, pred_train$error, pred_test$error)
}
ggplot(data = bagging_errors) +
  geom_line(mapping = aes(x = n_trees, y = error_train, color = "blue")) +
  geom_line(mapping = aes(x = n_trees, y = error_test, color = "red")) +
  scale_color_discrete(name = "error", labels = c("train", "test")) +
  ggtitle("Bagging performance (decision trees as weak learners)") +
  ylab("error (share of the dataset size)") +
  xlab("number of trees") +
  theme_bw()

# building AdaBoost for kNN

glass_train <- data.frame(
  x = I(Glass[train_indices,] %>%
          select(-Type) %>%
          apply(1, as.list)),
  y = Glass[train_indices,]$Type)
glass_test <- Glass[test_indices,] %>%
  select(-Type) %>%
  apply(1, as.list)
system.time(Glass.knn_adaboost <- knn_adaboost(glass_train, k = 50, m = 10))
Glass.knn_adaboost.pred <- lapply(glass_test, function(x) Glass.knn_adaboost(unlist(x))) %>% unlist
Glass.test_y <- Glass[test_indices,] %>%
  select(Type) %>%
  as.list %>%
  unlist

tb_knn_adaboost <- table(Glass.knn_adaboost.pred, Glass.test_y)
Glass.knn_adaboost.error <- 1 - sum(diag(tb_knn_adaboost)) / sum(tb_knn_adaboost)
