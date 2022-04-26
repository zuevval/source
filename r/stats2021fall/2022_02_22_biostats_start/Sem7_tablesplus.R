#CATEGORICAL DATA ANALYSIS
# имеем дело с категориальными данными, но они не укладываются в формат таблицы сопряжённости.
# Ковариата -- число друзей у краба.
# Table 4.2, pages 82-83
library(tidyverse)
read_tbl <- function(fname) here::here("r/stats2021fall/2022_02_22_biostats_start/data", fname) %>% read.table(header = T, as.is = T)
dat <- read_tbl("Crubs.csv")
tt <- table(dat$satell) # посмотрим распределение числа друзей в популяции крабов
barplot(tt, main = "Crubs_satellites", xlab = "Num", names.arg = dat$year, beside = T, col = "red")

# из дискретных: может быть пуассоновское и отрицательное биномиальное; мы будем использовать пуассоновское
# дискретный аналог гамма-распределения -- отрицательное биномиальное (туда же включён дискретный аналог экспоненциального распределения)
x <- 0:15
lam <- mean(dat$satell)
y <- dpois(x, lam) * length(dat$satell)
points(x+1, y, "l", col="blue", lwd=3)

# тест хи-квадрат: распределение Пуассона - правдоподобно?
wb <- c(21, c(0:6) + 23.25, 34)
q <- hist(dat$width, breaks = wb, plot = F)
wb1 <- wb
wb1[1] <- -Inf
wb1[length(wb1)] <- Inf
lvb <- length(wb1)
n <- dim(dat)[1]
pp.f <- function(lam) {
  pp <- ppois(wb1[2:lvb], lam) - ppois(wb1[1:(lvb-1)], lam) # probabilities for bins
  ex <- pp * n # expected frequencies
  obs <- q$counts
  sum((ex-obs)^2 / ex)
}
chisq.param <- nlm(pp.f, lam)$minimum # TODO differs from what Sergei Vasilievich got (his: ~500)
pval <- pchisq(chisq.param, df=n-1) # TODO check DF value

#dat$weight.c<-q$counts
# GLM Poisson
# Incorrectly
g.res <- glm(satell ~ width + color + spine, data = dat, family = "poisson")
#
dat$clr <- as.factor(dat$color)
dat$spn <- as.factor(dat$spine)
# Correctly (ANOVA)
g.res <- glm(satell ~ width * clr * spn, data = dat, family = "poisson")
g.add <- glm(satell ~ width + clr + spn, data = dat, family = "poisson")
g.res.null <- glm(satell ~ 1, data = dat, family = "poisson")
AIC(g.res)
AIC(g.add)
AIC(g.res.null)
#
g.res.s <- summary(g.res)
g.res.a <- anova(g.res)
# LR-test
lrs <- g.res.null$deviance - g.res$deviance
df <- g.res.null$df.residual - g.res$df.residual
pval <- pchisq(lrs, df, lower.tail = FALSE)
#
forml <- list()
forml[[1]] <- formula(satell ~ 1)
forml[[2]] <- formula(satell ~ width)
forml[[3]] <- formula(satell ~ clr)
forml[[4]] <- formula(satell ~ spn)
forml[[5]] <- formula(satell ~ weight)
#
forml[[6]] <- formula(satell ~ width + clr)
forml[[7]] <- formula(satell ~ width + spn)
forml[[8]] <- formula(satell ~ width + weight)
forml[[9]] <- formula(satell ~ weight + clr)
forml[[10]] <- formula(satell ~ weight + spn)
forml[[11]] <- formula(satell ~ spn + clr)
#
forml[[12]] <- formula(satell ~ width + clr + spn)
forml[[13]] <- formula(satell ~ width + weight + clr)
forml[[14]] <- formula(satell ~ width + weight + spn)
forml[[15]] <- formula(satell ~ weight + spn + clr)
# 
forml[[16]] <- formula(satell ~ width * clr)
forml[[17]] <- formula(satell ~ width * spn)
forml[[18]] <- formula(satell ~ width * weight)
forml[[19]] <- formula(satell ~ weight * clr)
forml[[20]] <- formula(satell ~ weight * spn)
forml[[21]] <- formula(satell ~ spn * clr)
# Pairwise
forml[[22]] <- formula(satell ~ width * clr + weight * clr + spn * clr + width * spn + weight * spn)
# 3 way
forml[[23]] <- formula(satell ~ width * spn * clr)
forml[[24]] <- formula(satell ~ width * weight * spn)
forml[[25]] <- formula(satell ~ weight * spn * clr)
forml[[26]] <- formula(satell ~ weight * width * clr)
# 3 way interactions combined
forml[[27]] <- formula(satell ~ width * spn * clr + weight * spn * clr)
# saturated
forml[[29]] <- formula(satell ~ weight * spn + weight * clr + spn * clr)
#
forml[[28]] <- formula(satell ~ weight + width + spn + clr)
aic <- NA
bic <- NA
for (i in 1:29) {
  g.res <- glm(forml[[i]], data = dat, family = "poisson")
  aic[i] <- AIC(g.res)
  bic[i] <- BIC(g.res)
}
which(aic == min(aic))
which(bic == min(bic))
#
g.res <- glm(forml[[29]], data = dat, family = "poisson")
g.null <- glm(forml[[28]], data = dat, family = "poisson")
lrs <- g.null$deviance - g.res$deviance
df <- g.null$df.residual - g.res$df.residual
pval <- pchisq(lrs, df, lower.tail = FALSE)
#
g.res <- glm(forml[[18]], data = dat, family = "poisson")
g.null <- glm(forml[[5]], data = dat, family = "poisson")
lrs <- g.null$deviance - g.res$deviance
df <- g.null$df.residual - g.res$df.residual
pval <- pchisq(lrs, df, lower.tail = FALSE)


