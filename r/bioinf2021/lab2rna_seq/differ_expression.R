# Title     : Dirrerential expression analysis
# Created by: Valerii Zuev
# Created on: 3/2/2021

# BiocManager::install("DESeq2")
# BiocManager::install("apeglm") # for `lfcShrink(<...>, type="apeglm")`
# BiocManager::install("clusterProfiler")
# BiocManager::install("fgsea")
# BiocManager::install("AnnotationDbi")
# BiocManager::install("goseq")
library(tidyverse) # dplyr, ggplot2, ...

data_dir <- "r/bioinf2021/lab2rna_seq/dataset"
abs_path <- function(path) here::here(data_dir, path) # path relative to the Git root

# ------------------------------------------
# --- Analyzing RNA-seq data with DESeq2 ---
# ------------------------------------------

coldata <- read.csv(abs_path("annot_control_vs_meth.csv"), row.names = 1) %>% mutate_all(as.factor)

counts_df <- read.csv(abs_path("GSE74737_counts.txt"), sep = "\t", row.names = "Gene") %>%
  select(rownames(coldata))
counts <- counts_df %>%
  mutate(entrez = AnnotationDbi::mget(
    rownames(counts_df),
    AnnotationDbi::revmap(org.Hs.eg.db::org.Hs.egSYMBOL),
    ifnotfound = NA)) %>% # https://stat.ethz.ch/pipermail/bioconductor/2009-April/027168.html
  filter(!is.na(entrez)) %>%
  select(-entrez) %>%
  as.matrix

all(rownames(coldata) == colnames(counts)) # Performing a sanity check. Must be TRUE

dds <- DESeq2::DESeqDataSetFromMatrix(countData = counts, colData = coldata, design = ~condition)
dds_analysed <- DESeq2::DESeq(dds)
deseq_res <- DESeq2::results(dds_analysed)
DESeq2::plotMA(deseq_res)
deseq_res_df <- as.data.frame(deseq_res)
deseq_res_df$entrez <- AnnotationDbi::mget(rownames(deseq_res_df), AnnotationDbi::revmap(org.Hs.eg.db::org.Hs.egSYMBOL), ifnotfound = NA)
pval_thresh <- .001
diff_expr <- deseq_res_df %>% filter(pvalue < pval_thresh)
devnull <- mapply(function(df = ? data.frame, filename = ? character) {
  df %>%
    select(entrez) %>%
    unlist %>%
    write.table(abs_path(paste0(filename, "_entrez.csv")), sep = ",", row.names = F, col.names = F, quote = F)
  df %>%
    rownames %>%
    unlist %>%
    write.table(abs_path(paste0(filename, "_symbols.csv")), sep = ",", row.names = F, col.names = F, quote = F)
}, list(deseq_res_df, diff_expr), c("background", "diff_expr_meth_vs_control"))

# --------------------------------
# --- dowloading KEGG pathways ---
# --------------------------------
kegg_pathways <- clusterProfiler::download_KEGG("hsa")

# ------------
# --- GSEA ---
# ------------

# --- fgsea ---
res_sorted <- deseq_res_df %>% arrange(padj)
ranks <- res_sorted$padj
names(ranks) <- res_sorted$entrez

fgsea_res <- fgsea::fgsea(kegg_pathways, ranks, scoreType = "pos") # https://bioinformatics-core-shared-training.github.io/cruk-summer-school-2018/RNASeq2018/html/06_Gene_set_testing.nb.html#conduct-analysis

# --- KEGG enrichment with clusterProfiler ---
kk <- clusterProfiler::enrichKEGG(gene = diff_expr$entrez, organism = 'hsa') # `hsa` stands for Homo Sapiens
head(kk, n = 10) # only 3 found

# --- GO enrichment with goseq ---
res_sorted$genes_signif <- as.integer(res_sorted$pvalue < pval_thresh)
genome_id <- "hg19"
gene_type_id <- "geneSymbol"
res_sorted$lengths <- goseq::getlength(rownames(res_sorted), genome = genome_id, id = gene_type_id)
res_sorted <- res_sorted[!is.na(res_sorted$lengths) & !is.na(res_sorted$genes_signif),]
genes_signif <- res_sorted$genes_signif
names(genes_signif) <- rownames(res_sorted)
pwf <- goseq::nullp(res_sorted$genes_signif, genome = genome_id, id = gene_type_id, bias.data = res_sorted$lengths) # https://bioinformatics-core-shared-training.github.io/cruk-summer-school-2018/RNASeq2018/html/06_Gene_set_testing.nb.html#fit-the-probability-weighting-function-pwf
rownames(pwf) <- rownames(res_sorted)
go_res <- goseq::goseq(pwf, genome_id, gene_type_id)
go_res$padj <- p.adjust(go_res$over_represented_pvalue)
go_res %>% filter(padj < .05) # empty result
