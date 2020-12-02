# Title     : Bayesian Classifier
# Objective : exploring Naive Bayesian classifier implemented in `e1071` package. Credit: https://github.com/levutkin
# Created by: Valerii Zuev
# Created on: 11/13/2020

library(here) # for relative paths
library(types) # for type annotations in functions
library(e1071) # for Bayesian classifier
library(ggplot2) # for figures
library(dplyr) # for `summarize`, `group_by`
library(kernlab) # spam dataset

# preparing tic-tac-toe data

data_subfolder <- "r/ml/lab1bayes" # relative path to the Git root
# A contains 10 columns (9 features: V1-V9 + class: V10) = design matrix & vector of labels. All data is of type Factor
A_raw <- read.table(here(data_subfolder, "tic_tac_toe_data.txt"), sep = ",", stringsAsFactors = TRUE)
n_tttoe <- dim(A_raw)[1] # number of rows in A = number of data samples

# preparing spam data

data(spam)

seeds <- c(168278, 180183, 400990, 474721, 127023, 853003) # seeds for reporducibility. Generated at https://random.org
per_seed_stat_names <- c("seed", "true_negatives", "false_positives", "false_negatives", "true_positives")

bayes_tic_tac_toe <- function(seed = ? integer, train_data_fraction = ? double) {
  set.seed(seed) # fixed seed for reporducibility
  A_rand <- A_raw[order(runif(n_tttoe)),] # shuffling data

  n_train <- as.integer(n_tttoe * train_data_fraction) # `train_data_fration` - training, other - testing
  A_train <- A_rand[1:n_train,]
  A_test <- A_rand[(n_train + 1):n_tttoe,]

  A_classifier <- naiveBayes(V10 ~ ., data = A_train) # building a hypothesis
  A_predicted <- predict(A_classifier, A_test) # evaluating the hypothesis
  return(table(A_predicted, A_test$V10) / (n_tttoe - n_train))
}

bayes_spam <- function(seed = ? integer, train_data_fraction = ? double) {
  set.seed(seed)
  n_spam <- dim(spam)[1]
  n_test <- n_spam - as.integer(n_spam * train_data_fraction)
  idx <- sample(1:n_spam, n_test)
  spam_train <- spam[-idx,]
  spam_test <- spam[idx,]

  model <- naiveBayes(type ~ ., data = spam_train)
  model_predicted <- predict(model, spam_test)
  return(table(model_predicted, spam_test$type) / n_test)
}

bayes_try_fraction <- function(train_data_fraction = ? double, build_model = bayes_tic_tac_toe) {
  per_seed_stats <- data.frame(matrix(ncol = length(per_seed_stat_names), nrow = 0, dimnames = list(NULL, per_seed_stat_names)))
  for (seed in seeds) {
    per_seed_stats[nrow(per_seed_stats) + 1,] <- c(seed, build_model(seed, train_data_fraction))
  }
  return(per_seed_stats)
}

stats_names <- c("fraction", per_seed_stat_names)
functions <- c(bayes_spam, bayes_tic_tac_toe)
titles <- c("Spam classifier", "Tic-Tac-Toe classifier")
filenames <- c("spam_stats.png", "tttoe_stats.png")
for (bayes_fun_idx in seq_along(functions)) {
  bayes_fun <- functions[bayes_fun_idx][[1]]
  stats_df <- data.frame(matrix(ncol = length(stats_names), nrow = 0, dimnames = list(NULL, stats_names)))
  for (fraction in c(0.5, 0.6, 0.7, 0.8, 0.9)) {
    per_seed_stats <- bayes_try_fraction(fraction, bayes_fun)
    per_seed_stats$fraction <- fraction
    stats_df <- rbind(stats_df, per_seed_stats)
  }

  stats_grouped <- group_by(stats_df, fraction)
  half_confidence_interval <- function(x) 1.96 * sd(x) / sqrt(length(x))
  # TODO reduce code duplication
  stats_summary_tn <- summarise(stats_grouped,
                                stat_mean = mean(true_negatives),
                                stat_max = stat_mean + half_confidence_interval(true_negatives),
                                stat_min = stat_mean - half_confidence_interval(true_negatives),
                                stat_name = "true negatives rate")
  stats_summary_tp <- summarise(stats_grouped,
                                stat_mean = mean(true_positives),
                                stat_max = stat_mean + half_confidence_interval(true_positives),
                                stat_min = stat_mean - half_confidence_interval(true_positives),
                                stat_name = "true positives rate")
  stats_summary_fn <- summarise(stats_grouped,
                                stat_mean = mean(false_negatives),
                                stat_max = stat_mean + half_confidence_interval(false_negatives),
                                stat_min = stat_mean - half_confidence_interval(false_negatives),
                                stat_name = "false negatives rate")
  stats_summary_fp <- summarise(stats_grouped,
                                stat_mean = mean(false_positives),
                                stat_max = stat_mean + half_confidence_interval(false_positives),
                                stat_min = stat_mean - half_confidence_interval(false_positives),
                                stat_name = "false positives rate")
  stats_summary <- rbind(stats_summary_tn, stats_summary_tp, stats_summary_fn, stats_summary_fp)

  pd <- position_dodge(.01)
  ggplot(stats_summary, aes(x = fraction, y = stat_mean, colour = stat_name)) +
    geom_errorbar(aes(ymin = stat_min, ymax = stat_max), width = .02, position = pd) +
    geom_line(position = pd) +
    geom_point(position = pd) +
    xlab("train data fraction") +
    ylab("statistics") +
    ggtitle(paste0("Average behaviour on test data with confidence intervals:\n", titles[bayes_fun_idx])) +
    theme(plot.title = element_text(hjust = 0.5))
  ggsave(here(data_subfolder, filenames[bayes_fun_idx]), scale = .3)
}
