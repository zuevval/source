BiocManager::version()
library("unifiedWMWqPCR") # Wilcoxon-Mann Whitney Test
setwd("D:/dataVal/Work/git/source/r/bioinf2021/lab1microarrays")

# 2 gene expression data 

dataDirectory <- system.file("extdata", package="Biobase")
exprsFile <- file.path(dataDirectory, "exprsData.txt")
exprs <- as.matrix(read.table(exprsFile, header=TRUE,
                             sep="\t", row.names=1, as.is=TRUE))

# 3 Annotating samples

pDataFile <- file.path(dataDirectory, "pData.txt")
pData <- read.table(pDataFile,
                   row.names=1, header=TRUE, sep="\t")
dim(pData)
rownames(pData)
summary(pData)
all(rownames(pData) == colnames(exprs))

# 4 properties metadata

metadata <- data.frame(labelDescription=c("Patient gender", "Case/control status", "Tumor progress on XYZ scale"),
                      row.names=c("gender", "type", "score"))

# 5 annotatedDataFrame

library(Biobase)
adf <- new("AnnotatedDataFrame", data=pData, varMetadata=metadata)
head(pData(adf))
adf[c("A","Z"), "gender"]
pData(adf[adf$score > 0.8,])
annotation <- "hgu95av2"
experimentData <- new("MIAME", name="Valerii Zuev",
                     lab="BrailleSystems Lab",
                     contact="valera.zuev.zva@gmail.com",
                     title="Smoking-Cancer Experiment",
                     abstract="An example ExpressionSet",
                     url="http://braille-systems.ru",
                     other=list(notes="Created from text files"))

exampleSet <- new("ExpressionSet", exprs=exprs,
                 phenoData=adf, experimentData=experimentData,
                 annotation="hgu95av2")
minimalSet = new("ExpressionSet", exprs=exprs)
help("ExpressionSet-class")

exampleSet$gender[1:5]
exampleSet$gender[1:5] == "Female"
featureNames(exampleSet)[1:5]
sampleNames(exampleSet)[1:5]
varLabels(exampleSet)

mat <- exprs(exampleSet)
dim(mat)
adf <- phenoData(exampleSet)

vv <- exampleSet[1:5, 1:3]
dim(vv)
featureNames(vv)
sampleNames(vv)
males <- exampleSet[, exampleSet$gender == "Male"]

# 6 expression data processing

library("CLL")
data("CLLbatch")
sampleNames(CLLbatch)

data("disease")
head(disease)
rownames(disease) <- disease$SampleID
sampleNames(CLLbatch) <- sub("\\.CEL$", "",sampleNames(CLLbatch))
mt <- match(rownames(disease), sampleNames(CLLbatch))

vmd <- data.frame(labelDescription = c("Sample ID","Disease status: progressive"))
phenoData(CLLbatch) = new("AnnotatedDataFrame",data = disease[mt, ], varMetadata) # TODO err

CLLbatch = CLLbatch[, !is.na(CLLbatch$Disease)]

# packages: `arrayQualityMetrics`, `affyQCReport` (fun affyQAReport), `simpleaffy`

library("simpleaffy")
library("affyQCReport")

data("CLLbatch")
saqc <- qc(CLLbatch)
plot(saqc)

dd = dist2(log2(exprs(CLLbatch)))
diag(dd) = 0
dd.row <- as.dendrogram(hclust(as.dist(dd)))
row.ord <- order.dendrogram(dd.row)

library("affyPLM")
dataPLM = fitPLM(CLLbatch)

boxplot(dataPLM, main="NUSE", ylim = c(0.95, 1.22),
        outline = FALSE, col="lightblue", las=3, whisklty=0, staplelty=0)

Mbox(dataPLM, main="RLE", ylim = c(-0.4, 0.4),
     outline = FALSE, col="mistyrose", las=3, whisklty=0, staplelty=0)


library("CLL")
data("CLLbatch")
badArray = match("CLL1", sampleNames(CLLbatch))
CLLB = CLLbatch[, -badArray]
CLLrma = rma(CLLB) # TODO crashing here
