library(gdsfmt)
library(SNPRelate)
library(vcfR)
library(HardyWeinberg)
#
data_dir <- function (fname) here::here("r/stats2022fall/VAR_1/", fname)

vcf.fn <- data_dir("genotype1.vcf.gz")
dat.fn <- data_dir("phenotype_1.txt")
gds.fn <- data_dir("DATA.gds")
#
# snpgdsVCF2GDS(vcf.fn, gds.fn)
dat.f <- snpgdsOpen(gds.fn)
id <- read.gdsn(index.gdsn(dat.f, "sample.id"))
snp <- read.gdsn(index.gdsn(dat.f, "snp.id"))
snp <- read.gdsn(index.gdsn(dat.f, "snp.rs.id"))
chr <- read.gdsn(index.gdsn(dat.f, "snp.chromosome"))
pos <- read.gdsn(index.gdsn(dat.f, "snp.position"))
all <- read.gdsn(index.gdsn(dat.f, "snp.allele"))
gen <- read.gdsn(index.gdsn(dat.f, "genotype"))
ant <- read.gdsn(index.gdsn(dat.f, "snp.annot"))
snpgdsClose(dat.f)
#
pht <- read.table("phenotype_10.txt", head = TRUE)
#
dat.f <- snpgdsOpen(gds.fn, readonly = FALSE)
sa <- add.gdsn(dat.f, "snp.annot", val = NULL, compress = "ZIP", closezip = TRUE, replace = TRUE)
delete.gdsn(sa, TRUE)
add.gdsn(dat.f, "sample.annot", val = pht, compress = "ZIP", closezip = TRUE)
snpgdsClose(dat.f)
#
dat.f <- snpgdsOpen(gds.fn)
d2 <- read.gdsn(index.gdsn(dat.f, "sample.annot"))
snpgdsClose(dat.f)
#
levels(as.factor(d2$sex))
levels(as.factor(d2$phenotype))
table(d2$sex, d2$phenotype)
sum(table(d2$sex))
sum(table(d2$phenotype))
#
dat.f <- snpgdsOpen(gds.fn)
gen <- read.gdsn(index.gdsn(dat.f, "genotype"))
snpgdsClose(dat.f)
#
gen2 <- gen
gen2[gen2 == 3] <- NA
gen3 <- !is.na(gen2)
#
maf <- colSums(gen2, na.rm = TRUE) / colSums(gen3) / 2
nn <- which(maf > 1 / 2)[1:5]
#
htr <- colSums(gen == 1) / colSums(gen3)
e.htr <- 2 * maf * (1 - maf)
#
c(max(htr / e.htr), min(htr / e.htr))
#
cr <- colSums(gen3) / dim(gen)[1]
min(cr)
# QC
ftr.cr <- cr >= 0.95
ftr.maf <- maf >= 0.05
# HWE-test
f.ctr <- d2$phenotype == 1
gen.ctr <- gen[f.ctr,]
ant.ctr <- data.frame(AA = colSums(gen.ctr == 0), AB = colSums(gen.ctr == 1), BB = colSums(gen.ctr == 2))
ant.ctr1 <- as.matrix(ant.ctr)
hwe.ctr <- NULL
for (i in 1:length(chr)) {
  hwe.ctr.i <- HWExact(ant.ctr1[i,], verbose = FALSE)$pval
  hwe.ctr <- c(hwe.ctr, hwe.ctr.i)
}
#
hwe.ctr1 <- function(i) {
  HWExact(ant.ctr1[i,], verbose = FALSE)$pval
}

aa <- lapply(c(1:length(chr)), hwe.ctr1)
#
ftr.hwe1 <- hwe.ctr < 10^(-5)
#
ftr.g <- ftr.cr & ftr.maf & (!ftr.hwe1)
snp <- snp[ftr.g]
chr <- chr[ftr.g]
pos <- pos[ftr.g]
all <- all[ftr.g]
gen <- gen[, ftr.g]
# PCA
dat.f <- createfn.gds("DATA_PCA.gds")
add.gdsn(dat.f, "sample.id", val = id, compress = "ZIP", closezip = TRUE)
add.gdsn(dat.f, "snp.id", val = snp, compress = "ZIP", closezip = TRUE)
add.gdsn(dat.f, "snp.chromosome", val = chr, compress = "ZIP", closezip = TRUE)
add.gdsn(dat.f, "snp.position", val = pos, compress = "ZIP", closezip = TRUE)
add.gdsn(dat.f, "snp.allele", val = all, compress = "ZIP", closezip = TRUE)
add.gdsn(dat.f, "genotype", val = gen, compress = "ZIP", closezip = TRUE, storage = "bit2", replace = TRUE)
add.gdsn(dat.f, "sample.annot", val = d2, compress = "ZIP", closezip = TRUE)
put.attr.gdsn(index.gdsn(dat.f, "genotype"), "sample.order")
closefn.gds(dat.f)
#
dat.f <- snpgdsOpen("DATA_PCA.gds")
ftr <- snpgdsLDpruning(dat.f)
ftr.id <- unlist(ftr)
q <- snpgdsPCA(dat.f, snp.id = ftr.id)
qq <- snpgdsPCA(dat.f)
id <- read.gdsn(index.gdsn(dat.f, "sample.id"))
ant <- read.gdsn(index.gdsn(dat.f, "sample.annot"))
snpgdsClose(dat.f)
#Relative
# pair
vec <- q$eigenvect
x <- vec[, 1]
y <- vec[, 2]
z <- vec[, 3]
t <- vec[, 4]
#pop<-c("GBR","FIN","IBS","TSI")
plot(x, y, "n")
points(x[ant$sex == "F"], y[ant$sex == "F"], col = "blue")
points(x[ant$sex == "M"], y[ant$sex == "M"], col = "red")
#
smp <- ant$phenotype
clr <- c("blue", "red")
smp.l <- c("Controls", "Cases")
pc.prt <- q$varprop * 100
lbs <- paste("PC", 1:2, "(", format(pc.prt[1:2], digits = 2), "%)", sep = "")
pdf("PCA-2", width = 9, height = 6)
plot(x, y, "n", xlab = lbs[1], ylab = lbs[2])
points(x[ant$phenotype == 1], y[ant$phenotype == 1], col = "blue")
points(x[ant$phenotype == 2], y[ant$phenotype == 2], col = "red")
legend("topleft", legend = smp.l, col = clr, pch = 1, cex = 1)
dev.off()
# 1 panel
library(ggplot2)
ant$colr <- NA
ant$cc <- NA
ant$colr[ant$phenotype == 1] <- "blue"
ant$colr[ant$phenotype == 2] <- "red"
ant$cc[ant$phenotype == 1] <- "Controls"
ant$cc[ant$phenotype == 2] <- "Cases"
dd1 <- data.frame(PC1 = x, PC2 = y, pht = ant$phenotype, cc = ant$cc)
pdf("PCA-22", width = 9, height = 6)
p <- ggplot(dd1) +
  geom_point(aes(PC1, PC2, colour = factor(cc)), shape = 1) +
  scale_color_manual(values = c("red", "blue")) +
  labs(x = lbs[1], y = lbs[2]) +
  labs(color = NULL)
p + theme(
  legend.position = c(.2, .88),
  legend.justification = c("right", "top"),
  legend.box.just = "right",
  legend.margin = margin(0, 22, 8, 10)
)
#p+guides(shape=FALSE)
#legend("topleft",legend=smp.l,col=clr,pch=1,cex=1)
dev.off()
# 4 panels
colr <- array(dim = length(smp))
for (i in 1:length(smp.l)) {
  colr[ant$cc == smp.l[i]] <- clr[i]
}
pc.prt <- q$varprop * 100
lbls <- paste("PC", 1:4, "\n", format(pc.prt[1:4], digits = 2), "%", sep = "")
# version1
lbls[4] <- NA
pdf("PCA-4", width = 9, height = 6)
pairs(q$eigenvect[, 1:4], col = colr, labels = lbls)
legend(0.75, 0.25, legend = smp.l, col = clr, pch = 1, cex = 1.1, bty = "n") #,lwd=15)
dev.off()
# version2
pdf("PCA-4-2", width = 9, height = 6)
pairs(q$eigenvect[, 1:4], col = colr, labels = lbls, oma = c(4, 4, 6, 14))
par(xpd = TRUE)
legend(0.86, 0.7, legend = smp.l, col = clr, pch = 1, cex = 0.75)
dev.off()
# FILTER PCA
ftr.pca <- !(x > .2)
sum(ftr.pca)
#
id <- id[ftr.pca]
ant <- ant[ftr.pca,]
gen <- gen[ftr.pca,]
#
#dat.f<-createfn.gds("DATA_PCA2.gds")
#add.gdsn(dat.f,"sample.id", val=id,compress="ZIP",closezip=TRUE)
#add.gdsn(dat.f,"snp.id", val=snp,compress="ZIP",closezip=TRUE)
#add.gdsn(dat.f,"snp.chromosome", val=chr,compress="ZIP",closezip=TRUE)
#add.gdsn(dat.f,"snp.position", val=pos,compress="ZIP",closezip=TRUE)
#add.gdsn(dat.f,"snp.allele", val=all,compress="ZIP",closezip=TRUE)
#add.gdsn(dat.f,"genotype",val=gen,compress="ZIP",closezip=TRUE,storage="bit2",replace=TRUE)
#add.gdsn(dat.f,"sample.annot",val=ant,compress="ZIP",closezip=TRUE)
#put.attr.gdsn(index.gdsn(dat.f,"genotype"),"sample.order")
#closefn.gds(dat.f)
# second PCA
dat.f <- snpgdsOpen("DATA_PCA2.gds")
ftr <- snpgdsLDpruning(dat.f)
ftr.id <- unlist(ftr)
q <- snpgdsPCA(dat.f, snp.id = ftr.id)
qq <- snpgdsPCA(dat.f)
id <- read.gdsn(index.gdsn(dat.f, "sample.id"))
ant <- read.gdsn(index.gdsn(dat.f, "sample.annot"))
snpgdsClose(dat.f)
# pair
vec <- q$eigenvect
x <- vec[, 1]
y <- vec[, 2]
z <- vec[, 3]
t <- vec[, 4]
#pop<-c("GBR","FIN","IBS","TSI")
plot(x, y, "n")
points(x[ant$sex == "F"], y[ant$sex == "F"], col = "blue")
points(x[ant$sex == "M"], y[ant$sex == "M"], col = "red")
#
dd1 <- data.frame(PC1 = x, PC2 = y, pht = ant$phenotype, cc = ant$cc)
pc.prt <- q$varprop * 100
lbs <- paste("PC", 1:2, "(", format(pc.prt[1:2], digits = 2), "%)", sep = "")
pdf("PCA-22N", width = 9, height = 6)
p <- ggplot(dd1) +
  geom_point(aes(PC1, PC2, colour = factor(cc)), shape = 1) +
  scale_color_manual(values = c("red", "blue")) +
  labs(x = lbs[1], y = lbs[2]) +
  labs(color = NULL)
p + theme(
  legend.position = c(.2, .88),
  legend.justification = c("right", "top"),
  legend.box.just = "right",
  legend.margin = margin(0, 22, 8, 10)
)
#p+guides(shape=FALSE)
#legend("topleft",legend=smp.l,col=clr,pch=1,cex=1)
dev.off()
# NEW RUN
dat.f <- snpgdsOpen("DATA_PCA2.gds")
id <- read.gdsn(index.gdsn(dat.f, "sample.id"))
snp <- read.gdsn(index.gdsn(dat.f, "snp.id"))
chr <- read.gdsn(index.gdsn(dat.f, "snp.chromosome"))
pos <- read.gdsn(index.gdsn(dat.f, "snp.position"))
all <- read.gdsn(index.gdsn(dat.f, "snp.allele"))
gen <- read.gdsn(index.gdsn(dat.f, "genotype"))
ant <- read.gdsn(index.gdsn(dat.f, "sample.annot"))
snpgdsClose(dat.f)
# IBD analysis
dat.f <- snpgdsOpen("DATA_PCA2.gds")
id <- read.gdsn(index.gdsn(dat.f, "sample.id"))
snp <- read.gdsn(index.gdsn(dat.f, "snp.id"))
snp.subset <- snpgdsLDpruning(dat.f)
#qq<-snpgdsIBDMLE(dat.f,kinship=TRUE,num.thread=30)
snpset <- as.character(sample(unlist(snp.subset), 100))
mibd <- snpgdsIBDMLE(dat.f, snp.id = snpset, kinship = TRUE)
snpgdsClose(dat.f)
d1 <- snpgdsIBDSelection(mibd, kinship.cutoff = 1 / 8)
dd1 <- d1[order(d1$kinship, decreasing = TRUE),]
write.table(dd1, file = "Sibs.txt", row.names = F, sep = ";", dec = ",")
#
dd1 <- read.table("Sibs.txt", header = T, sep = ";", dec = ",")
#dat.f<-createfn.gds("DATA_PCA2.gds")
#add.gdsn(dat.f,"sample.id", val=id,compress="ZIP",closezip=TRUE)
#add.gdsn(dat.f,"snp.id", val=snp,compress="ZIP",closezip=TRUE)
#add.gdsn(dat.f,"snp.chromosome", val=chr,compress="ZIP",closezip=TRUE)
#add.gdsn(dat.f,"snp.position", val=pos,compress="ZIP",closezip=TRUE)
#add.gdsn(dat.f,"snp.allele", val=all,compress="ZIP",closezip=TRUE)
#add.gdsn(dat.f,"genotype",val=gen,compress="ZIP",closezip=TRUE,storage="bit2",replace=TRUE)
#add.gdsn(dat.f,"sample.annot",val=d2,compress="ZIP",closezip=TRUE)
#put.attr.gdsn(index.gdsn(dat.f,"genotype"),"sample.order")
#closefn.gds(dat.f)
#
gen2 <- gen
gen2[gen2 == 3] <- NA
gen3 <- !is.na(gen2)
cr <- colSums(gen3) / dim(gen)[1]
#
ff <- NULL
for (j in 1:dim(dd1)[1]) {
  if (cr[which(id == dd1$ID1[j])] >= cr[which(id == dd1$ID2[j])]) {
    ff <- c(ff, which(id == dd1$ID2[j]))
  } else { ff <- c(ff, which(id == dd1$ID1[j])) }
}
ff <- -ff
#
id <- id[ff]
gen <- gen[ff,]
ant <- ant[ff,]
#
#dat.f<-createfn.gds("DATA_FINAL.gds")
#add.gdsn(dat.f,"sample.id", val=id,compress="ZIP",closezip=TRUE)
#add.gdsn(dat.f,"snp.id", val=snp,compress="ZIP",closezip=TRUE)
#add.gdsn(dat.f,"snp.chromosome", val=chr,compress="ZIP",closezip=TRUE)
#add.gdsn(dat.f,"snp.position", val=pos,compress="ZIP",closezip=TRUE)
#add.gdsn(dat.f,"snp.allele", val=all,compress="ZIP",closezip=TRUE)
#add.gdsn(dat.f,"genotype",val=gen,compress="ZIP",closezip=TRUE,storage="bit2",replace=TRUE)
#add.gdsn(dat.f,"sample.annot",val=ant,compress="ZIP",closezip=TRUE)
#put.attr.gdsn(index.gdsn(dat.f,"genotype"),"sample.order")
#closefn.gds(dat.f)
## COMBINED CHISQ (+ YATES) -- FISHER's EXACT PERMUTATION TEST (2X2 tables) ####
#chisq_fisher<-function(genotype,phtpe,num.g,n.lev){
#qas<-NULL
#pv<-NULL
#for (i in 1:num.g){
#	if (n.lev[i]){
#		gtype<-genotype[,i]
#		sbst<-(gtype!=3)
#		gtype<-gtype[sbst]
#		phtype<-phtpe[sbst]
# 		c.tab<-table(phtype,gtype)
#	 	if (min(dim(c.tab))>1){
#			sr <- rowSums(c.tab)
#		   	sc <- colSums(c.tab)
#		   	E <- outer(sr, sc, "*")/sum(sr)
#			if (min(E) > 4) {
#				pv[i]<-chisq.test(phtype,gtype)$p.value; qas[i]<-c.tab[1,1]*c.tab[2,2]/c.tab[2,1]/c.tab[1,2]
#				}
#			else {
#				ft<-fisher.test(phtype,gtype)
#				pv[i]<-ft$p.value
#				if (max(dim(c.tab))==2) { qas[i]<-ft$estimate } else { qas[i]<-c.tab[1,1]*c.tab[2,2]/c.tab[2,1]/c.tab[1,2] }
#				}
#		}
#		else { qas[i]<-NA; pv[i]<-NA }
#	}
#	else { qas[i]<-NA; pv[i]<-NA }
#}
#data.out<-list()
#data.out$pv<-pv
#data.out$qas<-qas
#data.out<-as.data.frame(data.out)
#data.out
#}
# NEW RUN
# TESTS
pth.dk <- "DATA_FINAL.gds"
dat.f <- snpgdsOpen(pth.dk)
id <- read.gdsn(index.gdsn(dat.f, "sample.id"))
snp <- read.gdsn(index.gdsn(dat.f, "snp.id"))
chr <- read.gdsn(index.gdsn(dat.f, "snp.chromosome"))
pos <- read.gdsn(index.gdsn(dat.f, "snp.position"))
all <- read.gdsn(index.gdsn(dat.f, "snp.allele"))
gen <- read.gdsn(index.gdsn(dat.f, "genotype"))
ant <- read.gdsn(index.gdsn(dat.f, "sample.annot"))
snpgdsClose(dat.f)
#
tests <- data.frame(test = NULL, snp = NULL, pv = NULL, stt = NULL)
for (alt in c("cd", "d", "r", "a")) {
  dat.f <- snpgdsOpen(pth.dk, readonly = TRUE)
  pht <- read.gdsn(index.gdsn(dat.f, "sample.annot"))$phenotype
  gen <- read.gdsn(index.gdsn(dat.f, "genotype"))
  snpgdsClose(dat.f)
  dg <- dim(gen)
  num.p <- dg[1]
  num.g <- dg[2]
  if (alt == "d") {
    gen <- (1 - (gen == 0)) + 2 * (gen == 3) }
  if (alt == "r") {
    gen = 1 * (gen == 2) + 3 * (gen == 3) }
  if (alt == "a") {
    pht <- c(pht, pht)
    num.p2 <- 2 * num.p
    genotype2 <- matrix(nrow = num.p2, ncol = num.g)
    genotype2[1:num.p,] <- 1 * (gen == 2 | gen == 1) + 3 * (gen == 3)
    genotype2[(num.p + 1):num.p2,] <- 1 * (gen == 2) + 3 * (gen == 3)
    gen <- genotype2
    rm(genotype2) }
  pv <- array(dim = num.g)
  stt <- array(dim = num.g)
  for (j in 1:num.g) {
    gg <- gen[, j]
    gg[gg == 3] <- NA
    tt <- table(gg, pht)
    if (min(dim(tt)) >= 2) {
      if (alt == "cd") {
        tst <- chisq.test(tt)
        pv[j] <- tst$p.value
        ff1 <- !is.na(gg)
        rho <- cor(gg[ff1], pht[ff1])
        stt[j] <- (1 + rho) / (1 - rho)     # stt=(1+rho)/(1-rho)
      } else {
        tst <- fisher.test(tt)
        pv[j] <- tst$p.value
        stt[j] <- tst$estimate
      }
    } else {
      pv[j] <- NA
      stt[j] <- NA
    }
  }
  test.tj <- data.frame(test = alt, snp = snp, pv = pv, stt = stt)
  tests <- rbind(tests, test.tj)
}
write.table(tests, file = "tests.csv", sep = ",", row.names = FALSE)
#

