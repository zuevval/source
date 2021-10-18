source(here::here("r/stats2021fall/2021_10_12/loadDiabetData.r"))
dd <- diabetData

alpha <- .05 # significance level
qnt <- qnorm(1 - alpha / 2) # quantile for the confidence interval
lv.loc <- levels(as.factor(dd$location)) # levels of `location` factor
bnf <- length(lv.loc) # denominator for the Bonferroni correction

st.loc <- lv.loc %>% lapply(function(ff = ? factor){ # statistics for location
  dd.i <- dd %>% filter(location == ff, !is.na(chol)) # a subset of diabetData with `location` == ff
  mean.i.chol <- mean(dd.i$chol) # mean cholesterol in `dd.i`
  mse.i.chol <- sqrt(var(dd.i$chol)) # mean square error of cholesterol in `dd.i`
  n.i <- nrow(dd.i)
  qnt.i <- qnorm(1 - alpha / 2 / bnf) # a quantile for the corrected confidence interval

  delta.i.naive <- qnt * mse.i.chol / sqrt(n.i) # confidence interval width
  delta.i.corrected <- qnt.i * mse.i.chol / sqrt(n.i) # conf. interval width with correction

  data.frame(
    location = ff,
    mean = mean.i.chol,
    mse = mse.i.chol,
    ci.naive.lower = mean.i.chol - delta.i.naive,
    ci.naive.upper = mean.i.chol + delta.i.naive,
    ci.bnfnaive.lower = mean.i.chol - delta.i.corrected,
    ci.bnfnaive.upper = mean.i.chol + delta.i.corrected
  )
} -> data.frame)

