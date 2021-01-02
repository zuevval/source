# Title     : kNN
# Created by: Valerii Zuev
# Created on: 12/15/2020

library(types) # type hints
library(here) # for relative paths
library(kknn) # k nearest neighbours
library(kernlab) # spam dataset
library(tidyverse) # dplyr, ggplot2, etc

# -------------------------------------------------
# --- kNN for `Tic-Tac-Toe` and `Spam` datasets ---
# -------------------------------------------------
set.seed(0) # for reproducibility
data(spam)
abs_path <- function(path) here("r/ml/knn", path) # path relative to the Git root
ttoe <- here("r/ml/lab1bayes/data", "tic_tac_toe_data.txt") %>%
  read.table(sep = ",", stringsAsFactors = T) %>%
  rename(type = V10) # to unify with `spam` data

datas <- list("tic-tac-toe" = ttoe, "spam" = spam)

eval_knn <- function(data = ? data.frame, data.test_parts = ? numeric, kernel = ? character, distance = ? numeric, reset_seed = F) {
  if (reset_seed) set.seed(0)
  n_samples <- nrow(data)
  data.test_err_rates <- rep(0, length(data.test_parts))
  for (i in seq_along(data.test_parts)) {
    test_part <- data.test_parts[i]
    test_indices <- sample(1:n_samples, size = round(n_samples * test_part))
    data.train <- data[-test_indices,]
    data.test <- data[test_indices,]

    data.kknn <- kknn(type ~ ., data.train, data.test, distance = distance, kernel = "triangular")
    data.contingency_table <- table(data.test$type, fitted(data.kknn))
    data.test_err_rates[i] <- 1 - sum(diag(data.contingency_table)) / sum(data.contingency_table)
  }
  data.test_err_rates
}

mapply(function(data.name, data) {
  data.test_parts <- 1:19 / 20
  data.test_err_rates <- eval_knn(data = data, data.test_parts = data.test_parts, kernel = "triangular", distance = 1)
  data.results <- data.frame(test_parts = data.test_parts,
                             test_err_rates = data.test_err_rates)

  ggplot(data = data.results) +
    geom_line(mapping = aes(x = test_parts, y = test_err_rates, color = "blue")) +
    ggtitle(paste0("kNN for \`", data.name, "\` dataset")) +
    ylab("false predictions (share of the total)") +
    xlab("test dataset size (share of the total)") +
    theme_bw() +
    theme(legend.position = "none", plot.title = element_text(hjust = 0.5))

  ggsave(abs_path(paste0(data.name, "_err_rate.png")), scale = .3)
}, names(datas), datas)

# -------------------------------
# --- kNN for `Glass` dataset ---
# -------------------------------
library(mlbench) # `Glass` dataset
library(reshape2) # for `melt` function

set.seed(0) # for reproducibility
data(Glass) # loading dataset
head(Glass) # just displaying a few top rows
glass <- Glass %>% rename(type = Type) # unify to fit the `eval_knn` function

kernels <- c("rectangular", "triangular", "epanechnikov", "biweight", "triweight", "cos", "inv", "gaussian", "rank")
error_rates <- data.frame(test_part = 1:19 / 20)

for (kernel in kernels) {
  error_rates[, kernel] <- eval_knn(data = glass, data.test_parts = error_rates$test_part, kernel = kernel, distance = 1)
}

plot_error_rates <- function(error_rates_molten) {
  ggplot(error_rates_molten, aes(test_part, error_rate)) +
    geom_line(aes(linetype = kernel, color = kernel)) +
    geom_point(aes(color = kernel)) +
    ggtitle("kNN for \` Glass \` dataset") +
    ylab("error rate on test data") +
    xlab("test dataset size (share of the total)") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5))
}

error_rates_molten <- melt(error_rates, id.vars = "test_part", variable.name = "kernel", value.name = "error_rate")

plot_error_rates(error_rates_molten = error_rates_molten)
ggsave(abs_path("glass_err_rate_all.png"), scale = .3)

error_rates_molten %>%
  filter(kernel %in% c("rectangular", "gaussian")) %>%
  plot_error_rates
ggsave(abs_path("glass_err_rate_filtered.png"), scale = .3)

# how `distance` affects the error rate?
error_rates <- data.frame(distance = rep(1:16, 10)) # 10 measures for each distance
error_rates$value <- 0
for (i_row in seq_along(error_rates[, 1])) {
  error_rates$value[i_row] <- eval_knn(data = glass, data.test_parts = 0.5, distance = error_rates$distance[i_row])
}
error_rates %>%
  group_by(distance) %>%
  summarise(mean = mean(value), sd = sd(value)) %>%
  ggplot(aes(x = distance, y = mean)) +
  geom_line() +
  geom_point() +
  geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd), width = .2) +
  ggtitle("kNN for \` Glass \` dataset with different distances") +
  ylab("error rate on test data") +
  xlab("parameter of Mikiwski distance") +
  theme_bw() +
  theme(legend.position = "none", plot.title = element_text(hjust = 0.5))
ggsave(abs_path("glass_err_rate_diff_distances.png"), scale = .3)

# so we choose parameters values as follows: kernel = "rectangular", distance = 1
glass.knn <- function(test) kknn(formula = type ~ ., train = glass, test = test, distance = 1, kernel = "rectangular") %>% fitted
# now evaluating a new sample
new_glass_sample <- data.frame(RI = 1.516, Na = 11.7, Mg = 1.01, Al = 1.19, Si = 72.59, K = 0.43, Ca = 11.44, Ba = 0.02, Fe = 0.1)
glass.knn(test = new_glass_sample) # the answer is 5

# which feature affects the error most of all?
features <- colnames(glass)
features <- features[features != "type"] # remove "type"
error_rates <- data.frame(feature = rep(features, 5))
error_rates$value <- 0
for (i_row in seq_along(error_rates$feature)) {
  error_rates$value[i_row] <- eval_knn(data = glass %>% modify_at(error_rates$feature[i_row], ~NULL), data.test_parts = 0.5, distance = 1)
}

error_rates %>%
  group_by(feature) %>%
  summarise(mean = mean(value), sd = sd(value)) %>%
  ggplot(aes(x = feature, y = mean)) +
  geom_point() +
  geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd), width = .2) +
  ggtitle("kNN for \` Glass \` dataset with a single feature excluded") +
  ylab("error rate on test data") +
  xlab("excluded feature") +
  theme_bw() +
  theme(legend.position = "none", plot.title = element_text(hjust = 0.5))
ggsave(abs_path("glass_err_rate_features_excluded.png"), scale = .3)
