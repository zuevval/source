# Title     : Adjusting p-values
# Created by: Valerii Zuev
# Created on: 5/4/2021

setwd("Y:/vzuev/datasets/bioinf2021/ab/task2/")
library(dplyr)
mlm_res <- read.csv("mlm_results.txt", sep = "\t") %>%
  na.omit %>%
  select(p, Marker)
mlm_res$padj <- p.adjust(mlm_res$p, method = "BH")
xtable::xtable(head(mlm_res %>% arrange(padj), 3),
               display = list("d", "e", "s", "f"))