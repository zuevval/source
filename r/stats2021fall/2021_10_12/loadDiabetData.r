# Title     : Loading and transforming Diabet data
# Created by: Valerii Zuev
# Created on: 10/18/2021

library("tidyverse") # dplyr, ggplot2, purrr, ...

diabetData <- "r/stats2021fall/2021_10_12/Diabet/diabetes.csv" %>%
  here::here() %>%
  read.table(header = T, sep = ";", dec = ",", stringsAsFactors = T)

diabetData$height <- diabetData$height * 2.54 / 100 # meters
diabetData$weight <- diabetData$weight * 0.45359237 # kilograms

diabetData$bmi <- diabetData$weight / diabetData$height^2 # body mass index
diabetData$bmif <- NA
diabetData$bmif[diabetData$bmi < 19] <- "Under"
diabetData$bmif[diabetData$bmi >= 19 & diabetData$bmi < 25] <- "Normal"
diabetData$bmif[diabetData$bmi >= 25 & diabetData$bmi < 30] <- "Over"
diabetData$bmif[diabetData$bmi >= 30] <- "Obesity"