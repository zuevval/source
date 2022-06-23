# Title     : STAR to DESeq2
# Created by: Valerii Zuev
# Created on: 6/17/2022

library(DESeq2)
countdf <- read.table("E://opt/STAR-2.7.10a/bin/Linux_x86_64_static/gene_counts.count", sep = "\t", h = F)

# AnnotationDbi::mapIds(org.Hs.eg.db)
