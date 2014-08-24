CodeBook
========

###Introduction
The file CodeBook.md contains information about:

+ variables from data files X\_extracted.txt, features\_mean.txt and names\_mean.txt
+ procedures inside run_analysis.R

To start, the data project is getting datafiles by download from:

[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

After downloading, unzip the file. Go to directory "./UCI HAR Dataset". Move the script run_analysis.R into the folder.

Run at least R 3.1.1 / RStudio 0.98.994 on OSX 10.9.4 and set the folder as the work directory.

###Running run_analysis.R

1. #####Setup 
Because of the size of numbers from X data, global option for digits is setting to 8 instead 7.

2. #####Load data files
All next data needed by this script are loaded (see README.txt for more details):
 	
	* "./train/X\_train.txt"
	* "./test/X\_test.txt"
	* "./train/y\_train.txt"
	* "./test/y\_test.txt"
	* "./features.txt"
	* "./activity\_labels.txt"
    * "./train/subject\_train.txt"
    * "./test/subject\_test.txt"

3. #####Merge Train and Test
There are 7532 rows train and 2947 rows test. Merge the train and test parts to create one data with 10299 rows.
The following merged data are:

	+ X
	+ y 
	+ subject

4. #####Extract mean or standard deviation measurements
Filter the list out all features which are not produce a mean or a standard deviation as a measurement. All indexes of features with "mean" or "std" and both with "()" are extracted into vector findex (79 indexes). It is done by choose indexes with grepl() and mapply() to features from features.txt. 
With help of findex, the extraction is applied to features and X. The results are:

	- features\_extract
	- X\_extract
	
5. #####Name activites and features
The column vector action is formed from y by changing number to name with help of activity_labels.txt. The column action is adding to X\_extract. The colnames of X\_extract are named with features\_extract (See 4\.). 

6. #####Write to file X\_extracted.txt
With write.table() the file X\_extracted.txt is created in the work directory. The file shows 80 cols. The first column is action, it contains descriptive activity names as shown by activity\_labels (see README.txt). The remaining 79 columns are features which have got mean and standard deviation measurements: 

		- tBodyAcc-mean()-X
		- tBodyAcc-mean()-Y
		- tBodyAcc-mean()-Z
		- tBodyAcc-std()-X
		- tBodyAcc-std()-Y
		- tBodyAcc-std()-Z
		- tGravityAcc-mean()-X
		- tGravityAcc-mean()-Y
		- tGravityAcc-mean()-Z
		- tGravityAcc-std()-X
		- tGravityAcc-std()-Y
		- tGravityAcc-std()-Z
		- tBodyAccJerk-mean()-X
		- tBodyAccJerk-mean()-Y
		- tBodyAccJerk-mean()-Z
		- tBodyAccJerk-std()-X
		- tBodyAccJerk-std()-Y
		- tBodyAccJerk-std()-Z
		- tBodyGyro-mean()-X
		- tBodyGyro-mean()-Y
		- tBodyGyro-mean()-Z
		- tBodyGyro-std()-X
		- tBodyGyro-std()-Y
		- tBodyGyro-std()-Z
		- tBodyGyroJerk-mean()-X
		- tBodyGyroJerk-mean()-Y
		- tBodyGyroJerk-mean()-Z
		- tBodyGyroJerk-std()-X
		- tBodyGyroJerk-std()-Y
		- tBodyGyroJerk-std()-Z
		- tBodyAccMag-mean()
		- tBodyAccMag-std()
		- tGravityAccMag-mean()
		- tGravityAccMag-std()
		- tBodyAccJerkMag-mean()
		- tBodyAccJerkMag-std()
		- tBodyGyroMag-mean()
		- tBodyGyroMag-std()
		- tBodyGyroJerkMag-mean()
		- tBodyGyroJerkMag-std()
		- fBodyAcc-mean()-X
		- fBodyAcc-mean()-Y
		- fBodyAcc-mean()-Z
		- fBodyAcc-std()-X
		- fBodyAcc-std()-Y
		- fBodyAcc-std()-Z
		- fBodyAcc-meanFreq()-X
		- fBodyAcc-meanFreq()-Y
		- fBodyAcc-meanFreq()-Z
		- fBodyAccJerk-mean()-X
		- fBodyAccJerk-mean()-Y
		- fBodyAccJerk-mean()-Z
		- fBodyAccJerk-std()-X
		- fBodyAccJerk-std()-Y
		- fBodyAccJerk-std()-Z
		- fBodyAccJerk-meanFreq()-X
		- fBodyAccJerk-meanFreq()-Y
		- fBodyAccJerk-meanFreq()-Z
		- fBodyGyro-mean()-X
		- fBodyGyro-mean()-Y
		- fBodyGyro-mean()-Z
		- fBodyGyro-std()-X
		- fBodyGyro-std()-Y
		- fBodyGyro-std()-Z
		- fBodyGyro-meanFreq()-X
		- fBodyGyro-meanFreq()-Y
		- fBodyGyro-meanFreq()-Z
		- fBodyAccMag-mean()
		- fBodyAccMag-std()
		- fBodyAccMag-meanFreq()
		- fBodyBodyAccJerkMag-mean()
		- fBodyBodyAccJerkMag-std()
		- fBodyBodyAccJerkMag-meanFreq()
		- fBodyBodyGyroMag-mean()
		- fBodyBodyGyroMag-std()
		- fBodyBodyGyroMag-meanFreq()
		- fBodyBodyGyroJerkMag-mean()
		- fBodyBodyGyroJerkMag-std()
		- fBodyBodyGyroJerkMag-meanFreq()

	The details of those features are given in file features\_info.txt. 

	The different actions are done by 30 different subjects. The total actions are 10299(=nrow).

7. #####Getting an average of each feature variable for each subject and each activity
Create array M by adding cols action\_id and subjects to X\_extract. The new cols are named by resp action_id and subject. The next steps are

		* reorder M by subject and action\_id.
		* split reordering M by subject. The result is the list of 30 elements. Each element contains array M with one subject. 
		* with sapply(), a function is applied to each element of the list. The function here is by(). (The three cols subject, action_id and action are ignored). The by() groups remaining array by action. 
		* FUN=colMeans from by() takes average of each cols (features) from grouped array for each action.
		* The result is transformed by apply each array element (= set cols with means of each feature) with function do.call(cbind,element) to new array 'output'.
		
	The form of array 'output' is described as output["average","action","subject"] 

8. #####Name averages variables (features)
The list of averages is based on the list above, then the names are created with paste 'M-' at begin of corresponded feature name from features\_extract (See 4\.). 
For example: the average of tBodyAcc-mean()-X by a subject and an action is noted as _"M-tBodyAcc-mean()-X"_
The information about units of the averages are given in features_info.txt by units of corresponding features. Unit of a mean of set values of a variable is same as unit of the variable.

	>Remark: the names for means are rownames of second data. They are not allowed to be written to second file for Course Project. The names of average of each variables are written to file names_mean.txt. 

9. ##### Write to file features\_mean.txt
The file features\_mean.txt is created by write.table with array output and row.names=FALSE

	The form of a colname is composed as "action.subject". The rownames are described in section 8\. above. The file has got 180 cols and 79 rows. 





