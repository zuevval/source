# Title     : Tanglegram
# Objective : Tanglegram from Newick trees
# Created by: Valerii Zuev
# Created on: 11/9/2020

library(DECIPHER) # installation: with BioConductor
library(dendextend)
library(types)

data_dir <- "E:/Users/vzuev/github-zuevval/source/python/bioinf_practice/needles/data/" # change to your path
abs_path <- function(rel_path = ?str) {
  paste(data_dir, rel_path, sep = "")
}

remove_taxids <- function(name = ?character) {
  gsub('XM |NM |XP |NP |[0-9]+ ', '', name)
}

lapply(c("dna", "protein"), function(seq_type = ?character) {
  complete_dnd <- ReadDendrogram(abs_path(paste("trees/", seq_type, "_complete.nwk", sep = "")))
  labels(complete_dnd) <- unlist(lapply(labels(complete_dnd), remove_taxids))

  lapply(c(1, 2, 3), function(idx = ?integer) {
    dnd_filename <- abs_path(paste("trees/", seq_type, idx, ".nwk", sep = ""))
    part_dnd <- ReadDendrogram(dnd_filename)
    labels(part_dnd) <- unlist(lapply(labels(part_dnd), remove_taxids))

    out_filename <- abs_path(paste("out/tanglegram_", seq_type, idx, ".png", sep = ""))
    png(filename = out_filename)
    tanglegram(part_dnd, complete_dnd)
    dev.off()
  })
})
