#setup
#set global option for 8 digits 
options(digits=8)

# load data files from UCI HAR Dataset
X_train<-read.table("./train/X_train.txt");
X_test<-read.table("./test/X_test.txt");
y_train<-read.table("./train/y_train.txt");
y_test<-read.table("./test/y_test.txt");
features<-read.table("./features.txt");
activity_labels<-read.table("./activity_labels.txt");
subject_train<-read.table("./train/subject_train.txt");
subject_test<-read.table("./test/subject_test.txt");

# Merge train- and test-parts of data,(first 7352 rows are 'train' 
# and last 2947 rows are 'test'
X<-rbind(X_train,X_test)
y<-rbind(y_train,y_test)
subjects<-rbind(subject_train,subject_test)

# Create array 'findex' with indeces where features are contained
# with "mean()" or "std()", all strings with mean and ()
fmean<-mapply(function(v1,v2) if(grepl("mean()",v2)) v1, features$V1, features$V2)
fmean<-unlist(fmean)
fstd<-mapply(function(v1,v2) if(grepl("std()",v2)) v1, features$V1, features$V2)
fstd<-unlist(fstd)
findex<-c(fmean,fstd)
findex<-findex[order(findex)]

# extract elements with names include "mean()" and "std()" from features and data with help of findex
features_extract<-features[[2]][findex]
X_extract<-X[findex]

# Create col with id activity
action_id<-y$V1
# Create col with activity names (=actions)
action<-activity_labels$V2[action_id] # col with names actions

# Apply colnames (features) and rownames (actions)
colnames(X_extract)<-features_extract
X_extract<-cbind(action, X_extract)

# Write file down contain extracted data: 'X_extracted.txt'
write.table(X_extract,"./X_extracted.txt", row.names=FALSE)

cat("The file 'X_extracted.txt' is created.\n")

# Create array M from X_extract with adding extra cols subjects id and actions id
M<-cbind(action_id,X_extract) # add col action_id
M<-cbind(subjects,M) # add col subjects
colnames(M)[1]<-"subject" # set colname for col subjects

# M grouping by subject and action
M<-M[order(M$subject,M$action_id),] # reorder by subjects id and action_id
M<-split(M,M$subject) # Grouping by subjects

# Each features dataset per subject is grouping by action 
# Apply function colMeans for all features in one column for each subject with each action
# Unregonize first three cols, which are not part of features datasets: cols(subject,action_id,action)
M<-sapply(M, function(x) by(x[,c(-1,-2,-3)],x$action,FUN=colMeans))

# Write output down to features_mean.txt.
output<-apply(M,1:2, function(x) do.call(cbind,x))

# The names for mean of feature for each subject with each action is combination 
# with names of the features and "M"(ean) at begin.
Mfeatures_extract=paste("M-",features_extract, sep="")
Mfeatures_extract<-sprintf("%33s",Mfeatures_extract)

# create row names
dimnames(output)[[1]]<-c(Mfeatures_extract)

write.table(output,"./features_mean.txt", col.names=TRUE, row.names=FALSE)
write.table(Mfeatures_extract,"./names_mean.txt", row.names=FALSE,col.names=FALSE)

cat("The files 'feature_mean.txt' and 'names_mean.txt' are created.")