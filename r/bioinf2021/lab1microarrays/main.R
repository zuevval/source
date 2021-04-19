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

library(dplyr)
setwd("D:/dataVal/Work/git/source/r/bioinf2021/lab1microarrays/data/out/")

geod38351 <- ArrayExpress::getAE("E-GEOD-38351", type = "full")
aeset <- ArrayExpress::ae2bioc(mageFiles = geod38351)
aeset1 <- aeset[[1]] # TODO proces second (AFFY-33)

# finding a factor
colnames1 <- colnames(pData(aeset1))
fac = colnames1[grep("Factor", colnames1)]
fac

arrayQualityMetrics::arrayQualityMetrics(expressionset = aeset1, outdir = "qaraw_geod_38351_1",
                    force = FALSE, do.logtransform = TRUE, intgroup = fac)
# array 1 stands out!
c_aeset <- oligo::rma(aeset1[, -1])

groups <- pData(c_aeset)[, fac]
colnames(groups) <- c("stimulus", "disease")
groups[groups == "incubated for 1.5 hour without any stimulation"] <- "incub"
groups[groups == "no incubation"] <- "no_incub"
groups[groups == "stimulated with IFN-gamma for 1.5 hour"] <- "ig"
groups[groups == "stimulated with IFN-alpha-2a for 1.5 hour"] <- "ia"
groups[groups == "stimulated with TNF-alpha for 1.5 hour"] <- "ta"
groups[groups == "rheumatoid arthritis"] <- "ra"
f_stimulus <- factor(groups$stimulus)
f_disease <- factor(groups$disease)

design = model.matrix(~0 + f_stimulus:f_disease)
colnames(design) <- colnames(design) %>% lapply(function(x) gsub("f_stimulus|f_disease", "", x))
print(design)

fit = limma::lmFit(c_aeset, design)
fit2 = limma::eBayes(fit)

par(mfrow = c(1, 2))
limma::volcanoplot(fit2, coef="ia:normal", highlight=15)
limma::volcanoplot(fit2, coef="ta:normal", highlight=15)



results = limma::topTable(fit2, coef = "KOvsWT", adjust = "BH", number =nrow(cAEset))
topgenes = results[results[, "P.Value"] < 0.001, ]

ID <- rownames(topgenes)
m = exprs(cAEset[ID, ])
colnames(m) = 1:9

colours = c("lightgreen", "mediumpurple")
col = colours[f]
heatmap(m, ColSideColors = col, margin = c(5, 8))

plot(hclust(dist(m)))

clust.genes<-amap::hcluster(x=m, method="pearson", link="average")
clust.arrays<-amap::hcluster(x=t(m), method="pearson", link="average")

heatcol<-colorRampPalette(c("Green", "Red"))(32)
heatmap(x=as.matrix(m), Rowv=as.dendrogram(clust.genes),
        Colv=as.dendrogram(clust.arrays), col=heatcol, margin = c(5, 8))

GSEABase::annotation(cAEset)
gsc = GSEABase::GeneSetCollection(object=cAEset, setType = GSEABase::KEGGCollection()) # TODO fails here
Am = GSEABase::incidence(gsc)
dim(Am)
nsF = cAEset[colnames(Am), ]
rtt = genefilter::rowttests(nsF, fac)
rttStat = rtt$statistic
selectedRows = (rowSums(Am) > 10)
Am2 = Am[selectedRows, ]
tA = as.vector(Am2 %*% rttStat)
tAadj = tA/sqrt(rowSums(Am2))
names(tA) = names(tAadj) = rownames(Am2)
smPW = which(tAadj == min(tAadj))
pwName = KEGG.db::KEGGPATHID2NAME[[names(smPW)]]
pwName
smPW = which(tAadj == min(tAadj))
par(mfrow=c(1,1))
annotate::KEGG2heatmap(names(smPW), nsF, "moe430a") # TODO color palette is hidden in PDF

affyUniverse = featureNames(cAEset)
uniId = moe430a.db::moe430aENTREZID[affyUniverse] # TODO error
entrezUniverse = unique(as.character(uniId))
affysub=ID
uniIdsub = moe430a.db::moe430aENTREZID[affysub]
entrezsub = unique(as.character(uniIdsub))

params = new("GOHyperGParams", # ? GOstats::GOHyperGParams
             geneIds=entrezsub,
             universeGeneIds=entrezUniverse,
             annotation="moe430a",
             ontology="BP",
             pvalueCutoff=0.05,
             conditional=FALSE,
             testDirection="over")
mfhyper = GOstats::hyperGTest(params)
mfhyper
hist(pvalues(mfhyper), breaks=50, col="mistyrose")

gcDyn <- list()
gcDyn$h0 <- entrezsub

library("ReactomePA")
library("GO.db")
# TODO clusterProfiler, not "clusterprofiler"
dynTableGODB <- clusterProfiler::compareCluster(gcDyn, fun="groupGO", organism = "mouse") # TODO other arguments are hidden in PDF

