# Title     : AdaBoost for `vehicle` dataset
# Created by: Valerii Zuev
# Created on: 12/7/2020

library(adabag) # AdaBoost
library(mlbench) # Vehicle dataset
library(rpart) # decision trees

data(Vehicle)
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
library(here)
source(here("r/ml/boosting", "knn_adaboost.R"))
# TODO

