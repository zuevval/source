# variant 4
library(coin) # cmh_test
library(tidyverse)
library(xtable)

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

df.comb.counts <- bind_rows(
  data.frame("gender" = "male", "admitted" = "yes", "count" = df.male$yes, "department" = row.names(df.male)),
  data.frame("gender" = "male", "admitted" = "no", "count" = df.male$no, "department" = row.names(df.male)),
  data.frame("gender" = "female", "admitted" = "yes", "count" = df.female$yes, "department" = row.names(df.female)),
  data.frame("gender" = "female", "admitted" = "no", "count" = df.female$no, "department" = row.names(df.female))
) %>% mutate(gender = as.factor(gender), admitted = as.factor(admitted),
             department = as.factor(department), count = as.integer(count))

xtable(df.comb.counts, type = "latex") %>% print(include.rownames = F)

crosstab <- xtabs(count ~ gender + admitted, df.comb.counts)
chisq.test(crosstab)

crosstab.by.department <- xtabs(count ~ gender + admitted + department, df.comb.counts)
cmh_test(crosstab.by.department)

# ----
# Task 3: prepare data for regression
# ----

#df.comb.4glm <- df.combined %>% mutate(gender = as.factor(gender), department = as.factor(department))
df.comb.cases <- uncount(df.comb.counts, count)
unique(df.comb.cases) %>%
  head(4) %>%
  xtable(type = "latex")

# ----
# Task 4: logistic regression
# ----

formulas <- c(
  admitted ~ 1,
  admitted ~ gender,
  admitted ~ department,
  admitted ~ gender + department,
  admitted ~ gender * department
)

models.aic <- lapply(formulas, function(f) glm(f, data = df.comb.cases, family = "binomial")$aic) %>% unlist
data.frame("model" = as.character(formulas), "AIC" = models.aic) %>%
  xtable(type = "latex") %>%
  print(include.rownames = F)

# ----
# Task 5. Poisson
# ----

poiss.general <- glm(count ~ gender * admitted * department, data = df.comb.counts, family = "poisson")
poiss.homogenous <- glm(count ~
                          gender * admitted +
                            gender * department +
                            admitted * department,
                        data = df.comb.counts, family = "poisson")
poiss.llr <- poiss.homogenous$deviance - poiss.general$deviance
poiss.llr.pvalue <- pchisq(poiss.llr, df = poiss.homogenous$df.residual, lower.tail = F)
poiss.llr.pvalue

poiss.independent <- glm(count ~ gender * department + admitted * department, data = df.comb.counts, family = "poisson")
poiss.independent.llr <- poiss.independent$deviance - poiss.general$deviance
poiss.independent.llr.pvalue <- pchisq(poiss.independent.llr, df = poiss.independent$df.residual, lower.tail = F)

df.comb.counts %>%
  group_by(gender, admitted) %>%
  summarise(count = sum(count)) %>%
  ggplot(aes(x = gender, y = count, fill = admitted)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  theme_minimal() +
  ggtitle("Total count of admitted / not admitted across all departments")
ggsave(data_path("total_counts.jpg"), scale = .3)

# -----
# print LaTeX
# -----
df.male %>%
  merge(df.female, by = 0, suffixes = c(".male", ".female")) %>%
  select(!Row.names) %>%
  mutate_all(as.integer) %>%
  xtable(type = "latex")
