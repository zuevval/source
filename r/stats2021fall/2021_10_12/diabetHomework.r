source(here::here("r/stats2021fall/2021_10_12/loadDiabetData.r"))
dd <- diabetData

alpha <- .05 # significance level
qnt <- qnorm(1 - alpha / 2) # quantile for the confidence interval
lv.loc <- levels(as.factor(dd$location)) # levels of `location` factor
bnf <- length(lv.loc) # denominator for the Bonferroni correction

st.loc <- lv.loc %>%
  lapply(function(ff = ? factor){ # statistics for location
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
      ci.bnfnaive.upper = mean.i.chol + delta.i.corrected,
      ni = n.i
    )
  } -> data.frame) %>%
  bind_rows

z <- 1.96 # confidence level 0.95
st.loc.meanDiffConfBand <- z * sqrt(sum(st.loc$mse^2 / st.loc$ni))
mean.diff <- st.loc$mean[1] - st.loc$mean[2]
mean.diff.confInterval <- c(mean.diff - st.loc.meanDiffConfBand, mean.diff + st.loc.meanDiffConfBand)

t.test(chol ~ location, data = dd) # Welch test

# ----------------------------------------------
# --------------  part 2  ----------------------
# ----------------------------------------------

lv.bmif <- levels(as.factor(dd$bmif))

st.bmif <- lv.bmif %>% # per BMI group statistics
  lapply(function(ff = ? factor) {
    dd.i <- dd %>% filter(bmif == ff, !is.na(chol))
    data.frame(bmif = ff, mean = mean(dd.i$chol), mse = sqrt(var(dd.i$chol)), ni = nrow(dd.i))
  } -> data.frame) %>%
  bind_rows

pairs.bmif <- data.frame(first = c("Over", "Obesity", "Normal"), second = c("Obesity", "Normal", "Under"))
bnf.bmif <- length(pairs.bmif) # denominator for the Bonferroni correction
z.bmif <- 2.33 # parameter for significance level 0.02 (~0.5/3)

st.pairs.bmif <- pairs.bmif %>% # joint confidence intervals for the difference between the BMI group means
  apply(1, function(pair = ? character) {
    st.pair.i <- st.bmif %>% filter(bmif %in% pair)
    st.bmif.meanDiffConfWidth <- z.bmif * sqrt(sum(st.pair.i$mse^2 / st.pair.i$ni))
    mean.diff <- st.pair.i$mean[1] - st.pair.i$mean[2]
    data.frame(lower = mean.diff - st.bmif.meanDiffConfWidth, upper = mean.diff + st.bmif.meanDiffConfWidth)
  } -> data.frame) %>%
  bind_rows %>%
  bind_cols(pairs.bmif)
