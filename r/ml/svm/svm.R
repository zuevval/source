# Title     : Support Vector machine tasks
# Created by: Valerii Zuev
# Created on: 1/5/2021

# preparing workspace

library(e1071) # svm
library(here) # relative paths
library(tidyverse) # dplyr, ggplot2, ...

data_path <- function(filename) here("r/ml/svm/data", filename) # path relative to the Git root
std_img_width <- 4500
std_img_height <- 4500
std_img_dpi <- 600

for (i in 1:6) {
  data.train.var_name <- paste0("data", i, ".train")
  data.test.var_name <- paste0("data", i, ".test")
  data.train.file_name <- paste0("svmdata", i, ".txt")
  data.test.file_name <- paste0("svmdata", i, "test.txt")
  assign(data.train.var_name, data_path(data.train.file_name) %>% read.table(sep = "\t", stringsAsFactors = T))
  if (i != 3 && i != 6) # no test data for svmdata3, svmdata6
    assign(data.test.var_name, data_path(data.test.file_name) %>% read.table(sep = "\t", stringsAsFactors = T))
}

err_rate <- function(expected = ? factor, actual = ? factor) {
  result <- (expected != actual) %>%
    as.integer %>%
    sum
  result / length(expected)
}

create_svm_plot <- function(svm_obj = ? svm, svm_train = ? data.frame, filename = ? character) {
  jpeg(file = data_path(filename), width = std_img_width, height = std_img_height, res = std_img_dpi)
  plot(svm_obj, svm_train, grid = 300, symbolPalette = c("#000000", "#FF0000"), # black, red
       color.palette = function(n = 3) c("PaleGreen", "Pink", "PaleTurquoise")[1:n])
  dev.off()
}

eval_svm <- function(data.train = ? data.frame, data.test = ? data.frame, kernel = ? character, filename_suffix = "", ...) {
  data.svm <- svm(Colors ~ ., data = data.train, type = "C-classification", kernel = kernel, ...)
  create_svm_plot(svm_obj = data.svm, svm_train = data.train, filename = paste0(filename_suffix, "_", kernel, ".jpeg"))
  data.test.err_rate <- err_rate(predict(data.svm, data.test), data.test$Colors)
}

# --------------
# --- Task 1 ---
# --------------

set.seed(0) # for reproducibility
head(data1.train)
data1.svm <- svm(Color ~ ., data = data1.train, type = "C-classification", cost = 1, kernel = "linear")

paste0("data1: number of support vectors = ", sum(data1.svm$nSV), "\n",
       "data1: error rate on training set = ", err_rate(data1.svm$fitted, data1.train$Color), "\n",
       "data1: error rate on test set = ", err_rate(predict(data1.svm, data1.test), data1.test$Color)) %>% cat("\n")

create_svm_plot(svm_obj = data1.svm, svm_train = data1.train %>% select(X1, X2, Color), filename = "data1.jpg")

# --------------
# --- Task 2 ---
# --------------

set.seed(0) # for reproducibility
head(data2.train)
c(1, 100, 500, 1000) %>% lapply(function(cost = ? numeric) {
  data2.svm <- svm(Colors ~ ., data = data2.train, type = "C-classification", cost = cost, kernel = "linear")
  data2.train.err_rate <- err_rate(data2.svm$fitted, data2.train$Colors)
  data2.test.err_rate <- err_rate(predict(data2.svm, data2.test), data2.test$Colors)

  create_svm_plot(svm_obj = data2.svm, svm_train = data2.train, filename = paste0("data2_cost", cost, ".jpeg"))
  paste("cost =", cost, "error rate on train data =", data2.train.err_rate, "error rate on test data =", data2.test.err_rate)
})

# --------------
# --- Task 3 ---
# --------------

set.seed(0) # for reproducibility
head(data3.train)

# dividing into train and test, since no test set provided
data3 <- data3.train
data3.n_samples <- nrow(data3)
data3.test_indices <- sample(seq_len(data3.n_samples), size = round(data3.n_samples * .2))
data3.train <- data3[-data3.test_indices,]
data3.test <- data3[data3.test_indices,]

c("radial", "sigmoid") %>% lapply(function(kernel = ? character) eval_svm(data.train = data3.train, data.test = data3.test, kernel = kernel, filename_suffix = "data3"))
1:6 %>% lapply(function(degree = ? interger) eval_svm(data.train = data3.train, data.test = data3.test, kernel = "polynomial", filename_suffix = paste0("data3_", degree), degree = degree))

# --------------
# --- Task 4 ---
# --------------
set.seed(0) # for reproducibility
head(data4.train)
c("radial", "sigmoid") %>% lapply(function(kernel = ? character) eval_svm(data.train = data4.train, data.test = data4.test, kernel = kernel, filename_suffix = "data4"))
1:6 %>% lapply(function(degree = ? interger) eval_svm(data.train = data4.train, data.test = data4.test, kernel = "polynomial", filename_suffix = paste0("data4_", degree), degree = degree))

# --------------
# --- Task 5 ---
# --------------

set.seed(0) # for reproducibility
head(data5.train)

1:6 %>% lapply(function(degree = ? interger) eval_svm(data.train = data5.train, data.test = data5.test, kernel = "polynomial", filename_suffix = paste0("data5_", degree), degree = degree))
# we choose degree = 2

data5.stats <- expand.grid(kernel = c("polynomial", "radial", "sigmoid"), gamma = c(.001, .01, .1, 1, 10, 100))
data5.stats$err <- mapply(function(kernel = ? character, gamma = ? numeric) {
  filename_suffix <- paste0("data5_gamma_", round(gamma, 4))
  if (kernel == "polynomial")
    eval_svm(data.train = data5.train, data.test = data5.test, kernel = kernel, filename_suffix = filename_suffix, gamma = gamma, degree = 2)
  else
    eval_svm(data.train = data5.train, data.test = data5.test, kernel = kernel, filename_suffix = filename_suffix, gamma = gamma, degree = 2)
}, data5.stats$kernel, data5.stats$gamma)

ggplot(data = data5.stats %>% mutate(gamma = as.factor(gamma)), aes(x = kernel, y = err, fill = gamma)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  ggtitle("error rate on the test set with different kernels") +
  theme_bw() +
  theme(plot.title = element_text(hjust = .5))
ggsave(data_path("data5_err_rates.png"), scale = .3)

# --------------
# --- Task 6 ---
# --------------

set.seed(0) # for reproducibility
head(data6.train)

data6.svm <- svm(Y ~ X, data = data6.train, type = "eps-regression", kernel = "radial")
data6.train$predicted <- data6.svm$fitted
data6.train$bound_higher <- data6.train$predicted + data6.svm$epsilon
data6.train$bound_lower <- data6.train$predicted - data6.svm$epsilon

ggplot(data6.train) +
  geom_line(mapping = aes(x = X, y = predicted)) +
  geom_line(mapping = aes(x = X, y = bound_higher), color = "blue") +
  geom_line(mapping = aes(x = X, y = bound_lower), color = "blue") +
  geom_ribbon(aes(x = X, ymin = bound_lower, ymax = bound_higher), fill = "grey", alpha = .25) +
  geom_point(aes(x = X, y = Y), color = "red") +
  ggtitle(" SVM for regression ") +
  theme_bw() +
  theme(plot.title = element_text(hjust = .5))
ggsave(data_path("data6.jpeg"), scale = .3)

data6.stats <- data.frame(epsilon = .01 * 1:20)
data6.stats$sd <- data6.stats$epsilon %>% lapply(function(epsilon = ? numeric) {
  data6.train$predicted <- svm(Y ~ X, data = data6.train, type = "eps-regression", kernel = "radial", epsilon = epsilon)$fitted
  sd(data6.train$predicted - data6.train$Y)
})

ggplot(data6.stats, mapping = aes(x = as.numeric(epsilon), y = as.numeric(sd))) +
  geom_line() +
  geom_point() +
  theme_bw() +
  xlab("epsilon") +
  ylab("standard deviation") +
  theme(plot.title = element_text(hjust = .5))
ggsave(data_path("data6_stats.jpeg"), scale = .3)
