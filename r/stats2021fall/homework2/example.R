# Title     : Task 2 (example considered in class)
# Created by: vzuev
# Created on: 26.10.2021

x <- rnorm(100, 2, 3)
alp <- .05
al0 <- 0
sig0 <- 2
al1 <- 2
sig2 <- 3

m <- mean(x)
s2 <- mean(x^2) - m^2 # variance estimate
n <- length(x)
nl <- n - 1

xal <- qt(1 - alp / 2, nl) # T distribution quantile
CI.m <- m + c(-xal * sqrt(s2) / sqrt(nl), xal * sqrt(s2) / sqrt(nl)) # confidence interval for alpha

alp1 <- c(alp / 2, 1 - alp / 2)

f <- function(x) {
  pnorm(x, 1, 3)
}

q <- ks.test(x, f) # this could be easily done manually

# ----------
# chi squared test: manual, built-in
# ----------

u <- hist(x, plot = F)
brk <- c(-Inf, -2, 0, 2, 4, 6, Inf) # bins edges
u1 <- hist(x, plot = F, breaks = brk)
lb <- length(brk)
nu <- u1$counts
pr <- pnorm(brk[2:lb], 1, 3) - pnorm(brk[1:(lb - 1)], 1, 3)
ex <- n * pr
v3 <- (nu - ex) / sqrt(ex)
v4 <- v3^2
chi2 <- sum(v4)

qq <- chisq.test(nu, p = pr)

# checking normality hypotheses
f1 <- function(x) {
  pr <- pnorm(brk[2:lb], x[1], x[2]) - pnorm(brk[1:(lb - 1)], x[1], x[2]) # bins probabilities
  csq <- sum((nu - n * pr)^2)
  # TODO a bit
}

# наиболее мощный критерий - из леммы Неймана-Пирсона
# при переходе надо не потерять знак
