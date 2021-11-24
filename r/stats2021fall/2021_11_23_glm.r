# ----------------
# -- GLM. ANOVA --
# ----------------
set.seed(0)

n <- 1000
x1 <- sample(1:3, n, replace = T)
x2 <- sample(1:2, n, replace = T)
mu0 <- 5
al <- c(0, 1, 2)
be <- c(0, 3)
scl <- .2
p <- 1 / (1 + exp(scl * (mu0 + al[x1] + be[x2])))
Y <- rbinom(n, 1, p)

y.l <- c(0, 1) # probability ranges in [0;1]

x1.f <- as.factor(x1)
x2.f <- as.factor(x2)
mod.s <- formula(Y ~ x1.f * x2.f)
mod.a <- formula(Y ~ x1.f + x2.f)
mod.1 <- formula(Y ~ x1.f)
mod.2 <- formula(Y ~ x2.f)
mod.0 <- formula(Y ~ 1)

q.s <- glm(mod.s, family = "binomial")

qs.s <- summary(q.s)
qa.s <- anova(q.s)
qi.s <- confint(q.s)

cof <- q.s$coefficients
(cof[1] + cof[2] + be[x2])

# -----------------------------
# -- GLM. linear regression ---
# -----------------------------
library(tidyverse)

x <- rnorm(n, 0, 1)
b <- 0:2
p <- 1 / (1 + exp(scl * (b[1] + b[2] * x + b[3] * x^2)))
y <- rbinom(n, 1, p)
dat <- data.frame(y = y, x = x) %>% mutate(x2 = x^2)

mod.2 <- formula(Y ~ x + x2)
mod.1 <- formula(Y ~ x)
mod.0 <- formula(Y ~ 1)

q.s <- glm(mod.2, family = "binomial", data = dat)
qs.s <- summary(q.s)
qa.s <- anova(q.s)
qi.s <- confint(q.s)

cof <- q.s$coefficients
x.min <- min(x)
x.max <- max(x)

x1 <- -5 + 10 * 0:1000 / 1000
y1 <- 1 / (1 + exp(cof[1] + cof[2] * x1 + cof[3] * x1^2))

plot(x, y, "p", xlab = "x", ylab = "prob")
points(x1, y1, "l", col = "blue")
