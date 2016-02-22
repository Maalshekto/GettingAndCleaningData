## 
## run_analysis.R
##
## This Script execute the following operations :
## 0. Loading data from different files.
## 1. Merge training data & test data for different data elements.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. Creates a second, independent tidy data set from 4 with the average 
##    of each variable for each activity and each subject. Save the result in averageDataSet.txt
## 
## Author   - Thomas MARTIN
## Date     - 11/02/2016
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
## 0.Data Loading
##

## Names of columns's Data and labels for activities.
originDataColomnsNames <- read.table("features.txt", stringsAsFactors = FALSE)
activitiesLabels <- read.table("activity_labels.txt", stringsAsFactors = FALSE)

## Data in original format split in two data.frames.
originDataTrain <- read.table("train/X_train.txt", stringsAsFactors = FALSE)
originDataTest <- read.table("test/X_test.txt", stringsAsFactors = FALSE)

## Activities linked to Data in original format. Split in two data.frames too.
activitiesTrain <- read.table("train/y_train.txt", stringsAsFactors = FALSE)
activitiesTest <- read.table("test/y_test.txt", stringsAsFactors = FALSE)

## Subjects linked to Data in original format. Split in two data.frames too. 
subjectTest <- read.table("test/subject_test.txt", stringsAsFactors = FALSE)
subjectTrain <- read.table("train/subject_train.txt", stringsAsFactors = FALSE)


##
##  1.Merges the training and the test sets to create one data set.
##

originDataTotal <- rbind(originDataTrain, originDataTest)
colnames(originDataTotal) <- originDataColomnsNames$V2
activitiesTotal <- rbind(activitiesTrain, activitiesTest)
subjectTotal <- rbind(subjectTrain, subjectTest)

## remove not used anymore variables.
rm(originDataTrain, originDataTest) 
rm(subjectTest, subjectTrain) 
rm(activitiesTrain, activitiesTest) 
rm(originDataColomnsNames)

##
##  2.Extracts only the measurements on the mean and standard deviation for each measurement.
##

extractDataTotal <- originDataTotal[ ,grepl('mean\\(\\)|std\\(\\)', colnames(originDataTotal))]

## remove not used anymore variables.
rm(originDataTotal) 


##
##  3.Uses descriptive activity names to name the activities in the data set
##

labelledActivitiesTotal <- activitiesLabels$V2[activitiesTotal$V1]

## remove not used anymore variables.
rm(activitiesTotal, activitiesLabels) 


##
##  4.Appropriately labels the data set with descriptive variable names.
## 

extractDataTotal <- cbind(extractDataTotal, "subject" = subjectTotal$V1)
finalDataSet <- cbind(extractDataTotal, "activity" = labelledActivitiesTotal)

## remove not used anymore variables.
rm(extractDataTotal, labelledActivitiesTotal, subjectTotal)



##
##  5.From the data set in step 4, creates a second, independent tidy data set with the average 
##    of each variable for each activity and each subject. Save the result in averageDataSet.txt
##
averageDataSet <- finalDataSet %>%
  group_by(activity, subject) %>%
  summarise_each(funs(mean))

write.table(averageDataSet, "averageDataSet.txt", row.names = FALSE)
