# variant 4
library(coin) # cmh_test
library(tidyverse)

data_path <- function(filename) here::here("r/stats2022hw", filename)

df.male <- data.frame("yes" = c(512, 353, 120, 138, 53, 22),
                      "no" = c(313, 207, 205, 279, 138, 351))
df.female <- data.frame("yes" = c(89, 17, 202, 131, 94, 24),
                        "no" = c(19, 8, 391, 244, 299, 317))

df.combined <- bind_rows(
  data.frame("gender" = "male", "admitted" = df.male$yes / (df.male$yes + df.male$no), "department" = row.names(df.male)),
  data.frame("gender" = "female", "admitted" = df.female$yes / (df.female$yes + df.female$no), "department" = row.names(df.female))
)

# --------
# Task 1: grahpical representation
# --------

ggplot(data = df.combined, aes(x = department, y = admitted, fill = gender)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  theme_minimal() +
  ggtitle("proportion of admitted males and females")
ggsave(data_path("admitted_stats.png"), scale = .3)

# ------
# Task 2: Chi squared, CMH-test
# -----
df.admitted <- data.frame("males" = df.male$yes, "females" = df.female$yes)
chisq.test(df.admitted)
cmh_test(df.admitted)

df.comb.counts <- bind_rows(
  data.frame("gender" = "male", "admitted" = "yes", "count" = df.male$yes),
  data.frame("gender" = "male", "admitted" = "no", "count" = df.male$no),
  data.frame("gender" = "female", "admitted" = "yes", "count" = df.female$yes),
  data.frame("gender" = "female", "admitted" = "no", "count" = df.female$no)
) %>% mutate(gender = as.factor(gender), admitted = as.factor(admitted))

crosstab <- xtabs(count ~ gender + admitted, df.comb.counts)
chisq.test(crosstab)
cmh_test(crosstab)

# ----
# Task 3: logistic regression
# ----

df.comb.4glm <- df.combined %>% mutate(gender = as.factor(gender), department = as.factor(department))

formulas <- c(
  admitted ~ 1,
  admitted ~ gender,
  admitted ~ department,
  admitted ~ gender + department,
  admitted ~ gender * department
)

models <- lapply(formulas, function(f) glm(f, data = df.comb.4glm, family = "binomial"))
models

# ----
# Task 4. Poisson
# ----


