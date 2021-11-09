n <- 100
al <- c(10, 2, .1)
sigm <- 1

# Generating input data
set.seed(0)
z <- sample(1:4, n, replace = T)
eps <- rnorm(n, 0, sigm) # random error
y <- al[1] + al[2] * z + al[3] + z^2 + eps

# Fitting linear regression
x <- z
lin.regr <- lm(y ~ x)

summary(lin.regr)
anova(lin.regr) # F-value: `x` does not change `y`
confint(lin.regr)

bhat <- lin.regr$coefficients # least squares estimate

library(tidyverse)

data <- data.frame(x = x, y = y, y_estimate = bhat[1] + bhat[2] * x)
data %>% ggplot(aes(x, y)) +
  geom_point() +
  geom_line(aes(x = x, y = y_estimate), color = "red") +
  ggtitle("Linear regression") +
  theme_bw()

# Second model

x2 <- x^2
regr.altern <- lm(y ~ x + x2)
bhat2 <- regr.altern$coefficients

data %>% mutate(x2 = x2) %>% ggplot(aes(x, y)) +
  geom_point() +
  geom_line(aes(x = x, y = bhat2[1] + bhat2[2] * x + bhat2[3] * x2))

##
n <- length(y)
xm <- t(matrix(c(array(1, dim = n), x), nrow = n, ncol = 2))
ym <- as.matrix(y)
s <- xm %*% t(xm) # %*% is matrix multiplication and `t` is transpose operator
s1 <- solve(s)
bhat2.manual <- (s1 %*% xm %*% ym) %>% as.matrix

##

# in the second task we need to calculate the unbiased variance estimate.
# it is provided in the `summary(...)`
# we can calculaate it manually using residuals

# TODO some

##
n <- length(y)
xm.2 <- t(matrix(c(array(1,dim=n),x,x^2),nrow = n, ncol = 3))
ym.2 <- as.matrix(y)
s.2 <- xm.2 %*% t(xm.2)
s1.2 <- solve(s.2)

# TODO a bit
# тонкость: хи-квадрат по умолчанию только с одним параметром (дисперсия)
