# Title     : Lifetime data analysis
# Created by: vzuev
# Created on: 14.12.2022

# TODOdone построить графики исходя из модели Кокса
# TODOdone построить на одном полотне все графики для age


library(tidyverse)
library(survival)

alpha1 <- .2

dat <- data.frame(
  obs = c(514, 488, 395, 5258, 168, 1480, 559, 171, 2503, 859, 550, 48, 835, 246, 2703, 365, 214, 339, 2141, 860, 957, 398, 1071, 710, 277, 145, 1620, 1690, 635, 1305, 285, 1069, 722, 141, 565, 2339, 702, 180, 713, 1113, 435, 587, 552, 655, 435, 885, 1161, 1516, 391, 1479),
  indi = c(1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 1),
  age = as.factor(c(3, 4, 3, 2, 4, 3, 1, 1, 2, 2, 5, 2, 3, 5, 1, 2, 3, 2, 4, 2, 2, 1, 3, 2, 3, 4, 3, 1, 4, 4, 4, 5, 2, 3, 1, 2, 4, 1, 5, 4, 3, 3, 1, 3, 4, 2, 2, 4, 3, 1)),
  sex = c("m", "m", "m", "m", "f", "f", "f", "m", "f", "m", "f", "f", "m", "m", "m", "f", "f", "m", "m", "m", "f", "f", "f", "m", "f", "m", "f", "f", "m", "f", "f", "f", "m", "m", "m", "f", "f", "m", "m", "f", "m", "m", "m", "f", "f", "f", "f", "m", "f", "m")
)

# Kaplan-Meier estimate (the whole data)
surv.dat <- Surv(dat$obs, dat$indi)
km <- survfit(surv.dat ~ 1)
plot(km, ylab = "Kaplan-Meier survival function estimate")


# Kaplan-Meier estimate (for different genders)
km.gender <- survfit(surv.dat ~ dat$sex)
plot(km.gender, ylab = "Kaplan-Meier for different genders", col = c("red", "blue"))
legend("topright", legend = unique(dat$sex), col = c("red", "blue"), lty = 1:2)

female.dat <- dat %>% filter(sex == "f")
female.surv.dat <- Surv(female.dat$obs, female.dat$indi)

for (s in unique(dat$sex)) {
  s.dat <- dat %>% filter(sex == s)
  print(paste("gender:", s, "non-censored:", sum(s.dat$indi) / nrow(s.dat)))
}

# for different ages
x.max <- max(dat$obs)
a.colors <- c("red", "blue", "green", "black")
plot(1, type = "n", xlim = c(0, x.max), ylim = c(0, 1))
for (a in 1:4) {
  a <- as.character(a)
  a.dat <- dat %>% filter(age == a)
  a.km <- survfit(Surv(a.dat$obs, a.dat$indi) ~ 1)
  a.time <- NULL
  a.surv <- NULL
  for (t in a.km$time) a.time <- c(a.time, t, t)
  a.time <- a.time[1:(length(a.time) - 1)]
  for (surv in a.km$surv) a.surv <- c(a.surv, surv, surv)
  a.surv <- a.surv[2:length(a.surv)]
  lines(a.time, a.surv, col = a.colors[as.integer(a)])
  # plot(a.km, ylab = paste("Kaplan-Meier for age ==", a))
  print(paste("age:", a, "non-censored:", sum(a.dat$indi) / nrow(a.dat)))
}
title("Kaplan-Meier estimates for different ages")
legend(4000, 1, legend = c("age=1", "age=2", "age=3", "age=4"), col = a.colors, lty = 1:2, cex = .8)

# -----------------
# 2. Wilcoxon test
# -----------------

survdiff(surv.dat ~ dat$sex, rho = 1) # rho=1 <=> Peto&Peto modification of Wilcoxon test

# -------------
# 3. Cox model
# -------------

cox.general <- coxph(Surv(obs, indi) ~ sex * age, data = dat)
cox.gender <- coxph(Surv(obs, indi) ~ sex, data = dat)
cox.age <- coxph(surv.dat ~ dat$age)
cox.null <- coxph(surv.dat ~ 1)

anova(cox.general, cox.null)
anova(cox.gender, cox.null)
anova(cox.age, cox.null)

# library(devtools)
# install_github("kassambara/survminer", ref = "v0.3.0")

library(survival)
library(survminer)
library(ggplot2)

cox.plot <- function (cox.fit, ...) ggcoxadjustedcurves(cox.fit, data = dat, individual.curves = T, ...=...)

cox.plot(cox.general, title="Cox model: general")
cox.plot(cox.age, title="Cox model: age")
cox.plot(cox.gender, title="Cox model: gender")

cox.general

# ----------------------
# 4. Exponential model
# ----------------------

overall_non_censored <- sum(dat$indi) / nrow(dat)
overall_non_censored
plot(km)
lines(1:2000, pexp(1:2000, overall_non_censored, lower.tail = F), col = "green")


# for (a in levels(dat$age)) {
#   a.dat <- dat %>% filter(age == a)
#   a.km <- survfit(Surv(a.dat$obs, a.dat$indi) ~ 1)
#   a.theta <- sum(a.dat$indi) / nrow(a.dat)
#   plot(a.km, ylab = paste("Kaplan-Meier for age ==", a))
#   lines(1:2000, pexp(1:2000, a.theta, lower.tail = F), col = "green")
# }
