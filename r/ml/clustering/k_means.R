# Title     : k-means clustering
# Created by: Valerii Zuev
# Created on: 1/3/2021

library(here) # relative paths
library(types) # type hints
library(cluster) # k means, k medoids (clara), datasets: pluton
library(tidyverse)

abs_path <- function(path) here("r/ml/clustering", path) # path relative to the Git root
std_img_width <- 6000
std_img_height <- 6000
std_img_dpi <- 600

# ---------------------------------
# --- k means for `pluton` data ---
# ---------------------------------

data(pluton)
head(pluton)

for (iter.max in c(2, 4, 6)) {
  set.seed(0) # for reproducibility
  jpeg(file = abs_path(paste0("pluton_max_iter_", iter.max, ".jpeg")), width = std_img_width, height = std_img_height, res = std_img_dpi)
  pairs(pluton, col = kmeans(pluton, 3, iter.max = iter.max)$cluster)
  dev.off()
}

# -------------------------------------
# --- k medoids for actificial data ---
# -------------------------------------

set.seed(0) # for reproducibility
n_elem <- 35
art_data <- rbind(data.frame(x = rnorm(n_elem, mean = 0, sd = .2), y = rnorm(n_elem, mean = .5, sd = 3), cluster = rep(1, n_elem)),
                  data.frame(x = rnorm(n_elem, mean = 1, sd = .2), y = rnorm(n_elem, mean = -.5, sd = 3), cluster = rep(2, n_elem)),
                  data.frame(x = rnorm(n_elem, mean = 2, sd = .2), y = rnorm(n_elem, mean = .5, sd = 3), cluster = rep(3, n_elem))) %>%
  mutate(cluster = as.factor(cluster))

ggplot(data = art_data, aes(x, y, color = cluster, shape = cluster)) +
  geom_point() +
  ggtitle(" data generated from 3 normal distributions ") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))
ggsave(abs_path("art_data.png"), scale = .3)

clara_err <- expand.grid(metric = c("euclidean", "manhattan", "jaccard"), stand = c(T, F))
clara_err$value <- mapply(function(metric = ? chraracter, stand = ? bool) {
  predicted_clusters <- clara(art_data %>% select(-cluster), k = 3, stand = stand, metric = as.character(metric))$clustering
  n_correct <- table(art_data$cluster, predicted_clusters) %>%
    unlist %>%
    sort %>%
    tail(3) %>%
    sum
  1 - n_correct / length(art_data$cluster)
}, clara_err$metric, clara_err$stand)

ggplot(data = clara_err, aes(x = metric, y = value, fill = stand, color = stand)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  ggtitle("clustering error (k medoids) with different metrics") +
  theme_bw() +
  labs(fill = "standartized", color = "standartized") +
  theme(plot.title = element_text(hjust = .5), legend.title =)
ggsave(abs_path("art_data_err.png"), scale = .3)

# ----------------------------------------------------------------
# --- dendrogram for `votes.repub` data and for `animals` data ---
# ----------------------------------------------------------------

data(votes.repub)
head(votes.repub)
set.seed(0) # for reproducibility

jpeg(file = abs_path("dnd_votes.jpeg"), width = std_img_width, height = std_img_height, res = std_img_dpi)
plot(agnes(votes.repub))
dev.off()

data(animals)
head(animals)
set.seed(0) # for reproducibility

jpeg(file = abs_path("dnd_animals.jpeg"), width = std_img_width, height = std_img_height, res = std_img_dpi)
plot(agnes(animals))
dev.off()

# ---------------------------------
# --- exploring `seeds_dataset` ---
# ---------------------------------

library(dendextend) # for `labels_colors`

seeds_data <- abs_path("seeds_dataset.txt") %>%
  read.table(sep = "\t") %>% # data has been preprocessed: [integer]\t\t -> [integer].00\t, [float]\t\t -> [float]\t
  rename(area = V1, perim = V2, compac = V3, len = V4, width = V5, asym = V6, shaft = V7, type = V8) %>%
  mutate(type = as.factor(type))
head(seeds_data)
seeds_features <- seeds_data %>% select(-type)

# dendrogram
jpeg(file = abs_path("dnd_seeds.jpeg"), width = 15000, height = 5000, res = std_img_dpi)
seeds_dnd <- seeds_features %>%
  agnes %>%
  as.dendrogram
labels_colors(seeds_dnd) <- as.numeric(seeds_data$type)
plot(seeds_dnd)
dev.off()


# pairs
jpeg(file = abs_path("seeds_pairs.jpeg"), width = std_img_width, height = std_img_height, res = std_img_dpi)
pairs(seeds_features, col = seeds_data$type)
dev.off()

lapply(c(2, 3, 4, 5), function(n_centers) {
  predict <- kmeans(seeds_features, centers = n_centers)$cluster
  correct <- table(predict, seeds_data$type) %>%
    unlist %>%
    sort %>%
    tail(n_centers) %>%
    sum
  err_rate <- (1 - correct / length(predict)) %>% round(2)
  jpeg(file = abs_path(paste0("seeds_clusplot", n_centers, ".jpeg")), width = std_img_width, height = std_img_height, res = std_img_dpi)
  clusplot(seeds_data, clus = kmeans(seeds_features, centers = n_centers)$cluster, color = T, col.p = seeds_data$type,
           main = paste0("seeds data: k means clustering\n(k = ", n_centers, ", error rate: ", err_rate, ", dimensions reduced with PCA)"))
  dev.off()
})
