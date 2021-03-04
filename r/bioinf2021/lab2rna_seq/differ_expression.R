# Title     : Dirrerential expression analysis
# Created by: Valerii Zuev
# Created on: 3/2/2021

# BiocManager::install("DESeq2")
# BiocManager::install("apeglm") # for `lfcShrink(<...>, type="apeglm")`
library(DESeq2)
library(here)
library(tidyverse) # dplyr, ggplot2, ...

data_dir <- "r/bioinf2021/lab2rna_seq/dataset"
abs_path <- function(path) here(data_dir, path) # path relative to the Git root

# ------------------------------------------
# --- Analyzing RNA-seq data with DESeq2 ---
# ------------------------------------------

coldata <- read.csv(abs_path("annot.csv"), row.names = 1) %>% mutate_all(as.factor)
counts <- read.csv(abs_path("GSE74737_counts.txt"), sep = "\t", row.names = "Gene") %>%
  select(rownames(coldata)) %>% # leave only columns mentioned in `annot.csv`
  as.matrix

all(rownames(coldata) == colnames(counts)) # Performing a sanity check. Must be TRUE

dds <- DESeqDataSetFromMatrix(countData = counts, colData = coldata, design = ~ condition)
dds_analysed <- DESeq(dds)
res <- results(dds_analysed)
pval_thresh <- .2
diff_expr <- res %>% na.omit %>% as.data.frame %>% filter(padj < pval_thresh) %>% rownames # differentially expressed genes
# same as in the article: "ARL6", "ELK3", "MTHFSD"

write.csv(diff_expr, abs_path("diff_expr.csv"))

#resultsNames(dds_analysed) # lists the coefficients
#res_lfc_ma <- lfcShrink(dds_analysed, coef = "condition_.map_vs_.control", type = "apeglm")
#res_lfc_map <- lfcShrink(dds_analysed, coef = "condition_.ma_vs_.control", type = "apeglm")
#plotMA(res)
#plotMA(res_lfc_ma)
#plotMA(res_lfc_map)

# -------------
# --- FGSEA ---
# -------------

# BiocManager::install("fgsea")
library(fgsea)
res_sorted <- res %>% na.omit %>% as.data.frame %>% arrange(padj)
es <- calcGseaStat(res_sorted$padj, 1:6)
