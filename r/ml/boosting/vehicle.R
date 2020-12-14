# Title: AdaBoost for `vehicle` dataset
# Created by: Valerii Zuev
# Created on: 12/7/2020

library(adabag) # AdaBoost
library(mlbench) # Vehicle dataset
library(rpart) # decision trees

library(here)
library(tidyverse) # tidyr, dplyr, ggplot2, ...
source(here("r/ml/boosting/knn_adaboost.R"))

data(Vehicle)
set.seed(2) # for reproducibility
n_samples <- nrow(Vehicle)
train_indices <- sample(1:n_samples, .7 * n_samples)
test_indices <- -train_indices
max_tree_depth <- 5

# Building a single random tree classifier

Vehicle.rpart <- rpart(Class ~ ., data = Vehicle[train_indices,], maxdepth = max_tree_depth)
Vehicle.rpart.predictions <- predict(Vehicle.rpart, newdata = Vehicle[test_indices,], type = "class")
tb <- table(Vehicle.rpart.predictions, Vehicle$Class[test_indices])
Vehicle.rpart.error <- 1 - sum(diag(tb)) / sum(tb)
Vehicle.rpart.error

# Building and evaluating several AdaBoost'ed random tree classifiers

adaboost_errors <- data.frame(n_trees = numeric(0), error_train = numeric(0), error_test = numeric(0))
for (max_iter in seq(from = 1, to = 301, by = 10)) {
  print(max_iter)
  Vehicle.adaboost <- boosting(Class ~ ., data = Vehicle[train_indices,], mfinal = max_iter, maxdepth = max_tree_depth)
  pred_test <- predict.boosting(Vehicle.adaboost, newdata = Vehicle[test_indices,])
  pred_train <- predict.boosting(Vehicle.adaboost, newdata = Vehicle[train_indices,])
  adaboost_errors[nrow(adaboost_errors) + 1,] <- list(max_iter, pred_train$error, pred_test$error)
}
ggplot(data = adaboost_errors) +
  geom_line(mapping = aes(x = n_trees, y = error_train, color = "blue")) +
  geom_line(mapping = aes(x = n_trees, y = error_test, color = "red")) +
  scale_color_discrete(name = "error", labels = c("train", "test")) +
  ggtitle("AdaBoost.M1 performance (decision trees as weak learners)") +
  ylab("error (share of the dataset size)") +
  xlab("number of trees") +
  theme_bw()


# building AdaBoost for kNN

vehicle_train <- data.frame(
  x = I(Vehicle[train_indices,] %>%
          select(-Class) %>%
          apply(1, as.list)),
  y = Vehicle[train_indices,]$Class)
vehicle_test <- Vehicle[test_indices,] %>%
  select(-Class) %>%
  apply(1, as.list)
system.time(Vehicle.knn_adaboost <- knn_adaboost(vehicle_train, k = 300, m = 5)) # this runs for a minute
Vehicle.knn_adaboost.pred <- lapply(vehicle_test, function(x) Vehicle.knn_adaboost(unlist(x))) %>% unlist
Vehicle.test_y <- Vehicle[test_indices,] %>%
  select(Class) %>%
  as.list %>%
  unlist

tb_knn_adaboost <- table(Vehicle.knn_adaboost.pred, Vehicle.test_y)
Vehicle.knn_adaboost.error <- 1 - sum(diag(tb_knn_adaboost)) / sum(tb_knn_adaboost)

vehicle_train$w <- 1 / nrow(vehicle_train)
Vehicle.knn <- purrr::partial(knn_w, train_data = vehicle_train, k = 300)
Vehicle.knn.pred <- lapply(vehicle_test, function(x) Vehicle.knn(unlist(x))) %>% unlist

tb_knn <- table(Vehicle.knn.pred, Vehicle.test_y)
Vehicle.knn.error <- 1 - sum(diag(tb_knn)) / sum(tb_knn)

Vehicle.knn_adaboost.error
Vehicle.knn.error
Vehicle.rpart.error
