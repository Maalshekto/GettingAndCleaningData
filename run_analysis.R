## 
## run_analysis.R
##
## This Script execute the
## 
## Author   - Thomas MARTIN
## Date     - 09/02/2016
## Email    - tmartin@live.fr
## Version  - 1.0
##

##
##  Dependancies Checking
##
require(dplyr)

##
##  Libraries Loading
##
library(dplyr)

## 
## Data Loading
##

featuresLabel <- read.table("features.txt", stringsAsFactors = FALSE)
xTrain <- read.table("train/X_train.txt", stringsAsFactors = FALSE)
xTest <- read.table("test/X_test.txt", stringsAsFactors = FALSE)
yTrain <- read.table("train/y_train.txt", stringsAsFactors = FALSE)
yTest <- read.table("test/y_test.txt", stringsAsFactors = FALSE)
activitiesLabel <- read.table("activity_labels.txt", stringsAsFactors = FALSE)
subjectTrain <- read.table("train/subject_train.txt", stringsAsFactors = FALSE)
subjectTest <- read.table("test/subject_test.txt", stringsAsFactors = FALSE)

##
##  1.Merges the training and the test sets to create one data set.
##

xTotal <- rbind(xTrain, xTest)
rm(xTrain, xTest)

yTotal <- rbind(yTrain, yTest)
rm(yTrain, yTest)

subjectTotal <- rbind(subjectTrain, subjectTest)
rm(subjectTest, subjectTrain)

##
##  2.Extracts only the measurements on the mean and standard deviation for each measurement.
##

usefulColumnsId <- featuresLabel$V1[grepl('mean\\(\\)|std\\(\\)', featuresLabel$V2)]
xTotal <- select(xTotal, usefulColumns)

##
##  3.Uses descriptive activity names to name the activities in the data set
##
activities <- activitiesLabel$V2[yTotal$V1]


##
##  4.Appropriately labels the data set with descriptive variable names.
## 
usefulColumnsName <- featuresLabel$V2[usefulColumnsId]
colnames(xTotal) <- usefulColumnsName
xTotal <- cbind(xTotal, "subject" = subjectTotal$V1)
finalDataSet <- cbind(xTotal, "activity" = activities)
rm(xTotal)

##
##  5.From the data set in step 4, creates a second, independent tidy data set with the average 
##    of each variable for each activity and each subject.
##
averageDataSet <- finalDataSet %>%
  group_by(activity, subject) %>%
  summarise_each(funs(mean))