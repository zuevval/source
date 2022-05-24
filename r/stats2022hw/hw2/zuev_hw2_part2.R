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

# calculating correlations
df.ids <- unique(df$ID)
lv.a <- levels(df$A)
lv.b <- levels(df$B)
lv.visit <- levels(as.factor(df$Visit))

yv_names <- paste0("Y_V", lv.visit)
corr.all <- var(df.id_grouped[, names(df.id_grouped) %in% yv_names]) # YouT 2:21:15
# Correlations in groups: A effect only
for (ii in lv.a) {
  vnm <- paste0("var.a", ii)
  vnm_corr <- paste0("corr", ii)
  df.ii <- df[df$A == ii,]
  df.ii.tab <- expand_tbl(df.ii)
  df.ii.yv <- df.ii.tab %>% select(starts_with("Y_V"))
  assign(vnm, var(df.ii.yv))
  assign(vnm_corr, cor(df.ii.yv))
}
var.a0
var.a1
corr0 # корреляции внутри групп по значениям фактора A (без учёта фактора B)
corr1 # видим, что корреляции довольно слабые, но при A=1 чуть выше и везде положительные

for (ia in lv.a)
  for (ib in lv.b) {
    vnm <- paste0("cor_a", ia, "_b", ib)
    assign(vnm,
           df %>%
             filter(A == ia, B == ib) %>%
             expand_tbl %>%
             select(starts_with("Y_V")) %>%
             var(use = "pairwise.complete.obs")
    )
  }

cor_a0_b1 # ковариационные характеристики при усилении группировки обычно не возрастают (в вероятностном смысле)
cor_a0_b2 # Если зависимость однородная, они и не падают
cor_a0_b3 # конечно, основное, что хотим посмотреть - насколько расходится с моделью независимости
cor_a1_b1

# variogram
library(nlme) # YouT 2:37:10
lme_model <- lme(Y ~ Visit, random = ~1 | ID, data = df)
lme.variogram <- Variogram(lme_model, form = ~Visit | ID) # на базе нормированных остатков (eps=1)
plot(lme.variogram) # 2:45:16
lme.variogram.resp <- Variogram(lme_model, form = ~Visit | ID, resType = "response") # остатки не нормированные
plot(lme.variogram.resp) # end ~ 2:51:16

# estimating covariance matrices using variograms. !! only for the group A == 0
stddevs.by.visit <- lv.visit %>%
  lapply(function(iv) {
    df.filtered <- filter(df, A == 0)
    var(df.filtered$Y[df.filtered$Visit == iv])
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
var.residuals # end ~ 2:57:22

# ----
# task 4. Mixed linear model with ID effect
# ----

df.lme <- function(rand_part = ? formula) lme(fixed = Y ~ Visit, random = rand_part, data = df, method = "ML")
lme.simple <- df.lme(rand_part = ~1 | ID)
lme.linear <- df.lme(rand_part = ~Visit | ID)

cAIC(lme.simple)
cAIC(lme.linear)

# ----
# task 5. Mixed linear model with Visit (time) effect
# ----

