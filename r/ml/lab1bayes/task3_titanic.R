# Title     : Bayesian classifier for Titanic dataset
# Created by: Valerii Zuev
# Created on: 12/2/2020

library(types) # type hints
library(here) # relative paths
library(tidyverse) # ggplot2, dplyr, ...
library(e1071) # Bayesian classifier
library(glmnet) # LASSO for feature selections
library(plotly) # 3D-plot

set.seed(0) # for reproducibility
read_table <- function(rel_path = ? character) {
  here("r/ml/lab1bayes/data", rel_path) %>% # files were preprocessed (quotation marks & some commas removed)
    read.csv(stringsAsFactors = TRUE) %>%
    select_if(is.numeric) %>%
    na.omit
}
titanic_train <- read_table("titanic_train.csv")
titanic_test <- read_table("titanic_test.csv")

# feature selection. Credit: https://rstatisticsblog.com/data-science-in-action/machine-learning/lasso-regression/
lambda_seq <- 10^seq(2, -2, by = -.1)
x_vars <- model.matrix(Survived ~ ., titanic_train)[, -1]
y_var <- titanic_train$Survived
cv_output <- cv.glmnet(x_vars, y_var,
                       alpha = 1, lambda = lambda_seq,
                       nfolds = 5)
best_lambda <- cv_output$lambda.min
lasso_best <- glmnet(x_vars, y_var, alpha = 1, lambda = best_lambda)
features_coef <- coef(lasso_best)

features_order <- order(abs(features_coef), decreasing = TRUE)
features_selected <- rownames(features_coef)[features_order][2:4] # select top-3 significant features

selected_train <- titanic_train %>%
  select(features_selected, "Survived") %>%
  mutate(Survived = as.factor(Survived))
selected_test <- titanic_test %>% select(features_selected)

classifier <- naiveBayes(Survived ~ ., data = selected_train) # building a hypothesis
selected_test$predicted <- predict(classifier, selected_test)

plot_ly(x = selected_train$Parch,
        y = selected_train$Pclass,
        z = selected_train$SibSp,
        type = "scatter3d",
        mode = "markers",
        color = selected_train$Survived,
        symbols = selected_train$Survived)

plot_ly(x = selected_test$Parch,
        y = selected_test$Pclass,
        z = selected_test$predicted,
        type = "scatter3d",
        mode = "markers",
        color = selected_test$predicted,
        symbols = selected_test$predicted)


