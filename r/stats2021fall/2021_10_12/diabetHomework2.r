source(here::here("r/stats2021fall/2021_10_12/loadDiabetData.r"))
dd <- diabetData
alpha <- .5
bmif.lv <- levels(as.factor(dd$bmif))
bmif.comb <- combn(bmif.lv, 2)
n.pairs <- ncol(bmif.comb)
alj <- alpha / n.pairs

factors <- c("stab.glu", "chol", "glyhb")
st.bmif <- factors %>% lapply(function(ff = ? factor){
  dd.no_na <- dd %>% filter(!is.na(!!sym(ff))) # it seems to be unnecessary, `t.test` handles NA, but still...
  apply(bmif.comb, 2, function(lv.pair = ? character){
    t.res <- t.test(as.formula(paste(ff, "~ bmif")), data = dd.no_na %>% filter(bmif %in% lv.pair))
    data.frame(g1 = lv.pair[1], g2 = lv.pair[2], pv = t.res$p.value, stat = t.res$statistic, ci.low = t.res$conf.int[1], ci.up = t.res$conf.int[2])
  } -> data.frame) %>%
    bind_rows %>%
    arrange(pv)
} -> data.frame)
names(st.bmif) <- factors
st.bmif
