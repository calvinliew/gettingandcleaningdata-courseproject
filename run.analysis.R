##Set directory
setwd("C:/Coursera/Getting and Cleaning data week 4/UCI HAR Dataset")
library(dplyr)
library(data.table)

features <- read.table("./features.txt", col.names = c("n","functions"))
activities <- read.table("./activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("./test/subject_test.txt", col.names = "subject")
subject_train <- read.table("./train/subject_train.txt", col.names = "subject")
x_test <- read.table("./test/X_test.txt", col.names = features$functions)
y_test <- read.table("./test/y_test.txt", col.names = "code")
x_train <- read.table("./train/X_train.txt", col.names = features$functions)
y_train <- read.table("./train/y_train.txt", col.names = "code")

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged <- cbind(X,Y,Subject)

TidyData <- Merged %>% select(subject , code,contains("mean"), contains("std"))
TidyData$code <- activities[TidyData$code,2]

names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))

CleanData <- TidyData %>% group_by(subject,activity) %>% summarise_all(funs(mean))
write.table(CleanData, "cleandata.txt", row.names = FALSE)
