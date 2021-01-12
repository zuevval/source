# Title     : Classification of mammography data
# Created by: Valerii Zuev
# Created on: 1/12/2021

library(here) # relative paths
library(types) # type hints
library(tidyverse) # dplyr, ggplot2, ...
library(kknn) # k nearest neighbours
library(e1071) # svm
library(adabag) # bagging
library(cluster) # k medoids (clara)

data_dir <- "r/ml/finale/data"
abs_path <- function(path) here(data_dir, path) # path relative to the Git root

data <- abs_path("mammographic_masses.data") %>%
  read.csv(stringsAsFactors = F, header = F)
colnames(data) <- c("bi_rads", "age", "shape", "margin", "density", "severity")
data <- data %>%
  mutate(across(everything(), as.integer)) %>%
  mutate(severity = as.factor(severity)) %>%
  drop_na
head(data)

set.seed(0)
data.n_samples <- nrow(data)
data.test_indices <- sample(seq_len(data.n_samples), size = round(data.n_samples * .25))
data.train <- data[-data.test_indices,]
data.test <- data[data.test_indices,]

# -----------
# --- kNN ---
# -----------

knn.eval_knn <- function(k = ? integer, kernel = ? character, distance = ? numeric) {
  data.kknn <- kknn(severity ~ ., data.train, data.test, distance = distance, kernel = kernel, k = k)
  data.contingency_table <- table(data.test$severity, fitted(data.kknn))
  1 - sum(diag(data.contingency_table)) / sum(data.contingency_table)
}

knn.params <- expand.grid(k = c(1, 2, 7, 15),
                          kernel = c("rectangular", "triangular", "epanechnikov", "biweight", "gaussian"),
                          distance = 1:6)

knn.params$test_err <- mapply(knn.eval_knn, knn.params$k, as.character(knn.params$kernel), knn.params$distance)
print(knn.params[which.min(knn.params$test_err),]) # kNN parameters that result in the lowest test err

knn.params <- knn.params %>% mutate(k = as.factor(k), distance = as.factor(distance))
devnull <- unique(knn.params$k) %>% lapply(function(k_value = ? integer) {
  ggplot(data = knn.params %>% filter(k == k_value), aes(x = kernel, y = test_err, group = distance, fill = distance)) +
    geom_bar(stat = "identity", position = position_dodge()) +
    ylim(0, .25) +
    ggtitle(paste("kNN test error for different kernels, k =", k_value)) +
    theme_bw() +
    theme(plot.title = element_text(hjust = .5))
  ggsave(abs_path(paste0("knn_k", k_value, ".png")), scale = .3)
})


# -----------
# --- SVM ---
# -----------

svm.err_rate <- function(expected = ? factor, actual = ? factor) {
  result <- (expected != actual) %>%
    as.integer %>%
    sum
  result / length(expected)
}

svm.eval <- function(kernel = ? character, ...) {
  data.svm <- svm(severity ~ ., data = data.train, type = "C-classification", kernel = kernel, ...)
  svm.err_rate(predict(data.svm, data.test), data.test$severity)
}

svm.polynom_params <- data.frame(degree = 1:15)
svm.polynom_params$test_err <- svm.polynom_params$degree %>%
  lapply(function(degree = ? interger) svm.eval(kernel = "polynomial", degree = degree))

ggplot(svm.polynom_params %>% mutate(test_err = as.numeric(test_err)), aes(x = degree, y = test_err)) +
  geom_line() +
  ggtitle("SVM: test error rate with polynomial kernel") +
  theme_bw() +
  theme(plot.title = element_text(hjust = .5))
ggsave(abs_path("svm_polynomial.png"), scale = .3)

svm.params <- expand.grid(kernel = c("polynomial", "radial", "sigmoid"), gamma = c(.001, .01, .1, 1, 10, 100))
svm.params$test_err <- mapply(function(kernel = ? character, gamma = ? numeric) {
  if (kernel == "polynomial")
    svm.eval(kernel = kernel, gamma = gamma, degree = 1)
  else
    svm.eval(kernel = kernel, gamma = gamma)
}, kernel = svm.params$kernel, gamma = svm.params$gamma)

ggplot(data = svm.params %>% mutate(gamma = as.factor(gamma)), aes(x = kernel, y = test_err, fill = gamma)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  ggtitle("SVM: test error rate with different kernels") +
  theme_bw() +
  theme(plot.title = element_text(hjust = .5))
ggsave(abs_path("svm.png"), scale = .3)

# ---------------
# --- Bagging ---
# ---------------

bagging.params <- expand.grid(minsplit = 1:10, cp = .0005 * 1:4)
bagging.params$test_err <- mapply(function(minsplit = ? integer, cp = ? numeric) {
  pred <- bagging(severity ~ ., data = data.train, minsplit = minsplit, cp = cp) %>% predict.bagging(newdata = data.test)
  pred$error
}, bagging.params$minsplit, bagging.params$cp)

ggplot(data = bagging.params %>% mutate(cp = as.factor(cp), minsplit = as.factor(minsplit)) %>% filter(minsplit %in% c(2, 4, 6, 8)), aes(x = minsplit, y = test_err, fill = cp)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  ggtitle("Bagging: performance with different parameters") +
  theme_bw() +
  theme(plot.title = element_text(hjust = .5))
ggsave(abs_path("bagging.png"), scale = .3)

# -----------------------------
# --- Clustering: k medoids ---
# -----------------------------

clara.params <- expand.grid(metric = c("euclidean", "manhattan", "jaccard"), stand = c(T, F))
clara.params$misclass <- mapply(function(metric = ? chraracter, stand = ? bool) {
  predicted_clusters <- clara(data %>% select(-severity), k = 2, stand = stand, metric = as.character(metric))$clustering
  n_correct <- table(data$severity, predicted_clusters) %>%
    unlist %>%
    sort %>%
    tail(3) %>%
    sum
  1 - n_correct / length(data$severity)
}, clara.params$metric, clara.params$stand)

ggplot(data = clara.params, aes(x = metric, y = misclass, fill = stand, color = stand)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  ggtitle("clustering error (k medoids) with different metrics") +
  theme_bw() +
  labs(fill = "standartized", color = "standartized") +
  theme(plot.title = element_text(hjust = .5), legend.title =)
ggsave(abs_path("clara_err.png"), scale = .3)
