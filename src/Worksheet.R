features <- read.table("../features.txt",)[,2]
head(features)
features[,2]
x_test <- read.table("X_test.txt",col.names=features)
subTest <- read.table("subject_test.txt")
read.