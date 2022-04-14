#CATEGORICAL DATA ANALYSIS
library(tidyverse)
read_tbl <- function(fname) here::here("r/stats2021fall/2022_02_22_biostats_start/data", fname) %>% read.table(header = T, as.is = T, sep = ",")
# Aspirin & Heart attack (Table 2.3, page 20)
dat <- read_tbl("Aspirin.csv")

f.tbl <- function(dat) {
  a <- levels(as.factor(dat[, 1]))
  b <- levels(as.factor(dat[, 2]))
  la <- length(a)
  lb <- length(b)
  out <- matrix(nrow = la, ncol = lb)
  for (i in 1:la)
    for (j in 1:lb) {
      ftr <- dat[, 1] == a[i] & dat[, 2] == b[j]
      out[i, j] <- sum(dat$Count[ftr])
    }
  colnames(out) <- b
  rownames(out) <- a
  out
}

d.tab <- f.tbl(dat)
colnames(d.tab) <- c("NoMI", "MI")
rownames(d.tab) <- c("Placebo", "Aspirin")
# Plot
# proportions
p <- d.tab[, 2] / rowSums(d.tab)
# odds ratio
OR <- d.tab[1, 1] * d.tab[2, 2] / d.tab[2, 1] / d.tab[1, 2] # отношение шансов
LOR <- log(OR) # чтобы построить доверительный интервал для отношения шансов, переходим к логарифмам
ASE.or <- sqrt(sum(1 / d.tab))
al <- 0.05
x.al <- qnorm(al / 2, lower.tail = FALSE)
CI.L <- c(LOR - x.al * ASE.or, LOR + x.al * ASE.or)
CI <- exp(CI.L)
CI <- t(as.matrix(CI)) # доверительный интервал содержит единицу, поэтому стат. значимого результата мы не добились
colnames(CI) <- c(paste0(as.character(al * 100 / 2), "%"), paste0(as.character((1 - al / 2) * 100), "%"))
# Tests
csq <- chisq.test(d.tab, correct = F)
csqs <- chisq.test(d.tab, correct = F, simulate.p.value = T)
fex <- fisher.test(d.tab)

# Выводы: нельзя делать выводы только на основании оценок.
# В большой популяции эффект проявляется, причём совсем другой, чем в маленькой.
# Впрочем, мы не делали об

# Обобщённые линейные модели

d.glm <- function(dat) { # была таблица 2*2, переводит в массив исходных - "сырых" данных
  a <- levels(as.factor(dat[, 1]))
  b <- levels(as.factor(dat[, 2]))
  la <- length(a)
  lb <- length(b)
  out <- data.frame(id = c(1:sum(dat$Count)))
  mi <- NULL
  asp <- NULL
  for (i in 1:la)
    for (j in 1:lb) {
      ftr <- dat[, 1] == a[i] & dat[, 2] == b[j]
      asp <- c(asp, array(a[i], dim = sum(dat$Count[ftr])))
      mi <- c(mi, array(b[j], dim = sum(dat$Count[ftr])))
    }
  out$asp <- as.numeric(asp)
  out$mi <- as.numeric(mi)
  return(out)
}

# TODO not working
glm.d <- d.glm(dat)
# check
table(glm.d[, c(2, 3)])
#
# asp.f<-as.factor(asp)
g.res <- glm(mi ~ asp, data = glm.d, family = "binomial")
g.null <- glm(mi ~ 1, data = glm.d, family = "binomial")
LLR <- g.null$deviance - g.res$deviance
LRPval <- pchisq(LLR, 1, lower.tail = F)
#
gr.s <- summary(g.res)
gr.a <- anova(g.res)
# независимость определяется тем, что модель аддитивная

# More then 2x2 (Table 2.15, page 49)
dat <- read_tbl("Breast_cancer.csv")
dat$Count <- dat$Count - 0.5
d.tab <- f.tbl(dat)
d.tab2 <- d.tab
d.tab2[2,] <- d.tab2[2,] + d.tab2[3,]
d.tab2 <- d.tab2[-3,]

d.raw <- data.frame(exp = mapply(function(a,b) {rep(b,a)}, colSums(d.tab2), colnames(d.tab2)) %>% unlist,
                    resp=mapply(function(a, b){rep(b,a)}, rowSums(d.tab2), rownames(d.tab2)) %>% unlist) # TODO much longer than expected?

# Tests
csq <- chisq.test(d.tab, correct = F)
csqs <- chisq.test(d.tab, simulate.p.value = T)
csqs_million <- chisq.test(d.tab, simulate.p.value = T, B = 1e6)
fex <- fisher.test(d.tab)

dd <- d.glm(dat) # это для логистической регрессии, но логистическую регрессию здесь не реализовать, поскольку три уровня
r <- cor(dd[, c(2, 3)])
#
g.res <- glm(Count ~ as.factor(Exp) * as.factor(Resp), data = dat, family = "poisson")
g.null <- glm(Count ~ as.factor(Exp) + as.factor(Resp), data = dat, family = "poisson")
LLR <- g.null$deviance - g.res$deviance
LRPval <- pchisq(LLR, 4, lower.tail = F)
# HWK (Extanded data) 
dat <- read.table("Aspirin2.csv", header = T, as.is = T, sep = ",")
# HWK (Table 2.4, page 26)
dat <- read.table("Smoking_MI.csv", header = T, as.is = T, sep = ",")
# HWK ()
dat <- read.table("Larinx.csv", header = T, as.is = T, sep = ",")
# 

