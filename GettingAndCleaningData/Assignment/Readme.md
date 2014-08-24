## Getting and Cleaning Data - Course Project

### Directory contents

This directory contains the main files required for the assignment as follows:

*Readme.md*				- This file.  Used to describe the files submitted for this project.
*run_analysis.R*	- The analysis file used to get, load, and transform the given data set into a tidy data set.
*CodeBook.md*			- The code book used to describe the transformed data set.


### Usage

To run the *run_analysis.R* script follow the instructions below:
+ Download the *run_analysis.R* script to a directory of your choice,
+ Use R-Studio to open the script file,
+ Use the *source* button or *Ctrl+Shift+S* to run the script

The script performs the following tasks:
+ Automatically detect the directory it is in,
+ Downloads the correct zip file and saves it to the directory where the source file is located,
+ Unzips the data files to the directories specified in the zip file,
+ Loads the training and test data sets for the X and Y variables and merges them into two data frames (X and Y),
+ Identifies the columns in the X data set that correspond to the mean and standard deviation measurements,
+ Creates a data frame with just the mean and standard deviation measurements,
+ Adds descriptive activity names to each row in the new data set by adding a column at the front,
+ Writes the resulting clean data set to a text file *cleanData.txt* with headers included (note: read this back in to R using read.table with header=TRUE),
+ Loads the subject identifiers from the *subject_train.txt* and *subject_test.txt* files,
+ Uses nested for loops to pull out and sumarise the clean data to form the tidy data set,
+ Writes the tidy data set to a text file *tidyData.txt* with headers included (note: read this back in to R using read.table with header=TRUE).

### Apologies
To complete the last part of the questions, I used nested for loops as opposed to using R's data manipulation functions.  This method is slower but it is easier to follow.  The decision to use this approach was justified by the small data set that is able to be processed in reasonable time.
