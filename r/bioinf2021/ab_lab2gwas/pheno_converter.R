# Title     : Convert .pheno file to TASSEL format
# Objective : https://bitbucket.org/tasseladmin/tassel-5-source/wiki/UserManual/Load/Load
# Created by: Valerii Zuev
# Created on: 5/4/2021

setwd("Y:/vzuev/datasets/bioinf2021/ab/task2/plink_win64_20210416")
library(dplyr)
pheno <- read.csv("Tr_males.pheno", header = F, sep = "\t")
colnames(pheno) <- c("familyid", "taxid", "ph")
out_filename <- "tr_males_tassel.pheno"
cat( "<phenotype>\ntaxa\tdata\n", file = out_filename)
  pheno %>%
  transmute(taxid = paste0(familyid, "_", taxid), ph = ph) %>%
  write.table("tr_males_tassel.pheno", sep = "\t", quote = F, row.names = F, append = T)