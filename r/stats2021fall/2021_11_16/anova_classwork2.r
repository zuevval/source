n <- 100
int0 <- 10
al0 <- c(0, 3)
be0 <- c(0, 2, 1)
sig0 <- 1

#

a <- sample(seq_along(al0), n, replace = T)
b <- sample(seq_along(be0), n, replace = T)
eps0 <- rnorm(n, 0, sig0)
y <- int0 + al0[a] + be0[b] + eps0 # data from two covariates + error
y.l <- c(min(y), max(y))

#
f1 <- a == 1
plot(b[f1], y[f1], xlab = "b", ylab = "ey", ylim = y.l, col = "blue")
f2 <- a == 2
points(b[f2], y[f2], col = "red")
legend("topleft", legend = c("a=1", "a=2"), col = c("blue", "red"))

#
dd <- data.frame(y = y, a = a, b = b)
x1 <- 1:3
lm_subset <- function (subset){
  q1 <- lm(y ~ as.factor(b), subset = subset, data = dd)
  cf <- q1$coefficients
  c(cf[1], cf[1] + cf[2], cf[1] + cf[3])
}
y1 <- lm_subset(a == 1)
y2 <- lm_subset(a == 2)
points(x1, y1, col = "blue", pch=19, cex=3)
points(x1, y2, col="red", pch=19, cex=3)

# ANOVA

a.f <- as.factor(a)
b.f <- as.factor(b)
mod.s <- formula(y ~ a.f*b.f)
mod.add <- formula(y~a.f+b.f)
mod.a <- formula(y~a.f)
mod.b <- formula(y~b.f)
mod.0 <- formula(y~1)

#
q.s <- lm(mod.s)
q.s.s <- summary(q.s)
q.s.c <- confint(q.s)

res <- q.s$residuals
h<- hist(res,probability = T)
m1<-mean(res)
mse<- sqrt(var(res))
mmin <- min(res)
mmax <- max(res)
x2 <- mmin + (mmax -mmin)*(0:1000/1000)
# y_2 <- dnorm() # TODO

q.a <- lm(mod.a)
q.b <- lm(mod.b)
q.add <- lm(mod.add)
anova(q.b, q.s)

# когда проверяем сложную гипотезу о нормальном распределении,
# нужно помнить, что матожидание известно и равно нулю

AIC(q.s) # the least value is the best
AIC(q.add)

BIC(q.s) # Bayes criteria
BIC(q.add)
BIC(q.a)
BIC(q.b)