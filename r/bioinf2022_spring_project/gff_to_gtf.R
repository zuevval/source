# BiocManager::install("rtracklayer")
library(rtracklayer)

# ?import.gff3
annot_dir <- "Y:/vzuev/datasets/bioMG2022/phytozome/"
gff3_path <- paste0(annot_dir, "Lusitatissimum_200_v1.0.gene_exons.gff3")
gff3_content <- import(gff3_path)
export(gff3_content, paste0(annot_dir, "Lusitatissimum_200_v1.0.gene_exons.gtf"), "gtf")
