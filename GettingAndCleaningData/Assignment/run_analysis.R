######################################################
## run_analysis.R
##
## Description:
##  Solution script for Coursera Data Science course "Getting and Cleaning Data"
##  course assignment.
##  Note: to run this script properly you will need to "source" it (either call it from 
##      the r command line or press the "Source" button in R-Studio).
##
## Purpose:
##  To prepare a raw dataset for further analysis according to the following instructions:
##
## You should create one R script called run_analysis.R that does the following. 
##  1. Merges the training and the test sets to create one data set.
##  2. Extracts only the measurements on the mean and standard deviation for each measurement. 
##  3. Uses descriptive activity names to name the activities in the data set
##  4. Appropriately labels the data set with descriptive variable names. 
##  5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
##################################################################################


## Before we start anything let's make sure we correctly set the working directory
scriptDir <- dirname(sys.frame(1)$ofile) 
setwd(scriptDir)

## 
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## chop up the URL to get the file name to save to
LRUelif <- sapply(lapply(strsplit(fileURL, NULL), rev), paste, collapse = "")
fileName<-unlist(strsplit(LRUelif,"/"))[[1]]
fileName <- sapply(lapply(strsplit(fileName, NULL), rev), paste, collapse = "")

## Check the current directory to see if we have the data file,
## if we don't then we'll need to get it from the provided file URL
if (!file.exists(fileName)){
    download.file(fileURL, destfile = fileName)
    downloadDate<- date()
}

## Unzip the file
unz(fileName, "\\UCI HAR Dataset\\train\\X_train.txt")
unz(fileName, "\\UCI HAR Dataset\\train\\Y_train.txt")
unz(fileName, "\\UCI HAR Dataset\\test\\X_test.txt")
unz(fileName, "\\UCI HAR Dataset\\test\\Y_test.txt")


#############################################################################
##  Step 1 - Merge the training and the test sets to create one data set.  ##
#############################################################################
## Load and merge the training and test data sets
xData <- rbind(read.table(".\\UCI HAR Dataset\\train\\X_train.txt"),read.table(".\\UCI HAR Dataset\\test\\X_test.txt"))
yData <- rbind(read.table(".\\UCI HAR Dataset\\train\\Y_train.txt"),read.table(".\\UCI HAR Dataset\\test\\Y_test.txt"))


#######################################################################################################
##  Step 2 - Extract only the measurements on the mean and standard deviation for each measurement.  ##
##                                                                                                   ##
##  Note that this only refers to the xData set as this is the features data set                     ##
#######################################################################################################
## the features.text file gives the list of feature names
features <- read.table(".\\UCI HAR Dataset\\features.txt")

## create a vector that describes the columns we want (the mean() and std() definitions)
colsRqd <- grepl("mean()|std()",features[[2]])

## Now pull the columns out of the xData data set to create a new dataset
xDataMeansStd <- xData[,colsRqd]


########################################################################################
##  Step 3 - Use descriptive activity names to name the activities in the data set.   ##
##                                                                                    ##
##  Note that I will create a separate vector of activity names so as not to corrupt  ##
##  the original yData set                                                            ##
########################################################################################
## load in the activity name definitions
activityLabels <- read.table(".\\UCI HAR Dataset\\activity_labels.txt")

## create a new data set which is the same as yData except with the activity numbers replaced by 
## activity labels

## remove the new line characters
yDataActivityNames <- transform(yData, V1 = gsub("\n","",V1))

## rip through the activityLabels list and do the replacements one by one
for(i in 1:dim(activityLabels)[1])
{
   yDataActivityNames <- transform(yDataActivityNames, V1=gsub(activityLabels[i,1],activityLabels[i,2],V1))
}


########################################################################################
##  Step 4 - Appropriately label the data set with descriptive variable names.        ##
##                                                                                    ##
########################################################################################

## rename the activity names data column
colnames(yDataActivityNames) <- "activity"
## rename the feature data columns
colnames(xDataMeansStd) <- features[colsRqd,2]


## Now put the activities together with the features to create one clean data set
cleanData <- cbind(yDataActivityNames,xDataMeansStd)

## write the resulting data set out to a csv file
write.table(file="cleanData.txt", x=cleanData, row.names=FALSE)

## This is how you to read the data back in to ensure you get the column names:
##  testData <-read.table(".\\cleanData.txt", header=TRUE)


########################################################################################
##  Step 5 - Create a second, independent tidy data set with                         ##
##           the average of each variable for each activity and each subject.                                                                          ##
########################################################################################

## We need to know which rows of our cleanData relate to which subjects
## create a subject data frame
subjects <- rbind(read.table(".\\UCI HAR Dataset\\train\\subject_train.txt"),read.table(".\\UCI HAR Dataset\\test\\subject_test.txt"))
## might be nice to know the all the subject ID's
subjectIDs <- unique(subjects)
subjectIDs <- subjectIDs[order(subjectIDs),]


## Create an empty data frame with appropriate column names
tidyData <- data.frame(subject= integer(1), activity= character(1))
tidyData[,as.character(features[colsRqd,2])] <- numeric(1)
tidyData <- tidyData[-1,]
##str(tidyData)


## step through to collect the data for each subject at a time

for(subject in subjectIDs)
{
    ## Generate the vector of rows that equate to the given subject
    rowsRqd <- subjects == subject
    tempData <- cleanData[rowsRqd,]
    
    ## OK, for each activity for this subject, calculate the average of each variable
    for(activity in activityLabels[,2])
    {
        rowsRqd <- tempData$activity == activity
        calcData <- tempData[rowsRqd,2:length(tempData)]
        
        ## add the result to the new data set
        ## subjectID, activity, meanValues
        tidyData <- rbind(tidyData,data.frame(t(c(subject,activity,colMeans(calcData, na.rm = TRUE)))))
    }
}


## Great! now write out the resulting file
write.table(file="tidyData.txt", x=tidyData, row.names=FALSE)
