# Title     : Bayesian classificator trained on generated dataset
# Created by: Valerii Zuev
# Created on: 12/2/2020

library(types) # type annotations
library(here) # relative paths
library(ggplot2) # visualization
library(e1071) # Bayesian classifier

set.seed(0) # for reproducibility
abs_path <- function(path) here("r/ml/lab1bayes", path) # path relative to the Git root

c1_samples <- 50 # number of elements in class c1
c2_samples <- 50
n_samples <- c1_samples + c2_samples

generated_data <- data.frame(
  x1 = c(rnorm(c1_samples, mean = 10, sd = 4), rnorm(c2_samples, mean = 20, sd = 3)),
  x2 = c(rnorm(c1_samples, mean = 14, sd = 4), rnorm(c2_samples, mean = 18, sd = 3)),
  class_label = c(rep("c1", c1_samples), rep("c2", c2_samples)),
  stringsAsFactors = TRUE
)

ggplot(data = generated_data) +
  geom_point(mapping = aes(x = x1, y = x2, color = class_label, shape = class_label)) +
  xlab("x1") +
  ylab("x2") +
  ggtitle("Generated data (two classes)") +
  theme(plot.title = element_text(hjust = 0.5))

ggsave(abs_path("generated_data.png"), scale = .3)

shuffled_data <- generated_data[order(runif(n_samples)),]
n_train <- as.integer(.8 * n_samples)
data_train <- shuffled_data[1:n_train,]
data_test <- shuffled_data[(n_train + 1):n_samples,]

classifier <- naiveBayes(class_label ~ ., data = data_train) # building a hypothesis
predicted <- predict(classifier, data_test) # evaluating the hypothesis
table(predicted, data_test$class_label)
