# Title     : Differential expression analysis
# Created by: Valerii Zuev
# Created on: 6/5/2022

# credit:
# https://bioconductor.org/packages/devel/bioc/vignettes/tximport/inst/doc/tximport.html#kallisto
# http://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html#tximport

library(tidyverse) # BiocManager::install("tximport")
library(tximport)
library(tximportData) # BiocManager::install("tximportData")
library(DESeq2)

work.dir <- "E://opt/kallisto/paired_reads/out"

ids <- list("SRR8177755", "SRR8177756", "SRR8177757", "SRR8177758",
            "SRR8177759", "SRR8177760", "SRR8177761", "SRR8177762")

files <- file.path(work.dir, ids, "abundance.h5")
names(files) <- paste0("sample", 1:8) # TODO add conditions? (time, strain)
txi.kallisto <- tximport(files, type = "kallisto", txOut = T)
head(txi.kallisto$counts)

strains <- list("Regina", "Regina", "Regina", "Regina", "Nike", "Nike", "Nike", "Nike") # TODO insert real
col.data <- data.frame("strain" = as.factor(unlist(strains)))
row.names(col.data) <- ids

ddsTxi <- DESeqDataSetFromTximport(txi.kallisto, colData = col.data, design = ~strain)
dds.output <- DESeq(ddsTxi)
dds.results <- results(dds.output, name = "TODO") # http://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html#quick-start
