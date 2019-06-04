
#files downloaded onto computer
library(plyr)
library(dplyr)

#reading in the feature vector
features<- read.table("features.txt",col.names = c("value","feature_label"))
features # to check what data looks like

#reading in activity labels
activity_labels <- read.table("activity_labels.txt",col.names = c("label", "activity"))
activity_labels

#reading in training data and combining them to one dataset and Uses descriptive activity names to name 
#the activities in the data set
train_x<- read.table("train/X_train.txt", col.names = features$feature_label)
head(train_x) 
train_y <- read.table("train/y_train.txt",col.names = "label")
y_train<-join(train_y, activity_labels, by = "label")
subject_train<- read.table("train/subject_train.txt",col.names = "subject_id")
head(subject_train)

train<- data.frame(train_x,y_train,subject_train)
train<- select(train, -label)
head(train)

#reading in testing data and combining them to one dataset and Uses descriptive activity names to name 
#the activities in the data set
test_x <-read.table("test/X_test.txt", col.names = features$feature_label)
test_y <-read.table("test/y_test.txt", col.names = "label")
y_test_label <- join(test_y, activity_labels, by = "label")
subject_test<- read.table("test/subject_test.txt", col.names = "subject_id")

test<- data.frame(test_x,y_test_label,subject_test)
test <- select(test, -label)

#merging datasets 
combine_data<- rbind(train, test)
head(combine_data)

#Extracts only the measurements on the mean and standard deviation for each measurement.
combine_data2<- combine_data %>% select(matches("mean"), matches("std"))
head(combine_data2)

#From the data set in step 4, creates a second, independent tidy data set with the 
#average of each variable for each activity and each subject.
combine_data2<-cbind(combine_data2,combine_data$subject_id,combine_data$activity)
head(combine_data2)

new_data<- combine_data2 %>% group_by(combine_data$activity,combine_data$subject_id)%>% summarise_each(mean)
new_data

write.table(new_data, file = "tidy_data.txt", row.name= FALSE)



