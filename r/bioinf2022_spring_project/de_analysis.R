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
accessions <- list("SRX4997862", "SRX4997861", "SRX4997860", "SRX4997859",
                   "SRX4997858", "SRX4997857", "SRX4997856", "SRX4997855")
hours <- list(48, 48, 24, 24, 48, 48, 24, 24)
strains <- list("Nike", "Nike", "Nike", "Nike", "Regina", "Regina", "Regina", "Regina")
case_control <- list("case", "control", "case", "control", "case", "control", "case", "control")

files <- file.path(work.dir, ids, "abundance.h5")
names(files) <- paste0("sample", 1:8)

col.data <- data.frame("strain" = as.factor(unlist(strains)),
                       "accession" = unlist(accessions),
                       "hours" = as.factor(unlist(hours)),
                       "caseControl" = relevel(as.factor(unlist(case_control)), ref = "control"))
row.names(col.data) <- ids

txi.kallisto <- tximport(files, type = "kallisto", txOut = T)
head(txi.kallisto$counts)


ddsTxi <- DESeqDataSetFromTximport(txi.kallisto, colData = col.data, design = ~strain + hours + caseControl)
dds.output <- DESeq(ddsTxi)
dds.results <- results(dds.output, name = "caseControl_case_vs_control") # http://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html#quick-start

dds.filtered <- dds.results %>%
  as.data.frame %>%
  filter(!is.na(padj)) %>%
  filter(padj < 10e-3 & log2FoldChange >= 2)

file_out <- file.path(work.dir, "deseq_out.csv")

dds.filtered %>% write.csv(file_out)
