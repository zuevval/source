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
library(boostr)
library(types)
library(dplyr)

knn_decorator <- function(k = ? integer, learning_set = ? data.frame) {
  print(learning_set)
  learning_input <- learning_set %>% select(-Type)
  learning_responce <- learning_set[, "Type"]
  function(newdata = ? data.frame) {
    class::knn(train = learning_input,
               cl = learning_responce,
               k = k,
               test = newdata)
  }
}

kNN_Estimator <- knn_decorator(5, Glass[, 10:1])
kNN_Estimator(Glass[1:10, 9:1])

boostr::boostWithArcX4(x = knn_decorator,
                       B = 3,
                       data = Glass,
                       metadata = list(learningSet = "learning_set"),
                       .procArgs = list(k = 5),
                       .boostBackendArgs = list(
                         .subsetFormula = formula(Type ~ .))
)

knn_decorator <- function(k = ? integer, learning_set = ? data.frame) {
  print(learning_set)
  learning_input <- learning_set %>% select(-Type)
  learning_responce <- learning_set[, "Type"]
  function(newdata = ? data.frame) {
    class::knn(train = learning_input,
               cl = learning_responce,
               k = k,
               test = newdata)
  }
}


