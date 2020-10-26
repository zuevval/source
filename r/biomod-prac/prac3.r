library('dplyr')
my.data <- read.csv("./task1-2020-oct-05/test_data2.csv")
my.data <- na.omit(my.data)
head(arrange(my.data, V_1))
head(rename(my.data, 'New Name' = V_3))
# head(mutate(my.data, X = X + 1, BegEndM=))

# group by / summarize
gr_my_data <- group_by(my.data, V_97)
# summarize(my.data, numbers=n(), meanPodsWeight)

library('data.table') # high efficiency

str(iris) # embedded
apply(iris, 1, function(x){x[Sepal.Length] > 5})
iris['Sepal.Length' > 5]
subset(iris, Sepal.Length > 5)
library('dplyr')
filter(iris, Sepal.Length > 5)
iris[('Sepal.Length' > 5) & ('Species' %in% c('versicolor', 'setosa'))] # TODO why 0 columns? convert to data.table?

