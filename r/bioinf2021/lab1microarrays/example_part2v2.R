setwd("D:/dataVal/Work/git/source/r/bioinf2021/lab1microarrays/data/out/")
# data loading alternative to `example_part2.R`: downloading files locally

library("ArrayExpress")
dat <- getAE("E-MEXP-886", type="processed")
cn <- getcolproc(dat)
show(cn)
AEpset <- procset(dat,cn[1]) # TODO is it used later?
dat <- getAE("E-MEXP-886", type="full")

mexp886 = list()
mexp886$path = "." # TODO this was changed from `data/...`
mexp886$rawFiles = c(
  "1863.CEL", "1919.CEL", "1869.CEL",
  "1749r.CEL", "1753.CEL", "1307.CEL",
  "1750.CEL", "1364.CEL", "1751.CEL", "1756.CEL")
mexp886$rawArchive = "E-MEXP-886.raw.1.zip"
mexp886$processedFiles =
  "E-MEXP-886-processed-data-1343526943.txt"
mexp886$processedArchive =
  "E-MEXP-886.processed.1.zip"
mexp886$sdrf = "E-MEXP-886.sdrf.txt"
mexp886$idf = "E-MEXP-886.idf.txt"
mexp886$adf = "A-AFFY-23.adf.txt"
aeset = ae2bioc(mageFiles = mexp886)
AEset = aeset

arrayQualityMetrics(expressionset = AEset, outdir = "QAraw",
                    force = FALSE, do.logtransform = TRUE, intgroup = fac)

rAEset = affy::rma(AEset) # TODO err (rma accepts affyBatch and returns ExpressionSet; AEset is already an ExpressionSet)

arrayQualityMetrics(expressionset = rAEset, outdir = "QAnorm",
                    force = FALSE, intgroup = fac)
