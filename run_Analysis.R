if(!file.exists("./Desktop/R")){dir.create("./Desktop/R")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./Desktop/R/getdata%2Fprojectfiles%2FUCI HAR Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./Desktop/R/getdata%2Fprojectfiles%2FUCI HAR Dataset.zip",exdir="./Desktop/R")


# Read trainings tables
xtrain <- read.table("./Desktop/R/UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./Desktop/R/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./Desktop/R/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
x_test <- read.table("./Desktop/R/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./Desktop/R/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./Desktop/R/UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
features <- read.table('./Desktop/R/UCI HAR Dataset/features.txt')

# Reading activity labels:
activityLabels = read.table('./Desktop/R/UCI HAR Dataset/activity_labels.txt')

# Assigning Column names
colnames(xtrain) <- features[,2] 
colnames(ytrain) <-"activityId"
colnames(subject_train) <- "subjectId"
      
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
      
colnames(activityLabels) <- c('activityId','activityType')

# Merging both datasets
mrg_train <- cbind(ytrain, subject_train, xtrain)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)

colNames <- colnames(setAllInOne)

#Calculating mean and std dataset
mean_and_std <- (grepl("activityId" , colNames) | 
                 grepl("subjectId" , colNames) | 
                 grepl("mean.." , colNames) | 
                 grepl("std.." , colNames) 
                 )
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)

# New tidy dataset stored in txt file
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

write.table(secTidySet, "secTidySet.txt", row.name=FALSE)
