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
# BiocManager::install("pd.hg.u133a")
# install.packages("amap")

library(dplyr)
data_dir <- "E:/Users/vzuev/github-zuevval/source/r/bioinf2021/lab1microarrays/out"
setwd(data_dir)

# --- if you run this for the first time: uncomment two lines below
geod_list_filename <- "geod38351.RData"
# geod38351 <- ArrayExpress::getAE("E-GEOD-38351", type = "full")
# save(geod38351, file=geod_list_filename)
load(geod_list_filename)
aesets <- ArrayExpress::ae2bioc(mageFiles = geod38351)
aeset1 <- aesets[[1]] # AFFY-44
aeset2 <- aesets[[2]] # AFFY-33

# finding a factor
colnames1 <- colnames(pData(aeset1))
fac <- colnames1[grep("Factor", colnames1)]
fac

devnull <- mapply(function(outdir = ? str, eset = ? ExpressionSet) {
  arrayQualityMetrics::arrayQualityMetrics(
    expressionset = eset,
    outdir = outdir,
    force = FALSE,
    do.logtransform = TRUE,
    intgroup = fac)
}, list("qaraw_geod_38351_1", "qaraw_geod_38351_2"), c(aeset1, aeset2))

# array 1 stands out!
c_aeset1 <- oligo::rma(aeset1[, -1])
c_aeset2 <- oligo::rma(aeset2)
annotation(c_aeset1) <- "pd.hg.u133a" # TODO ask: is it right?
c_aeset <- combine(c_aeset1, c_aeset2)

groups <- pData(c_aeset)[, fac]
colnames(groups) <- c("stimulus", "disease")
groups[groups == "incubated for 1.5 hour without any stimulation"] <- "st"
groups[groups == "no incubation"] <- "none"
groups[groups == "stimulated with IFN-gamma for 1.5 hour"] <- "st"
groups[groups == "stimulated with IFN-alpha-2a for 1.5 hour"] <- "st"
groups[groups == "stimulated with TNF-alpha for 1.5 hour"] <- "st"
groups[groups == "rheumatoid arthritis"] <- "ill"
groups[groups == "systemic lupus erythematosus"] <- "ill"
print(groups) # TODO ask: no st:ill

f_stimulus <- factor(groups$stimulus)
f_disease <- factor(groups$disease)
# design <- model.matrix(~0 + f_stimulus:f_disease)
design <- model.matrix(~f_disease)
colnames(design) <- colnames(design) %>% lapply(function(x) {
  x_noprefixes = gsub("f_stimulus|f_disease", "", x)
  gsub(":", "_", x_noprefixes)
})
print(design)
limma::is.fullrank(design)

fit <- limma::lmFit(c_aeset, design)
# conmat <- limma::makeContrasts(none_normal - none_ill,
#                                st_normal - st_ill, levels=design) # TODO
# fitc <- limma::contrasts.fit(fit, conmat)
fit2 <- limma::eBayes(fit)

# par(mfrow = c(1, 2)) # TODO return it back
# limma::volcanoplot(fit2, coef = "st_normal", highlight = 15)
# limma::volcanoplot(fit2, coef = "none_normal", highlight = 15)
limma::volcanoplot(fit2, coef = "normal", highlight = 15)


# results <- limma::topTable(fit2, coef = "st_normal", adjust = "BH", number = nrow(c_aeset)) # TODO return it
results <- limma::topTable(fit2, coef = "normal", adjust = "BH", number = nrow(c_aeset))
as.integer(results[, "P.Value"] < 1e-8) %>%
  na.exclude %>%
  sum # TODO ask: too small
topgenes <- results[results[, "P.Value"] < 1e-8,]

diffexpr_ids <- rownames(topgenes)
# m <- rbind(exprs(c_aeset[diffexpr_ids[1],]), exprs(c_aeset[diffexpr_ids[1],])) # TODO ask: exprs(c_aeset[diffexpr_ids,])
m <- exprs(c_aeset[diffexpr_ids,])
ncol(m)
colnames(m) <- 1:73
heatmap(m)

plot(hclust(dist(m)))

clust.genes <- amap::hcluster(x = m, method = "pearson", link = "average")
clust.arrays <- amap::hcluster(x = t(m), method = "pearson", link = "average")

heatcol <- colorRampPalette(c("Green", "Red"))(32)
heatmap(x = as.matrix(m), Rowv = as.dendrogram(clust.genes),
        Colv = as.dendrogram(clust.arrays), col = heatcol, margin = c(5, 8))

GSEABase::annotation(c_aeset)
gsc <- GSEABase::GeneSetCollection(object = c_aeset, setType = GSEABase::GOCollection()) # TODO fails here
Am <- GSEABase::incidence(gsc)
dim(Am)
nsF <- cAEset[colnames(Am),]
rtt <- genefilter::rowttests(nsF, fac)
rttStat <- rtt$statistic
selectedRows <- (rowSums(Am) > 10)
Am2 <- Am[selectedRows,]
tA <- as.vector(Am2 %*% rttStat)
tAadj <- tA / sqrt(rowSums(Am2))
names(tA) <- names(tAadj) <- rownames(Am2)
smPW <- which(tAadj == min(tAadj))
pwName <- KEGG.db::KEGGPATHID2NAME[[names(smPW)]]
pwName
smPW <- which(tAadj == min(tAadj))
par(mfrow = c(1, 1))
annotate::KEGG2heatmap(names(smPW), nsF, "moe430a") # TODO color palette is hidden in PDF

affyUniverse <- featureNames(c_aeset)
uniId <- moe430a.db::moe430aENTREZID[affyUniverse] # TODO error
entrezUniverse <- unique(as.character(uniId))
affysub <- ID
uniIdsub <- pd.hg.u133a::moe430aENTREZID[affysub]
entrezsub <- unique(as.character(uniIdsub))

params <- new("GOHyperGParams", # ? GOstats::GOHyperGParams
              geneIds = entrezsub,
              universeGeneIds = entrezUniverse,
              annotation = "moe430a",
              ontology = "BP",
              pvalueCutoff = 0.05,
              conditional = FALSE,
              testDirection = "over")
mfhyper <- GOstats::hyperGTest(params)
mfhyper
hist(pvalues(mfhyper), breaks = 50, col = "mistyrose")

gcDyn <- list()
gcDyn$h0 <- entrezsub

library("ReactomePA")
library("GO.db")
# TODO clusterProfiler, not "clusterprofiler"
dynTableGODB <- clusterProfiler::compareCluster(gcDyn, fun = "groupGO", organism = "mouse") # TODO other arguments are hidden in PDF

