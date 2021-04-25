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
c_aeset_colnames <- c("stimulus", "disease")

groups1 <- pData(c_aeset1)[, fac]
groups1[groups1 == "incubated for 1.5 hour without any stimulation"] <- "incub"
groups1[groups1 == "no incubation"] <- "noincub"
groups1[groups1 == "stimulated with IFN-gamma for 1.5 hour"] <- "ig"
groups1[groups1 == "stimulated with IFN-alpha-2a for 1.5 hour"] <- "ia"
groups1[groups1 == "stimulated with TNF-alpha for 1.5 hour"] <- "ta"
groups1
colnames(groups1) <- c_aeset_colnames
c_aeset_stimulus <- c_aeset1[, groups1$disease == "normal"] # drop ill patients
groups_stimulus <- groups1 %>%
  filter(disease == "normal") %>% # drop ill patients
  select(-disease)

groups2 <- pData(c_aeset2)[, fac]
groups2[groups2 == "rheumatoid arthritis"] <- "ra"
groups2[groups2 == "systemic lupus erythematosus"] <- "sl"
colnames(groups2) <- c_aeset_colnames
groups2
c_aeset_disease <- c_aeset2 # just define a new name for convenience
groups_disease <- groups2 %>% select(-stimulus)

# fitting linear model for stimulus
f_stimulus <- factor(unlist(groups_stimulus))
design_stimulus <- model.matrix(~f_stimulus)
colnames(design_stimulus) <- colnames(design_stimulus) %>% lapply(function(x) gsub("f_stimulus", "", x))
print(design_stimulus)
print(limma::is.fullrank(design_stimulus)) # should be TRUE

fit_stimulus <- limma::lmFit(c_aeset_stimulus, design_stimulus)
fit_stimulus2 <- limma::eBayes(fit_stimulus)
head(fit_stimulus2$coefficients)
png(filename = "./img/volcanoplot_stimulus.png")
par(mfrow = c(1, 2))
limma::volcanoplot(fit_stimulus2, coef = "ta", highlight = 15, main = "stimulus: TNF-alpha")
limma::volcanoplot(fit_stimulus2, coef = "ig", highlight = 15, main = "stimulus: IFN-gamma")
dev.off()

# the same for disease
f_disease <- factor(unlist(groups_disease))
design_disease <- model.matrix(~f_disease)
colnames(design_disease) <- colnames(design_disease) %>% lapply(function(x) gsub("f_disease", "", x))
print(design_disease)
print(limma::is.fullrank(design_disease)) # should be TRUE

fit_disease <- limma::lmFit(c_aeset_disease, design_disease)
fit_disease2 <- limma::eBayes(fit_disease)
head(fit_disease2$coefficients)
png(filename = "./img/volcanoplot_disease.png")
par(mfrow = c(1, 2))
limma::volcanoplot(fit_disease2, coef = "ra", highlight = 15, main = "rheumatoid arthritis")
limma::volcanoplot(fit_disease2, coef = "sl", highlight = 15, main = "systemic lupus erythematosus")
dev.off()

draw_clust_heatmap <- function(c_aeset = ? data.frame,
                               groups = ? data.frame,
                               fit = ? limma::MArrayLM,
                               pval_thresh = ? integer,
                               coef = ? character,
                               title = ? character){
  results <- limma::topTable(fit, coef = coef, adjust = "BH", number = nrow(c_aeset))
  print(as.integer(results[, "P.Value"] < pval_thresh) %>%
          na.exclude %>%
          sum) # how many differentially expressed genese were found?
  topgenes <- results[results[, "P.Value"] < pval_thresh,]
  diffexpr_ids <- rownames(topgenes)

  diffexpr_ids %>%
    unlist %>%
    write.table(paste0("./genes_diffexpr_", title, ".csv"), sep = ",", row.names = F, col.names = F, quote = F)
  results %>%
    rownames %>%
    unlist %>%
    write.table(paste0("./genes_background_", title, ".csv"), sep = ",", row.names = F, col.names = F, quote = F)

  m <- exprs(c_aeset[diffexpr_ids,])
  ncol(m)
  colnames(m) <- unlist(groups[1])
  png(filename = paste0("./img/heatmap_", title, ".png"))
  heatmap(m)
  dev.off()
} -> NULL

c_aeset_ra <- c_aeset_disease[, groups_disease$disease != "sl"]
c_aeset_sl <- c_aeset_disease[, groups_disease$disease != "ra"]
groups_ra <- groups_disease %>% filter(disease != "sl")
groups_sl <- groups_disease %>% filter(disease != "ra")

devnull <- mapply(draw_clust_heatmap,
                  list(c_aeset_stimulus, c_aeset_ra, c_aeset_sl),
                  list(groups_stimulus, groups_ra, groups_sl),
                  list(fit_stimulus2, fit_disease2, fit_disease2),
                  list(1e-3, 5 * 1e-3, 2 * 1e-3),
                  list("ig", "ra", "sl"),
                  list("stimulus", "ra", "sl"))


GSEABase::annotation(c_aeset_stimulus)
GSEABase::annotation(c_aeset_disease)
