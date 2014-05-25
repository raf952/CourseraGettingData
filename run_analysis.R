library(plyr)

# read in the column names from the features.txt file. Clean up multiple dots and expand the "t" and
# "f" prefixes with "time" and "frequency" respectively
features <- gsub("^t", "time ", 
                 gsub("^f", "freq ",
                      sub("\\.$", "", gsub("\\.+", ".",
                           make.names(read.table("UCI HAR Dataset/features.txt",)[,2])))))

# selects only the columns that are the mean or standard deviation of measures. These were features that
# ended with " mean()" or " std()" orignally.
meanStdCols <- function(x){
        grep("\\.(mean|std)\\.", x)
}

# returns a data frame of the mean and standard deviations of the specified data set (train or test)
tidyTables <- function(dataset ) {
        tmp <-read.table(paste("UCI HAR Dataset/", dataset, "/X_", dataset, ".txt", sep=""),col.names=features)
        tmp <- tmp[, meanStdCols(colnames(tmp))]

        subjects <-read.table(paste("UCI HAR Dataset/", dataset, "/subject_", dataset, ".txt", sep=""),col.names=c("subject"))
        
        tmp <- cbind(dataset, list(subject = subjects$subject), tmp)
        
        tmp
}

#create our tidy data set by combining desired colums from the test and train data files
tidyData <- rbind(tidyTables("test"), tidyTables("train"))

# Column names
colnames(tidyData)

#+ glimpse of Tidy Data:
#...
tidyData[1:3, 1:5]
#...

# create our mean data set containing the average of each variable for each activity and each subject
meanTidyData <- arrange(aggregate(tidyData[,grep("(subject|dataset)", colnames(tidyData), invert=TRUE)],
                                  list(Subject = tidyData$subject, DataSet = tidyData$dataset), mean), Subject)
#+ glimpse of Mean Tidy Data
#...
meanTidyData[1:3, 1:5]
#...
