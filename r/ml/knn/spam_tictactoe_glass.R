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
  error_rates[, kernel] <- eval_knn(data = glass, data.test_parts = test_parts, kernel = kernel, distance = 1)
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
