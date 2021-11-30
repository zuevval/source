# ANOVA

library(tidyverse)
dd <- data.frame(y = c(13.24, 11.55, 12.21, 11.54, 18.77, 16.51, 20.13, 18.22, 17.81, 13.76, 17.79, 16.83, 18.42, 19.86, 19.29, 19.04, 26.38, 26.73, 25.27, 29.77, 25.18, 26.78, 23.91, 25.41, 17.85, 18.14, 18.29, 17.85, 29.18, 27.87, 26.41, 25.86, 26.27, 22.76, 26.30, 24.11, 14.41, 16.61, 16.23, 15.64, 25.49, 23.85, 24.28, 21.53, 23.64, 20.01, 21.34, 21.19),
                 a = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4),
                 b = c(1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3))
dd <- dd %>% mutate(a = as.factor(a), b = as.factor(b))

# (a) ANOVA model

dd %>%
  group_by(a, b) %>%
  summarise(mean = mean(y), var = var(y)) %>%
  write.csv("anova2.csv")

# (b) plot

dd %>% ggplot(aes(x = a, y = y, color = b, shape = b, group = b)) +
  geom_point(aes(size = 10)) +
  stat_summary(geom = "line", fun = "mean") +
  theme_minimal()

# (c) residuals analysis

# TODO not exactly?
anova.add <- lm(y ~ a + b, data = dd)
summary(anova.add)
anova.add$residuals %>% hist(main = "ANOVA: residuals distribution")

# (d) Step-by-step ANOVA

anova.a <- lm(y ~ a, data = dd)
anova.b <- lm(y ~ b, data = dd)
anova.0 <- lm(y ~ 1, data = dd)

anova.models <- list(anova.add, anova.a, anova.b, anova.0)
names(anova.models) <- c("mult", "add", "a", "b", "0")

lapply(anova.models, summary)

# (e) choosing the best model

lapply(anova.models, AIC)
lapply(anova.models, BIC)
