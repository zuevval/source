library(ggplot2)
library(dplyr)
library(gridExtra)
dat <- data.frame(
  time = factor(c("Lunch", "Dinner"), levels=c("Lunch", "Dinner")),
  total_bill = c(14.89, 17.23)
)
head(dat)
options(repr.plot.width=12, repr.plot.height=2)
gg1 <- ggplot(data=dat, aes(x=time, y=total_bill)) + geom_bar(stat="identity")
gg2 <- ggplot(data=dat, aes(x=time, y=total_bill)) + geom_bar(stat="identity") + guides(fill=FALSE) + xlab("happy happy")

gg3 <- ggplot(data=dat, aes(x=time, y=total_bill, group=1)) + geom_line()


tg <- ToothGrowth
head(tg)
tgg <- group_by(tg, supp, dose)
tgs <- summarize(tgg,
                 len_mean = mean(len),
                 len_max = mean(len) + 1.96 * sd(len)/sqrt(length(len)),
                 len_min = mean(len) - 1.96 * sd(len)/sqrt(length(len))
)
head(tgs)
gg4 <- ggplot(tgs, aes(x=dose, y=len_mean, colour=supp)) +
  geom_errorbar(aes(ymin=len_mean, ymax=len_max), width=.1) +
  geom_line() +
  geom_point()

gg4
