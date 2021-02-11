# modified affy::rma

my_rma <- function (object, subset = NULL, verbose = TRUE, destructive = TRUE, 
          normalize = TRUE, background = TRUE, bgversion = 2, ...) 
{
  rows <- length(affy::probeNames(object, subset))
  cols <- length(object)
  if (is.null(subset)) {
    ngenes <- length(geneNames(object))
  }
  else {
    ngenes <- length(subset)
  }
  pNList <- affy::probeNames(object, subset)
  pNList <- split(0:(length(pNList) - 1), pNList)
  if (destructive) {
    exprs <- .Call("rma_c_complete", pm(object, subset), 
                   pNList, ngenes, normalize, background, bgversion, 
                   verbose, PACKAGE = "affy")
  }
  else {
    exprs <- .Call("rma_c_complete_copy", pm(object, subset), 
                   pNList, ngenes, normalize, background, bgversion, 
                   verbose, PACKAGE = "affy")
  }
  colnames(exprs) <- sampleNames(object)
  new("ExpressionSet", phenoData = phenoData(object), annotation = annotation(object), 
      protocolData = protocolData(object), experimentData = experimentData(object), 
      exprs = exprs)
}
