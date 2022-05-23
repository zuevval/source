library(tidyverse)

df <- here::here("r/stats2021fall/homework4", "IDZ4_Data_504020121.csv") %>%
  read.csv %>%
  filter(Variant == 4) %>%
  select(!Variant) %>%
  mutate(A = as.factor(A), B = as.factor(B)) # B is time-dependent, A is not (see LMM.R -> ATD, BTD)

# -----
# task 3
# -----

# plot with time variable (`Visit`)
colors <- c("green", "blue", "yellow")
png(filename = "traj_with_time.png", width = 700, height = 700)
plot(df$Visit, df$Y, "n")
for (i in df$ID[1:90]) {
  df.i <- df[df$ID == i,]
  color <- colors[df.i[1,]$A]
  points(df.i$Visit, df.i$Y, "l", col = color)
}
title("First 30 trajectories; green: A=1, blue: A=2")

traj.med <- NULL
for (i in 0:2) {
  traj.med <- c(traj.med, mean(df$Y[df$Visit == i]))
}
points(0:2, traj.med, "l", col = "red", lwd = 3)

traj.med.ai <- function(i_a) { 0:2 %>%
  lapply(function(i) filter(df, A == i_a, Visit == i)$Y %>% mean) %>%
  unlist }
points(0:2, traj.med.ai(0), col = "green", lwd = 5)
points(0:2, traj.med.ai(1), col = "blue", lwd = 5)
dev.off()

# to table (for correlations)
to_one_row <- function(dfi = ? data.frame) {
  res <- data.frame("ID" = dfi$ID[1], "A" = dfi$A[1])
  for (i_visit in dfi$Visit) {
    yvi_name <- paste0("Y_V", i_visit)
    res[yvi_name] <- dfi$Y[dfi$Visit == i_visit]
    ybi_name <- paste0("Y_B", i_visit)
    res[ybi_name] <- dfi$B[dfi$Visit == i_visit]
  }
  res
}

df.id_grouped <- df %>%
  group_by(ID) %>%
  group_split %>%
  lapply(to_one_row) %>%
  rbindlist

# calculating correlations
df.ids <- unique(df$ID)
lv.a <- levels(df$A)
lv.b <- levels(df$B)
lv.visit <- levels(as.factor(df$Visit))

yv_names <- paste0("Y_V", lv.visit)
corr.all <- var(df.id_grouped[, names(df.id_grouped) %in% yv_names]) # YouT 2:21:15

# ----
# task 4. Mixed linear model
# ----

# plot no B effect


