# Title     : Working with samples
# Created by: vzuev
# Created on: 05.10.2021
library(ggridges)
library(tidyverse)

set.seed(0)
n <- 100
data <- data.frame(
  x = c(rnorm(n=n, mean=1, sd=2), rexp(n=n)), dist = c(0*n + 1, 0*n ))

# barplot, boxplot, kernel density estimate, ...

# ggplot(data, aes(x = x, y = dist, fill=dist)) +
#   geom_density_ridges() +
#   theme_ridges() +
#   theme(legend.position = "none")
