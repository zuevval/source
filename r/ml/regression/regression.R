# Title     : Linear regression & ridge regression
# Created by: Valerii Zuev
# Created on: 1/9/2021

library(here) # relative paths
library(types) # type hints
library(tidyverse) # dplyr, ggplot2, ...
library(plot3Drgl) # 3D-plot
library(glmnet) # ridge regression
library(datasets) # for `EuScockMarkets`, `JohnsonJohnson`,  `sunspot.year`, `cars` datasets

read_table <- function(data_dir = ? character, file_name = ? character, sep = "\t", header = T) {
  here(data_dir, file_name) %>%
    read.csv(stringsAsFactors = TRUE, sep = sep, header = header)
}
reg.data_dir <- "r/ml/regression/data"
data_path <- function(filename = ? character) here(reg.data_dir, filename)

# ---------------------------------
# --- Task 1: `reglab1` dataset ---
# ---------------------------------

set.seed(0)

reg1 <- read_table(reg.data_dir, "reglab1.txt") %>%
  mutate(a = x * y, b = exp(x + y), c = exp(x * y), d = (x * y)^2, e = x^2, f = y^2) # add new features
head(reg1)

reg1.n_samples <- nrow(reg1)
reg1.test_indices <- sample(seq_len(reg1.n_samples), size = round(reg1.n_samples * .2))
reg1.train <- reg1[-reg1.test_indices,]
reg1.test <- reg1[reg1.test_indices,]

reg1.lm <- lm(z ~ x + y, reg1.train)
scatter3D(x = reg1.train$x,
          y = reg1.train$y,
          z = reg1.train$z,
          colvar = reg1.train$z - reg1.lm$fitted.values,
          pch = 25)
plotrgl(type = 'n')
planes3d(reg1.lm$coefficients["x"], reg1.lm$coefficients["y"], -1., reg1.lm$coefficients["(Intercept)"], col = 'red', alpha = 0.4)

reg1.models <- c("x, y" = "z ~ x + y", "x, y, xy" = "z ~ x + y + a", "x, y, exp(x+y)" = "z ~ x + y + b",
                 "x, y, xy, (xy)^2" = "z ~ x + y + a + d", "x, y, xy, (xy)^2, exp(xy)" = "z ~ x + y + a + c + d",
                 "x, y, xy, x^2, y^2" = "z ~ x + y + a + e + f", "all" = "z ~ x + y + a + b + c + d + e + f")
devnull <- seq_along(reg1.models) %>% lapply(function(i = ? integer) {
  model <- as.character(reg1.models[i])
  name <- names(reg1.models)[i]
  reg1.lm <- lm(formula = model, reg1.train)
  reg1.test$predicted <- predict(reg1.lm, newdata = reg1.test)
  reg1.test.rss <- sum((reg1.test$predicted - reg1.test$z)^2)
  reg1.train.rss <- deviance(reg1.lm)
  cat("\n model:", name, "\n")
  cat("test RSS:", round(reg1.test.rss, 3), "\n")
  cat("train RSS:", round(reg1.train.rss, 3), "\n")
})

# ---------------------------------
# --- Task 1: `reglab2` dataset ---
# ---------------------------------

reg2 <- read_table(reg.data_dir, "reglab2.txt")
head(reg2)
reg2.features <- colnames(reg2)[2:ncol(reg2)]

devnull <- seq_along(reg2.features) %>% lapply(function(m = ? integer) {
  combn(reg2.features, m) %>% apply(2, function(features_subset = ? character) {
    formula <- paste("y ~", paste(features_subset, collapse = " + "))
    reg2.lm <- lm(formula = formula, reg2)
    reg2.rss <- deviance(reg2.lm)
    cat("formula:", formula, "rss:", round(reg2.rss, 2), "\n")
  })
}) # we choose formula "y ~ x1 + x2"

reg2.lm <- lm(y ~ x1 + x2, reg2)
scatter3D(x = reg2$x1,
          y = reg2$x2,
          z = reg2$y,
          colvar = reg2$y - reg2.lm$fitted.values,
          xlab = 'x1', ylab = 'x2', zlab = 'y',
          pch = 25)

# --------------------------------
# --- Task 3: `cygage` dataset ---
# --------------------------------

cygage <- read_table(reg.data_dir, "cygage.txt")
head(cygage)

cygage.lm <- lm(calAge ~ Depth, data = cygage, weights = cygage$Weight)
cygage$predicted <- cygage.lm$fitted.values
cat("cygage RSS:", deviance(cygage.lm), "\n")

ggplot(data = cygage) +
  geom_point(mapping = aes(x = Depth, y = calAge, size = Weight)) +
  geom_line(color = "red", aes(x = Depth, y = predicted)) +
  theme_bw()
ggsave(data_path("cygage.jpeg"), scale = .3)

# ---------------------------------
# --- Task 4: `Longley` dataset ---
# ---------------------------------
set.seed(0)
data(longley)
head(longley)

longley_reduced <- longley %>% select(-Population)
longley.n_samples <- nrow(longley)
longley.test_indices <- sample(seq_len(longley.n_samples), size = round(longley.n_samples * .2))
longley.train <- longley_reduced[-longley.test_indices,]
longley.test <- longley_reduced[longley.test_indices,]

# linear regression
longley.lm <- lm(formula = Employed ~ ., data = longley.train)
cat("longley RSS (linear model) :", deviance(longley.lm))

# ridge regression
longley.lambdas <- 10^(-3 + 0.2 * 0:25)
longley.ridge <- glmnet(x = longley.train %>%
  select(-Employed) %>%
  data.matrix, y = longley.train$Employed, alpha = 0, lambda = longley.lambdas)
summary(longley.ridge)

# predictions on the test set for ridge regression
longley.errs <- mapply(function(df, name) {
  longley.predictions <- predict(longley.ridge, newx = df %>%
    select(-Employed) %>%
    data.matrix) %>% data.frame
  colnames(longley.predictions) <- longley.ridge$lambda %>% round(3)
  longley.years <- rownames(longley.predictions)
  longley.predictions <- longley.predictions %>%
    gather %>%
    mutate(year = rep(longley.years, ncol(longley.predictions)),
           actual = rep(df$Employed, ncol(longley.predictions))) %>%
    rename(lambda = key, prediction = value)

  ggplot() +
    geom_line(data = longley.predictions, aes(x = year, y = prediction, group = lambda, color = lambda)) +
    geom_point(data = df, aes(x = longley.years, y = Employed)) +
    ggtitle(paste("ridge regression for the \`longley\` data: performance on the", name, "set")) +
    ylab("employed") +
    theme_bw() +
    theme(plot.title = element_text(hjust = .5))
  ggsave(data_path(paste0("longley_", name, ".jpeg")), scale = .5)

  longley.predictions$deviance <- (longley.predictions$actual - longley.predictions$prediction)^2
  errors <- longley.predictions %>%
    group_by(lambda) %>%
    summarize(rss = sum(deviance)) %>%
    mutate(lambda = as.numeric(lambda))
}, list(longley.train, longley.test), c("train", "test"))

longley.errs.train <- data.frame(lambda = longley.errs[1], rss = longley.errs[2], subset = "train")
longley.errs.test <- data.frame(lambda = longley.errs[3], rss = longley.errs[4], subset = "test")
colnames(longley.errs.test) <- c("lambda", "rss", "subset") # TODO fix: why are they not already the same?
colnames(longley.errs.train) <- c("lambda", "rss", "subset")

ggplot(data = rbind(longley.errs.train, longley.errs.test), aes(x = lambda, y = rss, group = subset, color = subset)) +
  geom_line() +
  scale_x_log10() +
  scale_y_log10() +
  geom_hline(aes(yintercept = deviance(longley.lm)), linetype = "dashed") +
  annotate(geom = "text", x = 0.01, y = deviance(longley.lm) - 0.1, label = " linear model: RSS on the train data ") +
  ggtitle("ridge regression for the \`longley\` data: performance with different lambda values \n (logarithmic graph)") +
  theme_bw() +
  theme(plot.title = element_text(hjust = .5))
ggsave(data_path("longley_err.jpeg"), scale = .3)

# -----------------------------------------
# --- Task 5: `EuStocksMarkets` dataset ---
# -----------------------------------------

data(EuStockMarkets)
head(EuStockMarkets)

markets <- EuStockMarkets %>%
  data.frame %>%
  gather %>%
  mutate(day = rep(seq_len(nrow(EuStockMarkets)), ncol(EuStockMarkets))) %>%
  rename(market = key, quotes = value)

ggplot(data = markets, aes(x = day, y = quotes)) +
  geom_line(aes(group = market, color = market)) +
  geom_smooth(method = lm, aes(group = market, color = market, linetype = market)) +
  geom_smooth(method = lm, linetype = "dotdash", size = 2) +
  theme_bw()
ggsave(data_path("markets.jpeg"), scale = .5)

# ----------------------------------------
# --- Task 6: `JohnsonJohnson` dataset ---
# ----------------------------------------

data(JohnsonJohnson)
johnson <- timetk::tk_tbl(JohnsonJohnson) %>%
  rename(profit = value) %>%
  separate(index, c("year", "quarter")) %>%
  mutate(year = as.integer(year))
head(johnson)

ggplot(data = johnson, aes(x = year, y = profit)) +
  geom_line(aes(group = quarter, color = quarter)) +
  geom_smooth(method = lm, aes(group = quarter, color = quarter, linetype = quarter), se = F) +
  geom_smooth(method = lm, linetype = "dotdash", size = 2, se = F) +
  theme_bw()
ggsave(data_path("johnson.jpeg"), scale = .5)

year_p <- data.frame(year = 2016)
devnull <- unique(johnson$quarter) %>% lapply(function(q = ? character) {
  johnson_q <- johnson %>% filter(quarter == q)
  johnson_q.lm <- lm(profit ~ year, johnson_q)
  cat("Johnson & Johnson: predicted profit in quarter", q, "is", predict(johnson_q.lm, newdata = year_p), "\n")
})
johnson.lm <- lm(profit ~ year, johnson)
cat("Johnson & Johnson: predicted profit for the year is ", predict(johnson.lm, newdata = year_p))

# --------------------------------------
# --- Task 7: `sunspot.year` dataset ---
# --------------------------------------

data(sunspot.year)
sunspot <- timetk::tk_tbl(sunspot.year) %>% rename(year = index)
head(sunspot)

ggplot(data = sunspot, aes(x = year, y = value)) +
  geom_line() +
  geom_smooth(method = lm, linetype = "dotdash", size = 2) +
  theme_bw()
ggsave(data_path("sunspot.jpeg"), scale = .5)

# -------------------------------
# --- Task 8: `UKgas` dataset ---
# -------------------------------

ukgas <- read_table(reg.data_dir, "UKgas.csv", sep = ",") %>%
  transmute(year = floor(time), quarter = time %% 1, consumption = UKgas)
ukgas$quarter <- ukgas$quarter %>%
  recode(`0.00` = "Q1", `0.25` = "Q2", `0.50` = "Q3", `0.75` = "Q4") %>%
  as.factor
head(ukgas)

# TODO reduce code duplication with task 6
ggplot(data = ukgas, aes(x = year, y = consumption)) +
  geom_line(aes(group = quarter, color = quarter)) +
  geom_smooth(method = lm, aes(group = quarter, color = quarter, linetype = quarter), se = F) +
  geom_smooth(method = lm, linetype = "dotdash", size = 2, se = F) +
  theme_bw()
ggsave(data_path("ukgas.jpeg"), scale = .5)

devnull <- unique(ukgas$quarter) %>% lapply(function(q = ? character) {
  ukgas_q <- ukgas %>% filter(quarter == q)
  ukgas_q.lm <- lm(consumption ~ year, ukgas_q)
  cat("UKgas: predicted consumption in quarter", q, "is", predict(ukgas_q.lm, newdata = year_p), "\n")
})
ukgas.lm <- lm(consumption ~ year, ukgas)
cat("UKgas: predicted consumption for the year is ", predict(ukgas.lm, newdata = year_p))

# ------------------------------
# --- Task 9: `cars` dataset ---
# ------------------------------

data(cars)
cars_df <- cars %>% data.frame
head(cars_df)

ggplot(data = cars_df, aes(x = speed, y = dist)) +
  geom_point() +
  geom_smooth(method = lm, linetype = "dotdash", size = 2) +
  theme_bw()
ggsave(data_path("cars.jpeg"), scale = .5)

cars.lm <- lm(dist ~ speed, cars_df)
cat("Predicted braking distance for 40 mph car is", predict(cars.lm, newdata = data.frame(speed = 40)))
