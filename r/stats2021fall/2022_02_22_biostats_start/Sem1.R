#Pagani, Chapter2 - "но там слишком много всего разжёвывается, начинается с"
# Сергей Васильевич: "на мой взгляд, интересная книга Агристи - Introduction:  она простая, но интересная,
# нет такого наплыва биологической информации, за которыми теряется суть статистических исследований"
library(tidyverse)

read_tbl <- function(filename) here::here("r/stats2021fall/2022_02_22_biostats_start/data", filename) %>% read.table(header = T, as.is = T)

# cigarettes
dat <- read_tbl("cigarettes_per_year.txt")
counts <- dat$number
barplot(counts, main = "Cigarettes per year", xlab = "Year", names.arg = dat$year)
plot(dat$year, dat$number, "l", main = "Cigarettes per year", xlab = "Year", ylab = "Cigarettes per year", lwd = 3, col = "red")
points(dat$year, dat$number, col = "blue", cex = 3)
points(dat[dat$number == max(dat$number),], pch = 19, col = "green", cex = 3)
#
dat <- read_tbl("crude_death_rates.txt")
boxplot(dat$rate)
hist(dat$rate)

# ядерная оценка хороша для распределений, подобных нормальному, но, скажем, для экспоненциального, где в нуле разрыв,
# подходит плохо. Предлагается иногда переходить к логарифмам, в логарифмах строить и переходить обратно.
# Но это не работает.

barplot(dat$rate, main = "Crude death rates", names.arg = dat$state, las = 2)
pdf("plot.pdf", height=9, width=9)
pie(dat$rate, main = "Crude death rate per 100000", labels = dat$rate, col = c("red", "blue", "yellow", "green", "purple"), cex = 1)
dev.off()
pie(dat$rate, main = "Crude death rate per 100000", labels = paste0(round(dat$rate / sum(dat$rate) * 100, digits = 2), "%"), col = c("red", "blue", "yellow", "green", "purple"), cex = 0.5)

#
dat1 <- dat[order(dat$rate),]
barplot(dat1$rate, main = "Crude death rates", names.arg = dat1$state, las = 2)
#
dat <- read_tbl("health_care_expenditures.txt")
barplot(t(as.matrix(dat[, c(2, 3)])), main = "Health care expenditures", xlab = "Year", names.arg = dat$year, beside = T, col = c("red", "blue"))
legend("topleft", legend = names(dat)[c(2, 3)], col = c("red", "blue"), pch = 15, ncol = 1, bty = "n")
#
dat <- read_tbl("health care expend by gdp.txt")
dat$percent[dat$percent == "."] <- NA
dat$percent <- as.numeric(dat$percent)
ftr <- is.na(dat$percent)
dat1 <- dat[!ftr,]
barplot(dat1$percent, main = "Health care exp.", xlab = "", names.arg = dat1$country, cex.names = 1, las = 2)
# injury death
dat <- read_tbl("injury deaths.txt")
cts <- table(dat)
nm <- c("Motor vehicle", "Drowning", "House fire", "Homicide", "Other")
pie(cts, main = "Injury death", labels = nm, col = c("red", "blue", "yellow", "green", "purple"), cex = 1)
pie(cts, main = "Injury death", labels = paste0(round(cts / sum(cts) * 100, digits = 2), "%"), col = c("red", "blue", "yellow", "green", "purple"), cex = 1)

# ----------------
# --- Chapter3 ---
# ----------------
dat <- read_tbl("fev1.txt", header = T, as.is = T)
tt <- table(dat$gender)
pie(table(dat$gender), main = "Injury death", labels = c("female", "male"), col = c("red", "blue"), cex = 1)
pie(tt, main = "Asthma research", labels = paste0(round(tt / sum(tt) * 100, digits = 1), "%"), col = c("red", "blue"), cex = 0.5)

    