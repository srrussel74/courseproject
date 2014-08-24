Human Activity Recognition Using Smartphones Dataset Ver 1.0.1
==============================================================

>Stefan Russel,
>Nieuw Vennep, the Netherlands,
>s******@xs4all.nl

Introduction
------------
The Course project is part of Coursera course "Getting and Cleaning Data". README.md belongs to the data project with datafiles downloading from the link:

[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

README.md here describes script run_analysis.R and its outcomes. It works with datafiles from the link. The goal of this script is to create:

+ A first data is formed by train and test part and subsetting by features with mean and std outcomes. Its data are labeled by names.

+ A second data gives mean value of each features (from first data) group by each subject with each activity.

+ A third data contains new names for means of a set features

More details about features, activity, subjects and data files are described in README.txt. Only those which are changed or added are described in CodeBook.md

With the script run_analysis.R the three outcomes are generated which first two of above are requested by Course Project. 


About run_analysis.R
--------------------

The script has got the steps. For first data requested in the Course project, it:

	* loads set data,
	* merges test and train data,
	* creates new data by extracting mean and standard deviation measurements,
	* create col action by label activity with names,
	* attach col action to new data,
	* describes the variables,
	* writes the file X_extracted.txt. 

The second tidy data needs further steps from the script:

	* the cols action and subjects are attached to data X_extract
	* describing last attached cols
	* reorder data by subject and action_id
	* produce mean values of each feature for each subject and each action.
	* names variables 
	* Write result to the file features_mean.txt. 
	
Remark: the names for means are rownames of second data. They are not allowed to be written to second file for Course Project. The names are written separately to file names_mean.txt. The names for mean value are given by adding 'M-' at begin of corresponded feature name.	

See CodeBook.md for more details of the steps and variables.

The outcomes of run_analysis.R are the files:

	* X_extracted.txt: Named features with mean and standard deviation as measurements
	* features_mean.txt: average of each feature variable for each activity and each subject 
	* names_mean.txt: name of each mean value corresponding to a feature

