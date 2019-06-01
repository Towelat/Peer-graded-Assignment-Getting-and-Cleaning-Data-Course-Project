#files downloaded onto computer

#1. Merges the training and the test sets to create one data set.

#reading in training data and combining them to one dataset
train_x<- read.table("train/X_train.txt")
head(train_x) # just to check what the data looks like
train_y <- read.table("train/y_train.txt")
head(train_y)
subject_train<- read.table("train/subject_train.txt")
head(subject_train)

train<- data.frame(train_x,train_y,subject_train)

#reading in testing data and combining them to one dataset
test_x <-read.table("test/X_test.txt")
test_y <-read.table("test/y_test.txt")
subject_test<- read.table("test/subject_test.txt")

test<- data.frame(test_x,test_y,subject_test)

#reading in the feature vector
features<- read.table("features.txt")
features # to check what data looks like

#reading in activity labels
activity_labels <- read.table("activity_labels.txt")
activity_labels

#assigning colnames to data 
colnames(train)<-c(features[,2], "activity_type", "subject_id")
colnames(test)<-c(features[,2], "activity_type", "subject_id")

#merging datasets 
combine_data<- rbind(train, test)

#Extracts only the measurements on the mean and standard deviation for each measurement.

wanted<- grep(".*mean.*|.*std.*", features[,2])
wanted<-features[wanted,2]
colnames(combine_data)<-c(wanted, "activity_type", "subject_id")

#Uses descriptive activity names to name the activities in the data set
combine_data<- gsub(grepl("[1-6]",combine_data$activity_type), activity_labels$V2[1-6],
                    combine_data$activity_type)

#From the data set in step 4, creates a second, independent tidy data set with the 
#average of each variable for each activity and each subject.

new_data<- combine_data %>% group_by(activity_type, subject_id) %>% summarise(averages = mean())
