#
source(here::here("r/stats2021fall/2021_10_12/loadDiabetData.r"))
dd <- diabetData
head(dd)

# Chol  / location, gender, frame, bmi
dd.c <- dd[, c("chol", "location", "gender", "frame", "bmif")]
dd.c <- dd.c[rowSums(is.na(dd.c)) == 0,]
boxplot(dd.c$chol ~ dd.c$location, na.rm = TRUE, xlab = "Location", ylab = "Cholesterol", col = c("blue", "red"))
boxplot(dd.c$chol ~ dd.c$location * dd.c$gender, na.rm = TRUE, xlab = "Location:gender", ylab = "Cholesterol", col = c("blue", "red"))
boxplot(dd.c$chol ~ dd.c$bmif, na.rm = TRUE, xlab = "Body index", ylab = "Cholesterol", col = c("yellow", "green", "blue", "red"))

# naive (very asymptotic) confidence intervals estimation

## mean, variance, mse, particular confint
lv.l <- levels(dd.c$location)
lv.g <- levels(dd.c$gender)
#
al <- 0.05 # significance level
bnf <- length(lv.l) * length(lv.g) # denominator for bonferroni correction
st.table1 <- list(Location = NULL, Gender = NULL, Mean = NULL, MSE = NULL, CI.naive.LW = NULL, CI.naive.UP = NULL, CI.jnaive.LW = NULL, CI.jnaive.UP = NULL)
for (i in seq_along(lv.l))
  for (j in seq_along(lv.g)) {
    st.table1$Location <- c(st.table1$Location, lv.l[i])
    st.table1$Gender <- c(st.table1$Gender, lv.g[j])
    dd.cij <- dd.c[dd.c$location == lv.l[i] & dd.c$gender == lv.g[j],]
    m.ij <- mean(dd.cij$chol)
    mse.ij <- sqrt(var(dd.cij$chol)) # mean square error (`var`: not biased)
    n.ij <- dim(dd.cij)[1]
    xa <- qnorm(1 - al / 2) # quantile
    xaj <- qnorm(1 - al / 2 / bnf) # quantile + Bonferroni

    st.table1$MSE <- c(st.table1$MSE, mse.ij)
    st.table1$CI.naive.LW <- c(st.table1$CI.naive.LW, m.ij - xa * mse.ij / sqrt(n.ij)) # confidence interval // naive // lower bound
    st.table1$CI.naive.UP <- c(st.table1$CI.naive.UP, m.ij + xa * mse.ij / sqrt(n.ij))
    st.table1$CI.jnaive.LW <- c(st.table1$CI.jnaive.LW, m.ij - xaj * mse.ij / sqrt(n.ij))
    st.table1$CI.jnaive.UP <- c(st.table1$CI.jnaive.UP, m.ij + xaj * mse.ij / sqrt(n.ij))
  }
#
st.table1 <- as.data.frame(st.table1)
#

# st.bmif <- list(Bmif = NULL, MSE = NULL, Naive.LW = NULL, naive.UP = NULL, jnaive.LW = NULL, jnaive.UP = NULL)
st.bmif <- list() # list of dataframes
lv.bmif <- levels(as.factor(dd$bmif))

lapply(lv.bmif, function(ff = ? factor) {
  dd.ci <- dd.c[dd.c$bmif == ff]
  # st.bmif[[length(st.bmif) + 1]] <- ff
})

# we could calculate the power of our Welch test using simulation, but we will not do it
library(pwr)
pwr.c <- pwr.t2n.test()
## tests chol - location
qp.c <- t.test(chol ~ location, data = dd.c) # Welch test

# Lecture 19-oct-2021

qnp.c <- wilcox.test(chol ~ location, data = dd.c, conf.int = TRUE) # Wilcoxon (wɪlˈkɒksən)
lv <- levels(as.factor(dd.c$location))
ksp.c <- ks.test(dd.c$chol[dd.c$location == lv[1]], dd.c$chol[dd.c$location == lv[2]]) # Kolmogorov-Smirnov
# Kolmogorov does not work for discrete distributions; when distributions are continuous and variables are independent,
# the probability of two samples to be the same equals ZERO.
# Kolmogorov criteria is not very powerful (though it is universal)

## tests chol - bmi
dd.c$bmi2 <- "NORMAL"
dd.c$bmi2[dd.c$bmif %in% c("Obesity", "Over")] <- "OVER"
boxplot(dd.c$chol ~ dd.c$bmi2, na.rm = TRUE, xlab = "Body index", ylab = "Cholesterol", col = c("yellow", "green"))

# now we compare m1-m2, m2-m3, m1-m3, ... (6 tests) and apply Bonferroni correction

alpha <- .5
bmif.lv <- levels(as.factor(dd.c$bmif))
n.pairs <- choose(length(bmif.lv), 2)

alj <- alpha / n.pairs
st.bmi <- data.frame(g1 = character(), g2 = character(), pv = double(), stat = double(), ci_up = double(), ci_low = double())
st.bmi <- apply(combn(bmif.lv, 2), 2, function(lv.pair = ? character) {
  g1 <- lv.pair[1] # group 1
  g2 <- lv.pair[2] # group 2
  t.res <- t.test(chol ~ bmif, data = dd.c %>% filter(bmif %in% lv.pair))
  data.frame(g1 = g1, g2 = g2, pv = t.res$p.value, stat = t.res$statistic, ci_lw = t.res$conf.int[1], ci_up = t.res$conf.int[2])
} -> data.frame) %>% bind_rows

dd$gl

# TODO homework: the same for glucoze, HDL, glyhb
# diabet: glyhb > 7; find out whether glyhb depends on the BMI

# Glucose /
dd.g <- dd[, c("stab.glu", "location", "gender", "frame", "bmif")]
dd.g <- dd.g[rowSums(is.na(dd.g)) == 0,]
boxplot(dd.g$stab.glu ~ dd.g$location + dd.g$gender, na.rm = TRUE, xlab = "Location:gender", ylab = "Glucose", col = c("blue", "red"))
boxplot(dd.g$stab.glu ~ dd.g$bmif, na.rm = TRUE, xlab = "Body index", ylab = "Glucose", col = c("yellow", "green", "blue", "red"))
# HDL
dd.h <- dd[, c("hdl", "location", "gender", "frame", "bmif")]
dd.h <- dd.h[rowSums(is.na(dd.h)) == 0,]
boxplot(dd.h$hdl ~ dd.h$location + dd.h$gender, na.rm = TRUE, xlab = "Location:gender", ylab = "HDL", col = c("blue", "red"))
boxplot(dd.h$hdl ~ dd.h$bmif, na.rm = TRUE, xlab = "Body index", ylab = "HDL", col = c("yellow", "green", "blue", "red"))
# HEMOGL
dd.hg <- dd[, c("glyhb", "location", "gender", "frame", "bmif")]
dd.hg <- dd.hg[rowSums(is.na(dd.hg)) == 0,]
dd.hg$diabet <- as.numeric(dd.hg$glyhb > 7)
table(dd.hg$diabet, dd.hg$bmif)
boxplot(dd.hg$glyhb ~ dd.hg$location + dd.hg$gender, na.rm = TRUE, xlab = "Location:gender", ylab = "Hemoglobin", col = c("blue", "red"))
boxplot(dd.hg$glyhb ~ dd.hg$bmif, na.rm = TRUE, xlab = "Body index", ylab = "Hemoglobin", col = c("yellow", "green", "blue", "red"))
##
ftr <- !is.na(dd$glyhb) & !is.na(dd$bmi)
cr <- cor(dd$glyhb[ftr], dd$bmi[ftr])
p.test <- cor.test(dd$glyhb[ftr], dd$bmi[ftr])
## Diabet
csq.d <- chisq.test(dd.hg$diabet, dd.hg$bmif)
csq.d <- chisq.test(dd.hg$diabet, dd.hg$bmif, simulate.p.value = TRUE)
ft.d <- fisher.test(dd.hg$diabet, dd.hg$bmif)
### Obesity2
dd.hg$bmif2 <- dd.hg$bmif
dd.hg$bmif2[dd.hg$bmif == "Under" | dd.hg$bmif == "Normal"] <- "Under"
dd.hg$bmif2[dd.hg$bmif == "Over" | dd.hg$bmif == "Obesity"] <- "Over"
table(dd.hg$diabet, dd.hg$bmif2)
csq.d2 <- chisq.test(dd.hg$diabet, dd.hg$bmif2)
ft.d2 <- fisher.test(dd.hg$diabet, dd.hg$bmif2)
# SBP
dd.s <- dd[, c("bp.1s", "location", "gender", "frame", "bmif")]
dd.s <- dd.s[rowSums(is.na(dd.s)) == 0,]
boxplot(dd.s$bp.1s ~ dd.s$location + dd.g$gender, na.rm = TRUE, xlab = "Location:gender", ylab = "SBP", col = c("blue", "red"))
boxplot(dd.s$bp.1s ~ dd.s$bmif, na.rm = TRUE, xlab = "Body index", ylab = "SBP", col = c("yellow", "green", "blue", "red"))
# DBP
dd.d <- dd[, c("bp.1d", "location", "gender", "frame", "bmif")]
dd.d <- dd.d[rowSums(is.na(dd.d)) == 0,]
boxplot(dd.d$bp.1d ~ dd.d$location + dd.g$gender, na.rm = TRUE, xlab = "Location:gender", ylab = "SBP", col = c("blue", "red"))
boxplot(dd.d$bp.1d ~ dd.d$bmif, na.rm = TRUE, xlab = "Body index", ylab = "SBP", col = c("yellow", "green", "blue", "red"))
####### 

# Построить доверительный интервал для разности средних по группам с различным Location (без учёта пола) и сравнить с тем, что даёт критерий Велча.
# Построить совместные доверительные интервалы для разности средних (по BMIF) - три разных: между ожирением и высоким весом; высоким весом и нормальным весом; нормальным весом и недовесом
# Это показать
