# Title     : Reading and annotating VCF with SNP
# Created by: Valerii Zuev
# Created on: 5/4/2021

setwd("Y:/vzuev/datasets/bioinf2021/ab/lab1_snp/")
library(dplyr)
library(ggplot2)
snp <- read.csv("variant_calls.vcf", sep = "\t", comment.char = "#")
colnames(snp) <- c("CHROM", "POS", "ID", "REF", "ALT", "QUAL", "FILTER", "INFO", "FORMAT", "sorted.bam")

all_genes <- read.csv("ecoli_all_genes.txt", sep = "\t") %>% na.omit
genes_filtered <- all_genes %>%
  rowwise %>%
  mutate(count = (data.table::between(snp$POS, Left.End.Position, Right.End.Position) %>%
    as.integer %>%
    sum)) %>%
  filter(count > 1) %>%
  arrange(desc(count))

write_gene_names <- function(gene_names = ? character, out_filename = ? character) {
  sink(out_filename)
  cat(gene_names, sep = "\n")
  sink()
}
write_gene_names(genes_filtered$Gene.Name, "genes_filtered_names.txt")
write_gene_names(all_genes$Gene.Name, "genes_background_names.txt")

ggplot(data = genes_filtered, aes(Gene.Name, count)) +
  geom_bar(stat = "identity") +
  ggtitle(" SNP count for each gene containing at least two SNPs ") +
  theme_bw() +
  theme(plot.title = element_text(hjust = .5))
ggsave("snp_hist.jpeg", scale = .3)

xtable::xtable(genes_filtered %>% select(Gene.Name, Product, count))
