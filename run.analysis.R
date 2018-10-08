##Set directory
setwd("C:/Coursera/Getting and Cleaning data week 4/UCI HAR Dataset")
library(dplyr)
library(data.table)
##Reading activity table
ActivityTest = read.table("./test/y_test.txt", header=FALSE)
ActivityTrain = read.table("./train/y_train.txt", header=FALSE)
##Reading Subject table
SubjectTest = read.table("./test/subject_test.txt" , header= FALSE)
SubjectTrain = read.table("./train/subject_train.txt", header=FALSE)

##Reading features table
FeaturesTest = read.table("./test/X_test.txt", header=FALSE)
FeaturesTrain = read.table("./train/X_train.txt", header=FALSE)

#Merging data
Subjectdata <- rbind(SubjectTest, SubjectTrain)
Activitydata <- rbind(ActivityTest, ActivityTrain)
Featuresdata <- rbind(FeaturesTest, FeaturesTrain)
## Set variables name
names(Subjectdata) <- c("subject")
names(Activitydata) <- c("activity")
FeaturesName <- read.table("./features.txt", header=FALSE)
names(Featuresdata) <- FeaturesName$V2
##Merge columns for all data
datacombine <- cbind(Subjectdata,Activitydata)
cleandata <- cbind(Featuresdata, datacombine)
##Extracts only the measurements on the mean and standard deviation for each measurement 
subdataFeaturesNames<-FeaturesName$V2[grep("mean\\(\\)|std\\(\\)", FeaturesName$V2)]
Selected <- c(as.character(subdataFeaturesNames),"subject","activity")
data <- subset(cleandata,select = Selected)
##Reading activity labels
ActivityLabels = read.table("./activity_labels.txt", header= FALSE)

##Replacing descriptive names
names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))
##Create independent tidy data set with the average of each activity and subject
Data2 <- aggregate(.~subject + activity, data,mean)
Data2 <- Data2[order(Data2$subject,Data2$activity),]
write.table(Data2,file= "tidydata.txt", row.name=FALSE)


