# Title     : AdaBoost for `vehicle` dataset
# Created by: Valerii Zuev
# Created on: 12/7/2020

library(adabag) # AdaBoost
library(mlbench) # Vehicle dataset
library(rpart) # decision trees

library(here)
library(tidyverse) # tidyr, dplyr, ggplot2, ...
source(here("r/ml/boosting/knn_adaboost.R"))

data(Vehicle)
set.seed(1) # for reproducibility
n_samples <- length(Vehicle[, 1])
train_indices <- sample(1:n_samples, 2 * n_samples / 3)
test_indices <- -train_indices
max_iter <- 25
max_tree_depth <- 5

Vehicle.rpart <- rpart(Class ~ ., data = Vehicle[train_indices,], maxdepth = max_tree_depth)
Vehicle.rpart.predictions <- predict(Vehicle.rpart, newdata = Vehicle[test_indices,], type = "class")
tb <- table(Vehicle.rpart.predictions, Vehicle$Class[test_indices])
Vehicle.rpart.error <- 1 - sum(diag(tb)) / sum(tb)

Vehicle.adaboost <- boosting(Class ~ ., data = Vehicle[train_indices,], mfinal = max_iter, maxdepth = max_tree_depth)
Vehicle.adaboost.pred <- predict.boosting(Vehicle.adaboost, newdata = Vehicle[test_indices,])

Vehicle.rpart.error
Vehicle.adaboost.pred$error

# building AdaBoost for kNN


vehicle_train <- data.frame(
  x = I(Vehicle[train_indices,] %>%
          select(-Class) %>%
          apply(1, as.list)),
  y = Vehicle[train_indices,]$Class)
vehicle_test <- Vehicle[test_indices,] %>%
  select(-Class) %>%
  apply(1, as.list)
system.time(Vehicle.knn_adaboost <- knn_adaboost(vehicle_train, k = 10, m = 5)) # this runs for a minute
Vehicle.knn_adaboost.pred <- lapply(vehicle_test, function(x) Vehicle.knn_adaboost(unlist(x))) %>% unlist
Vehicle.test_y <- Vehicle[test_indices,] %>%
  select(Class) %>%
  as.list %>%
  unlist

tb_knn_adaboost <- table(Vehicle.knn_adaboost.pred, Vehicle.test_y)
Vehicle.knn_adaboost.error <- 1 - sum(diag(tb_knn_adaboost)) / sum(tb_knn_adaboost)

vehicle_train$w <- 1 / nrow(vehicle_train)
Vehicle.knn <- purrr::partial(knn_w, train_data = vehicle_train, k = 10)
Vehicle.knn.pred <- lapply(vehicle_test, function(x) Vehicle.knn(unlist(x))) %>% unlist

tb_knn <- table(Vehicle.knn.pred, Vehicle.test_y)
Vehicle.knn.error <- 1 - sum(diag(tb_knn)) / sum(tb_knn)

Vehicle.knn_adaboost.error
Vehicle.knn.error
Vehicle.adaboost.pred$error
Vehicle.rpart.error
