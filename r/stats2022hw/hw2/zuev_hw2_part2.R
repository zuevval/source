library(tidyverse)
library(data.table)
library(lme4)
library(cAIC4) # cAIC - conditional Akaike information criterion

df <- here::here("r/stats2021fall/homework4", "IDZ4_Data_504020121.csv") %>%
  read.csv %>%
  filter(Variant == 4) %>%
  select(!Variant) %>%
  mutate(A = as.factor(A), B = as.factor(B)) # B is time-dependent, A is not (see LMM.R -> ATD, BTD)

# -----
# task 3
# -----

# plot with time variable (`Visit`)
colors <- c("green", "blue", "yellow")
png(filename = "traj_with_time.png", width = 700, height = 700)
plot(df$Visit, df$Y, "n")
for (i in df$ID[1:90]) {
  df.i <- df[df$ID == i,]
  color <- colors[df.i[1,]$A]
  points(df.i$Visit, df.i$Y, "l", col = color)
}
title("First 30 trajectories; green: A=1, blue: A=2")

traj.med <- NULL
for (i in 0:2) {
  traj.med <- c(traj.med, mean(df$Y[df$Visit == i]))
}
points(0:2, traj.med, "l", col = "red", lwd = 3)

traj.med.ai <- function(i_a) { 0:2 %>%
  lapply(function(i) filter(df, A == i_a, Visit == i)$Y %>% mean) %>%
  unlist }

points(0:2, traj.med.ai(0), col = "green", lwd = 5)
points(0:2, traj.med.ai(1), col = "blue", lwd = 5)
dev.off()

# to table (for correlations)
to_one_row <- function(dfi = ? data.frame) {
  res <- data.frame("ID" = dfi$ID[1], "A" = dfi$A[1])
  for (i_visit in dfi$Visit) {
    yvi_name <- paste0("Y_V", i_visit)
    res[yvi_name] <- dfi$Y[dfi$Visit == i_visit]
    ybi_name <- paste0("Y_B", i_visit)
    res[ybi_name] <- dfi$B[dfi$Visit == i_visit]
  }
  res
}

expand_tbl <- function(tbl = ? data.frame) {
  tbl %>%
    group_by(ID) %>%
    group_split %>%
    lapply(to_one_row) %>%
    rbindlist(fill = T)
}

df.id_grouped <- expand_tbl(df)
head(df.id_grouped) %>%
  xtable::xtable() %>%
  print(include.rownames = F)

# calculating correlations
df.ids <- unique(df$ID)
lv.a <- levels(df$A)
lv.b <- levels(df$B)
lv.visit <- levels(as.factor(df$Visit))

yv_names <- paste0("Y_V", lv.visit)
corr.all <- var(df.id_grouped[, names(df.id_grouped) %in% yv_names]) # YouT 2:21:15
# Correlations in groups: A effect only
for (ii in lv.a) {
  vnm_corr <- paste0("corr.a", ii)
  df.ii <- df[df$A == ii,]
  df.ii.tab <- expand_tbl(df.ii)
  df.ii.yv <- df.ii.tab %>% select(starts_with("Y_V"))
  assign(vnm_corr, cor(df.ii.yv))
}

corr.a0 %>% xtable::xtable() # корреляции внутри групп по значениям фактора A (без учёта фактора B)
corr.a1 %>% xtable::xtable() # видим, что корреляции довольно слабые, но при A=1 чуть выше и везде положительные

for (ia in lv.a)
  for (ib in lv.b) {
    vnm <- paste0("cor_a", ia, "_b", ib)
    assign(vnm,
           df %>%
             filter(A == ia, B == ib) %>%
             expand_tbl %>%
             select(starts_with("Y_V")) %>%
             cor(use = "pairwise.complete.obs")
    )
  }

cor_a0_b1 %>% xtable::xtable() # ковариационные характеристики при усилении группировки обычно не возрастают (в вероятностном смысле)
cor_a0_b2 %>% xtable::xtable() # Если зависимость однородная, они и не падают
cor_a0_b3 %>% xtable::xtable() # конечно, основное, что хотим посмотреть - насколько расходится с моделью независимости
cor_a1_b1 %>% xtable::xtable()

# variogram
library(nlme) # YouT 2:37:10
lme_model <- lme(Y ~ Visit, random = ~1 | ID, data = df)
lme.variogram <- Variogram(lme_model, form = ~Visit | ID) # на базе нормированных остатков (eps=1)
plot(lme.variogram) # 2:45:16
lme.variogram.resp <- Variogram(lme_model, form = ~Visit | ID, resType = "response") # остатки не нормированные
plot(lme.variogram.resp) # end ~ 2:51:16

# estimating correlation matrices using variograms. !! only for the group A == 0
stddevs.by.visit <- lv.visit %>%
  lapply(function(iv) {
    df.filtered <- filter(df, A == 0, Visit == iv)
    var(df.filtered$Y)
  }) %>%
  unlist %>%
  sqrt

var.residuals <- matrix(nrow = length(lv.visit), ncol = length(lv.visit))
for (i in seq_along(lv.visit))
  for (j in seq_along(lv.visit)) {
    if (i == j) var.residuals[i, j] <- stddevs.by.visit[i]
    else var.residuals[i, j] <- stddevs.by.visit[i] *
      stddevs.by.visit[j] *
      (1 - lme.variogram$variog[abs(i - j)])
  }
var.residuals %>% xtable::xtable()  # end ~ 2:57:22

# ----
# task 4. Mixed linear model with ID effect
# ----
fixed_parts <- list(
  Y ~ A * B * Visit,
  Y ~ A * Visit + B * Visit + A * B,
  Y ~ A * Visit + B * Visit,
  Y ~ A * Visit + A * B,
  Y ~ B * Visit + A * B,
  Y ~ A + B + Visit,
  Y ~ A + B,
  Y ~ A + Visit,
  Y ~ B + Visit,
  Y ~ Visit,
  Y ~ A,
  Y ~ B,
  Y ~ 1
)

no_rand_effects <- lapply(fixed_parts, function(fp) lm(fp, data = df))
no_rand.aic <- lapply(no_rand_effects, AIC)

df.lme.1_id <- list(
  lme(fixed = Y ~ A * B * Visit, random = ~1 | ID, data = df, method = "ML"),
  lme(fixed = Y ~ A * Visit + B * Visit + A * B, random = ~1 | ID, data = df, method = "ML"),
  lme(fixed = Y ~ A * Visit + B * Visit, random = ~1 | ID, data = df, method = "ML"),
  lme(Y ~ A * Visit + A * B, random = ~1 | ID, data = df, method = "ML"),
  lme(Y ~ B * Visit + A * B, random = ~1 | ID, data = df, method = "ML"),
  lme(Y ~ A + B + Visit, random = ~1 | ID, data = df, method = "ML"),
  lme(Y ~ A + B, random = ~1 | ID, data = df, method = "ML"),
  lme(Y ~ A + Visit, random = ~1 | ID, data = df, method = "ML"),
  lme(Y ~ B + Visit, random = ~1 | ID, data = df, method = "ML"),
  lme(Y ~ Visit, random = ~1 | ID, data = df, method = "ML"),
  lme(Y ~ A, random = ~1 | ID, data = df, method = "ML"),
  lme(Y ~ B, random = ~1 | ID, data = df, method = "ML"),
  lme(Y ~ 1, random = ~1 | ID, data = df, method = "ML")
)

df.lme.var_id <- list(
  lme(fixed = Y ~ A * B * Visit, random = ~Visit | ID, data = df, method = "ML"),
  lme(fixed = Y ~ A * Visit + B * Visit + A * B, random = ~Visit | ID, data = df, method = "ML"),
  lme(fixed = Y ~ A * Visit + B * Visit, random = ~Visit | ID, data = df, method = "ML"),
  lme(Y ~ A * Visit + A * B, random = ~Visit | ID, data = df, method = "ML"),
  lme(Y ~ B * Visit + A * B, random = ~Visit | ID, data = df, method = "ML"),
  lme(Y ~ A + B + Visit, random = ~Visit | ID, data = df, method = "ML"),
  lme(Y ~ A + B, random = ~Visit | ID, data = df, method = "ML"),
  lme(Y ~ A + Visit, random = ~Visit | ID, data = df, method = "ML"),
  lme(Y ~ B + Visit, random = ~Visit | ID, data = df, method = "ML"),
  lme(Y ~ Visit, random = ~Visit | ID, data = df, method = "ML"),
  lme(Y ~ A, random = ~Visit | ID, data = df, method = "ML"),
  lme(Y ~ B, random = ~Visit | ID, data = df, method = "ML"),
  lme(Y ~ 1, random = ~Visit | ID, data = df, method = "ML")
)

lm.pv <- function(lm_simple, lm_general) {
  anova.res <- anova(lm_general, lm_simple)
  anova.res[["p-value"]][2]
}

lm.1_id.pvals <- mapply(lm.pv, no_rand_effects, df.lme.1_id)
lm.var_id.pvals <- mapply(lm.pv, no_rand_effects, df.lme.var_id)
lm.1_vs_var_id.pvals <- mapply(lm.pv, df.lme.1_id, df.lme.var_id)

lm.1_id.caic <- lapply(df.lme.1_id, function(model) cAIC(model)$caic)
lm.var_id.caic <- lapply(df.lme.var_id, function(model) cAIC(model)$caic)

lm.results <- data.frame("fixed part" = as.character(fixed_parts),
                         "AIC" = unlist(no_rand.aic),
                         "cAIC (1|ID)" = unlist(lm.1_id.caic),
                         "cAIC (Visit|ID)" = unlist(lm.var_id.caic),
                         "p-value: no random VS (1|ID)" = lm.1_id.pvals,
                         "p-value: (1|ID) VS (Visit|ID)" = lm.1_vs_var_id.pvals)

lm.results %>%
  xtable::xtable() %>%
  print(include.rownames = F)


# ----
# task 5. Mixed linear model with Visit (time) effect
# ----

lme.b.additive <- function(data) lmer(Y ~ B + Visit + (Visit | ID), data = data, REML = F)
lme.b.general <- function(data) lmer(Y ~ B * Visit + (Visit | ID), data = data, REML = F)
dev.null <- levels(df$A) %>% lapply(function(a.lvl = ? factor) {
  print(paste("A =", a.lvl))
  data <- df %>% filter(A == a.lvl)
  lm.add <- data %>% lme.b.additive
  lm.general <- data %>% lme.b.general

  anova(lm.add, lm.general) %>% print
  #%>% AIC %>% print
})

lme.ab <- lmer(Y ~ A + B + Visit + (Visit | ID), data = df, REML = F)
lme.b <- lmer(Y ~ B + Visit + (Visit | ID), data = df, REML = F)
anova(lme.b, lme.ab)


# ----
# Task 6
# ----

library(geepack)

gee.models <- fixed_parts %>% lapply(function(fp) geeglm(fp, id = ID, data = df, corstr = "unstructured"))
gee.anova <- gee.models[2:length(gee.models)] %>% lapply(function(simple.model) anova(simple.model, gee.models[[1]])$`P(>|Chi|)`)

gee.results <- data.frame(
  "model" = as.character(fixed_parts[2:length(fixed_parts)]),
  "p-value" = unlist(gee.anova)
)

gee.results %>%
  xtable::xtable() %>%
  print(include.rownames = F)

# ----
# Task 7
# ----

df.Visit2 <- df %>% mutate(Visit2 = Visit^2)
lm.polynom <- lmer(Y ~ Visit + Visit2 + (1 | ID), data = df.Visit2, REML = F)
lm.linear <- lmer(Y ~ Visit + (1 | ID), data = df.Visit2, REML = F)
anova(lm.polynom, lm.linear)

# ----
# Task 8
# ----

lm.1_id.bic <- lapply(df.lme.1_id, function(model) BIC(model))

data.frame("model" = as.character(fixed_parts),
           "cAIC" = unlist(lm.1_id.caic),
           "BIC" = unlist(lm.1_id.bic)) %>%
  xtable::xtable() %>%
  print(include.rownames = F)

df.lme.1_id[[8]]

# ----
# Task 9
# ----

lm.Visit2 <- lme(Y ~ Visit + Visit2, random = ~Visit | ID, data = df.Visit2) # best = lm.polynom
intervals(lm.Visit2, which = "fixed")
