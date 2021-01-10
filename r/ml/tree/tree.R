# Title     : Decision trees
# Created by: Valerii Zuev
# Created on: 1/8/2021

library(here) # relative paths
library(types) # type hints
library(tidyverse) # dplyr, ggplot2, ...
library(mlbench) # `Glass` dataset
library(DAAG) # `spam7`, `nsw74psid1` datasets
library(tree) # decision trees
library(maptree) # draw trees
library(e1071) # svm

abs_path <- function(path) here("r/ml/tree", path) # path relative to the Git root

source(abs_path("gg_partition_tree.R"))

std_img_width <- 4500
std_img_height <- 3000
std_img_dpi <- 600

draw.smth <- function(jpeg_filename = ? character, do_plot = function() { }, scale = 1) {
  jpeg(file = abs_path(jpeg_filename), width = std_img_width * scale, height = std_img_height * scale, res = std_img_dpi)
  do_plot()
  dev.off()
}

# -----------------------------
# --- Task 1: Glass dataset ---
# -----------------------------

data(Glass)
head(Glass)
draw.smth("glass_pairs.jpeg", function() pairs(Glass %>% select(Mg, Na, Al, Ba, RI), col = Glass$Type))

Glass.tree <- tree(Type ~ ., Glass)
draw.smth("glass_tree.jpeg", function() draw.tree(Glass.tree), scale = 1.8)

Glass.tree_snip <- Glass.tree %>%
  snip.tree(nodes = c(9, 10)) %>%
  prune.tree(best = 6)
draw.smth("glass_tree_snip.jpeg", function() draw.tree(Glass.tree_snip), scale = 1.7)

# -------------------------------
# --- Task 2: `spam7` dataset ---
# -------------------------------

data(spam7)
head(spam7)

spam7.tree <- tree(yesno ~ ., spam7)
spam7.tree <- snip.tree(spam7.tree, nodes = 11) # snip node 11 (redundant)
draw.smth("spam7_tree.jpeg", function() draw.tree(spam7.tree))

spam7.cv <- cv.tree(spam7.tree, , prune.tree)
draw.smth("spam7_cv1.jpeg", function() plot(spam7.cv))

spam7.pruned_trees <- prune.tree(spam7.tree, method = "misclass")
draw.smth("spam7_pruned.jpeg", function() plot(spam7.pruned_trees))

spam7.pruned_trees$k[2:length(spam7.pruned_trees$k)] %>% lapply(function(k = ? numeric) {
  spam7.pruned_tr <- prune.tree(spam7.tree, k = k)
  draw.smth(paste0("spam7_pruned_k", k, ".jpeg"), function() draw.tree(spam7.pruned_tr))
})

# ------------------------------------
# --- Task 3: `nsw74psid1` dataset ---
# ------------------------------------

data(nsw74psid1)
head(nsw74psid1)

nsw.tree <- tree(re78 ~ ., data = nsw74psid1)
nsw.svm <- svm(re78 ~ ., data = nsw74psid1, type = "eps-regression", kernel = "radial")
nsw.regression <- lm(re78 ~ ., data = nsw74psid1)

nsw.find_sd <- function(model) sum(sd(predict(model) - nsw74psid1$re78)) # TODO sum not necessary?
nsw.deviations <- data.frame(model = c("tree", "svm", "regression", "y = y_mean"),
                             sd = c(nsw.find_sd(nsw.tree), nsw.find_sd(nsw.svm), nsw.find_sd(nsw.regression), sd(nsw74psid1$re78)))

ggplot(data = nsw.deviations, aes(model, sd)) +
  geom_bar(stat = "identity") +
  ggtitle(" Standard deviation for models fitted to \`nsw74psid1\` ") +
  theme_bw() +
  theme(plot.title = element_text(hjust = .5))
ggsave(abs_path("nsw_deviations.jpeg"), scale = .3)

draw.smth("nsw_tree.jpg", function() draw.tree(nsw.tree, digits = 1))

# --------------------------------
# --- Task 4: `Lenses` dataset ---
# --------------------------------

read_table <- function(data_dir = ? character, file_name = ? character, sep = "\t", header = T) {
  here(data_dir, file_name) %>%
    read.csv(stringsAsFactors = TRUE, sep = sep, header = header)
}

lenses <- read_table("r/ml/tree", "Lenses.txt", sep = "", header = F)[, 2:6]
lenses <- rename(lenses, age = V2, myopia = V3, astigm = V4, tear = V5, type = V6)
head(lenses)
lenses$type <- recode_factor(lenses$type, `1` = "hard", `2` = "soft", `3` = "no")

devnull <- c(1, 3, 5) %>% lapply(function(mincut = ? integer) {
  lenses.tree <- tree(type ~ ., lenses, mincut = mincut, minsize = mincut * 2, mindev = 0)
  draw.smth(paste0("lenses_tree_mincut_", mincut, ".jpeg"), function() draw.tree(lenses.tree))

  # print misclassification error
  cat("misclassification error for mincut =", mincut, "is", misclass.tree(lenses.tree) / nrow(lenses), "\n")
  cat("prediction: ", predict(lenses.tree, data.frame(age = 3, myopia = 1, astigm = 2, tear = 1)), "\n")
})

ggplot(data = lenses, aes(tear, astigm)) +
  geom_point(mapping = aes(color = type, shape = type, group = type), position = position_dodge(width = .02)) +
  gg.partition.tree(tree(type ~ ., lenses, mincut = 5, minsize = 10, mindev = 0), label = "type") +
  ggtitle(" partition of the feature space with the decision tree ") +
  theme_bw() +
  theme(plot.title = element_text(hjust = .5))
ggsave(abs_path("lenses_partition_mincut5.jpeg"), scale = .7)

# -----------------------------------------
# --- Task 5: `Glass` dataset revisited ---
# -----------------------------------------

new_glass_sample <- data.frame(RI = 1.516, Na = 11.7, Mg = 1.01, Al = 1.19, Si = 72.59, K = 0.43, Ca = 11.44, Ba = 0.02, Fe = 0.1)
predict(Glass.tree_snip, newdata = new_glass_sample) # most likely class 5
predict(Glass.tree, newdata = new_glass_sample) # most likely class 2


# ------------------------------
# --- Task 6: `svmdata4` set ---
# ------------------------------

svm.data_dir <- "r/ml/svm/data"
svm.train <- read_table(svm.data_dir, "svmdata4.txt")
svm.test <- read_table(svm.data_dir, "svmdata4test.txt")
head(svm.train)

svm.tree <- tree(Colors ~ ., svm.train)
draw.smth("svmdata_tree.jpeg", function() draw.tree(svm.tree))

ggplot(data = svm.train, aes(X2, X1)) +
  geom_point(mapping = aes(color = Colors, shape = Colors)) +
  scale_color_manual(values = c("red" = "#fc0703", "green" = "#32a852")) +
  gg.partition.tree(svm.tree, label = "Colors") +
  ggtitle(" partition of the feature space with the decision tree ") +
  theme_bw() +
  theme(plot.title = element_text(hjust = .5))
ggsave(abs_path("svmdata_partition.jpeg"), scale = .7)

svm.table <- as.numeric(as.data.frame(predict(svm.tree, newdata = svm.test))$red >= .5) %>%
  recode_factor(`0` = "green", `1` = "red") %>%
  table(svm.test$Colors)
sum(diag(svm.table)) / sum(svm.table)

# ---------------------------------
# --- Task 7: `Titanic` dataset ---
# ---------------------------------

titanic_data_dir <- "r/ml/lab1bayes/data"
titanic.train <- read_table(titanic_data_dir, "titanic_train.csv", sep = ",") %>%
  select(Survived, Pclass, Sex, Age, SibSp, Parch, Fare, Embarked) %>%
  na.omit %>%
  mutate(Survived = as.factor(Survived))
titanic.test <- read_table(titanic_data_dir, "titanic_test.csv", sep = ",")

titanic.tree <- tree(Survived ~ ., titanic.train)
draw.smth("titanic_tree.jpeg", function() draw.tree(titanic.tree))
titanic.test.predictions <- predict(titanic.tree, newdata = titanic.test) %>% as.data.frame
titanic.test$Survived <- as.integer(titanic.test.predictions$`1` > .5)

titanic.test %>%
  select(PassengerId, Survived) %>%
  write.csv(abs_path("result.csv"), row.names = F)
