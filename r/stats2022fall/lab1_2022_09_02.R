# Title     : ...TODO
# Created by: vzuev
# Created on: 02.09.2022

# фенотип -- две колонки: пол и наличие HIV ()

# install.packages("BiocManager")
library(tidyverse)

 list(
   "gdsfmt",
   "SNPRelate",
   "vcfR",
   "HardyWeinberg"
 ) %>% lapply(function(pkg.name) BiocManager::install(pkg.name))

library(gdsfmt) # internal R format for genetic data
library(SNPRelate)
library(vcfR)
library(HardyWeinberg)

dat.f <- openfn.gds("TODO") # TODO
pht <- read.gdsn(index.gdsn(dat.f, "sample.annot"))
dim(pht)

table(pht[, 2])
table(pht[, 1])

# -------------------------------------
setwd("TODO")
#
vcf.fn <- "genotype10.vcf.gz"
dat.fn <- "phenotype_10.txt"
gds.fn <- "DATA.gds"

snpgdsVCF2GDS(vcf.fn, gds.fn)
dat.f <- snpgdsOpen(gds.fn, readonly = F)
sa <- add.gdsn(dat.f, "snp.annot", val = NULL, compress = "ZIP", closezip = T, replace = T)
delete.gdsn(sa, T)
add.gdsn(dat.f, "sample.annot", val = pht, compress = "ZIP", closezip = T)
spngdsClose(dat.f)

dat.f <- snpgdsOpen(gds.fn)
d2 <- read.gdsn(index.gdsn(dat.f, "sample.annnot"))
snpgdsClose(dat.f)

levels(as.factor(d2$sex))
levels(as.factor(d2$phenotype))
table(d2$sex, d2$phenotype)
sum(table(d2$sex))
sum(table(d2$phenotype))

# MAF (частота минорной аллели) надо проверять
dat.f <- snpgdsOpen(gds.fn)
gen <- read.gdsn(index.gdsn(dat.f, "genotype"))
snpgdsClose(dat.f)
gen2 <- gen
gen2[gen2 == 3] <- NA
maf <- colSums(gen, na.rm = T) / (colSums(!is.na(gen2)) * 2)
nn <- which(maf > .5)[1:5]

# коэффициент гетерозиготности
htr <- colSums(gen2 == 1) / colSums(gen3)
e.htr <- 2 * maf * (1 - maf)
#
max(htr / e.htr)
min(htr / e.htr)

# call rate
cr <- colSums(gen3) / dim(gen)[1]
min(cr)

# QC
ftr.cr <- cr >= .95
ftr.maf <- maf >= .05
# ftr.hwe <-
# HWE test

f.ctr <- d2$phenotype == 2 # ctr <-> control
gen.ctr <- gen[f.ctr,]
ant.ctr <- data.frame(
  AA = colSums(gen.ctr == 0), # allele AA
  AB = colSums(gen.ctr == 1),
  BB = colSums(gen.ctr == 2)
)
ant.ctr.mtx <- as.matrix(ant.ctr)

hwe.ctr <- lapply(seq_along(chr),
                  function(x) {
                    HWExact(ant.ctr1[i,]) # TODO
                  })
for (i in seq_along(chr)) {

}

# Sept 30, 2022

ant$colr <- NA
ant$cc <- NA
ant$colr[ant$phenotype == 1] <- "blue"
ant$colr[ant$phenotype == 2] <- "red"
ant$cc[ant$phenotype == 1] <- "control"
ant$cc[ant$phenotype == 2] <- "case"

# smp <- amp$

par(xpd = T)
legend()
pdf("PCA-4", width = 9, height = 6)


vec <- q$eigenvect
x <- vec[, 1]
y <- vec[, 2]
z <- vec[, 3]
t <- vec[, 4]

plot(x, y, "n")
# TODO some
q$varprop # principal components
dat.f <- snpgdsOpen("DATA_PC2.gds")
id <- read.gdsn(index.gdsn(dat.f, "sample.id"))
snp <- read.gdsn(index.gdsn(dat.f, "snp.id"))
snp.subset <- snpgdsLDpruning(dat.f)
snpset <- as.character(sample(unlist(snp.subset),
                              500 # sample size; if takes too slow, use lower value; 100 seems to be reasonable
))
mibd <- snpgdsIBDMLE(dat.f, snp.id = snpset, kinship = T)
snpgdsClose(dat.f)

names(mibd)
max(mibd$kinship)

d1 <- snpgsIBDSelect(mibd, kinship, cutoff = 1 / 8)

# Oct 07, 2022
# TODO some
# combined Fisher's + chi-squared test
# нужно подготовить 4 линейки: для доминантного, рецессивного, кодоминантного и аллельного тестирования

pth.dk <- "DATA_FINAL.gds"
dat.f <- openfn.gds(pth.dk, readonly = T)
phtpe <- read.gdsn(index.gdsn(data.f, "phenotype"))
genotype <- read.gdsn(index.gdsn(data.f, "genotype"))
annot <- read.gdsn(index.gdsn(data.f, "explanatory"))
closefn.gds(data.f)
ant <- annot[, 1:3] > 0

dg <- dim(genotype)
num.p <- dg[1]
num.g <- dg[2]

# ------
# "I'll share it later"
# ------
tests <- data.frame(test=NULL, snp=NULL, pv=NULL, stt=stt)
for (alt in list("d", "cd", "r", "a")) {
  # TODO openfn.gds/closefn.gds here?
  if (alt == "d") { # dominant test # "I'll share it later"
    # n.lvl <- ant[,1] & (ant[, 2] | ant[, 3])
    # gen <- (1 - )

    # Oct 14th
    # если значение генотипа 1, то только в первой части будет 1, в остальных 0
    # тройка в любом случае записывается и там, и там...
    pv <- array(dim=num.g)
    # Строим P-значение для статистики. Что возьмём в качестве статистики?
    # Есть два отношения шансов. Можно максимальное из них
    # Мы не знаем, что лучше -- основная или альтернативная аллель. Лучше всего гетерозигота
    # Можно попробовать считать коэффициент корреляции?
    stt <- array(dim=num.g)
    for (j in 1:num.g){
      gg <- gen[, j] # выбрали из генотипа соответствующий вектор, на котором проводим тест
      gg[gg == 3] <- NA # значения этих генотипов (3 - потерянное значение) в таблицу не войдут!
      tt <- table(pht, gg)
      if (min(dim(tt)) >= 2) {
        if(alt == "cd"){
          tst <- chisq.test(tt)
        }
        # TODO
      }

    } # сперва проводим скрининг -- находим с помощью теста Фишера те p-values, которые малы
    # пожалуй, хи-квадрат будет помощнее, но на практике это несущественно
  }
  # if(alt =="a")

  if(min(dim(tt)) >= 2){
    if (alt == "cd"){
      tst <- glm(pht ~ as.factor(gg), subset = !is.na(gg))
      tst1 <- glm(pht ~ gg, subset = !is.na(gg))
      tst0 <- glm(pht ~ 1, subset = !is.na(gg))
      av <- anova(tst0, tst, test = "LRT")

      # ...
    } else{
      tst <- glm(pht ~ gg, subset = !is.na(gg))
      tst0 <- glm(pht ~ 1, subset = !is.na(gg))
      av <- anova(tst0, tst, test="LRT")
      pv[j] <- av$"Pr(>Chi)"[2]
      stt[j] <- tst$coefficients[2]
    }
  } else {
    pv[j] <- NA
    stt[j] <- NA
  }

  test.tj <- data.frame(
    test=alt,
    snp=snp,
    pv=pv,
    stt=stt
  )
  tests <- rbind(tests, test.tj) # TODO is this a correct way to concatenate our dataframes?
}
write.table(tests, file="tests_glm.csv", sep=",", row.names=F)

# + PC1 covariate


# Oct 14th
# ориентироваться нужно в первую очередь на результаты кодоминантного теста
# далее, ориентируясь на поправку Беньямини-Хохберга
# если вдруг рецессивный тест покажет больше значимость, чем доминантный -- именно минорная гомозигота является причиной
# то есть ориентироваться надо на ОДИН тест, потом добирать другими. Но для скорости написания кода делаем для всех типов.

# Oct 28th

# q <- snpgdsPCA(dat.f, snp.id=ftr.id, sample.id = id[ant$sex == "F"])
# GLM:
# - запускаем без PCA
# - смотрим, что даст введение принципиальных компонент

