# ------------------------------------------
# --- 7: ArrayExpress database (page 23) ---
# ------------------------------------------
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

setwd("D:/dataVal/Work/git/source/r/bioinf2021/lab1microarrays/data/out/") # change to your path


AEset = ArrayExpress::ArrayExpress("E-MEXP-886")
colnames(pData(AEset))

fac = colnames(pData(AEset))[grep("Factor", colnames(pData(AEset)))]
fac

arrayQualityMetrics::arrayQualityMetrics(expressionset = AEset, outdir = "QAraw",
                    force = FALSE, do.logtransform = TRUE, intgroup = fac)

# exercise 10 (page 25)
cAEset = AEset[, -6] # TODO not renormalized
groups = pData(cAEset)[, fac]

groups[groups == "wild_type"] = "WT"
groups[groups == "ataxin 1 -/-"] = "KO"
f = factor(groups)

design = model.matrix(~f)
colnames(design) = c("WTvsRef", "KOvsWT")
design

fit = limma::lmFit(cAEset, design)
fit2 = limma::eBayes(fit)
limma::volcanoplot(fit2, coef="KOvsWT", highlight=15)

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
