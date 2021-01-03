# Title     : kNN for datasets: "Titanic", "svmdata4"
# Created by: Valerii Zuev
# Created on: 1/2/2021

library(types) # type hints
library(here) # relative paths
library(tidyverse) # ggplot2, dplyr, ...
library(kknn) # k nearest neighbours
library(ggvoronoi) # voronoi tesselation

data_subfolder <- "r/ml/lab1bayes/data"
read_table <- function(data_dir = ? character, file_name = ? character, sep = ",") {
  here(data_dir, file_name) %>%
    read.csv(stringsAsFactors = TRUE, sep = sep)
}
abs_path <- function(path) here("r/ml/knn", path) # path relative to the Git root

# ----------------------------------
# --- kNN for `svmdata4` dataset ---
# ----------------------------------
svm_data_dir <- "r/ml/svm/data"
svm.train <- read_table(svm_data_dir, "svmdata4.txt", sep = "\t")
svm.test <- read_table(svm_data_dir, "svmdata4test.txt", sep = "\t")
svm.knn_err_rate <- function(k) {
  tbl <- kknn(Colors ~ ., train = svm.train, test = svm.test, k = k, kernel = "rectangular") %>%
    fitted %>%
    table(svm.test$Colors)
  1 - sum(diag(tbl)) / sum(tbl)
}

svm.err_rate <- data.frame(k = 1:200)
svm.err_rate$value = lapply(svm.err_rate$k, svm.knn_err_rate)

ggplot(data = svm.err_rate) +
  geom_line(mapping = aes(x = as.numeric(k), y = as.numeric(value))) +
  ggtitle("kNN for \`svmdata4\` dataset") +
  xlab("k") +
  ylab("error rate") +
  theme_bw() +
  theme(legend.position = "none", plot.title = element_text(hjust = 0.5))
ggsave(abs_path("svm_err_rate.png"), scale = .3)

ggplot(data = svm.train %>% rename(x = X1, y = X2), aes(x, y, color = Colors)) +
  geom_point() +
  stat_voronoi(geom = "path") +
  ggtitle("Voronoi tesselation of \`svmdata4\` ") +
  xlab("X1") +
  ylab("X2") +
  theme_classic() +
  theme(legend.position = "none", plot.title = element_text(hjust = 0.5))
ggsave(abs_path("svm_voronoi.png"), scale = .3)

# ---------------------------------
# --- kNN for `Titanic` dataset ---
# ---------------------------------
titanic_data_dir <- "r/ml/lab1bayes/data"
titanic.train <- read_table(titanic_data_dir,"titanic_train.csv") %>%
  select(Survived, Pclass, Sex, Age, SibSp, Parch, Fare) %>%
  replace_na(list(Fare = 0, Age = 0)) %>%
  na.omit %>%
  mutate(Survived = as.factor(Survived))
titanic.test <- read_table(titanic_data_dir,"titanic_test.csv") %>% replace_na(list(Fare = 0, Age = 0))
titanic.test$Survived <- kknn(Survived ~ ., train = titanic.train, test = titanic.test, kernel = "gaussian") %>% fitted

titanic.test %>%
  select(PassengerId, Survived) %>%
  write.csv(here("r/ml/knn", "result.csv"), row.names = F)
