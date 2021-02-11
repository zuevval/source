# --------------------------------------------------------------------
# ---    Microarrays analysis | Data: Smiljanovich et al, 2012     ---
# --- https://www.ebi.ac.uk/arrayexpress/experiments/E-GEOD-38351/ ---
# ---   https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE38351    ---
# --------------------------------------------------------------------
#
# Installing required libraries:
#
# BiocManager::install("ArrayExpress")
# BiocManager::install("arrayQualityMetrics")
# BiocManager::install("GSEABase")
# BiocManager::install("moe430a.db")
# BiocManager::install("KEGG.db") # TODO deprecated and will be removed
# BiocManager::install("GOstats")
# BiocManager::install("ReactomePA")
# BiocManager::install("clusterProfiler")
# install.packages("amap")

setwd("D:/dataVal/Work/git/source/r/bioinf2021/lab1microarrays/data/out/")

data_desc = list()
data_desc$path = "../"
data_desc$rawFiles = c( # TODO add more with path parsing
  "GSM940450_SL_1_Mo_133A.CEL",
  "GSM940451_SL_2_Mo_133A.CEL",
  "GSM940451_SL_3_Mo_133A.CEL",
  "GSM940459_SL_11_Mo_test_133A.CEL")

aeset = ArrayExpress::ae2bioc(mageFiles = data_desc)
