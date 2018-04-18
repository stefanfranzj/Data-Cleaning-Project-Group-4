#BY TADZIO
getwd()
setwd("~/Desktop")
library(dplyr)

##BY NOAH
##Brought the datasets into R from the GitHub repository using the read.table command
##Created new variables for each one to make manipulation easier
y_train1 <- read.table("https://raw.githubusercontent.com/slevkoff/ECON386REPO/master/Data%20Cleaning%20Project/Task%201/y_train.txt")
x_train1 <- read.table("https://raw.githubusercontent.com/slevkoff/ECON386REPO/master/Data%20Cleaning%20Project/Task%201/X_train.txt")
subject_train <- read.table("https://raw.githubusercontent.com/slevkoff/ECON386REPO/master/Data%20Cleaning%20Project/Task%201/train/subject_train.txt")
y_test1 <- read.table("https://raw.githubusercontent.com/slevkoff/ECON386REPO/master/Data%20Cleaning%20Project/Task%201/y_test.txt")
x_test1 <- read.table("https://raw.githubusercontent.com/slevkoff/ECON386REPO/master/Data%20Cleaning%20Project/Task%201/X_test.txt")
subject_test <- read.table("https://raw.githubusercontent.com/slevkoff/ECON386REPO/master/Data%20Cleaning%20Project/Task%201/test/subject_test.txt")
features <- read.table("https://raw.githubusercontent.com/slevkoff/ECON386REPO/master/Data%20Cleaning%20Project/Task%201/features.txt")
activity_labels <- read.table("https://raw.githubusercontent.com/slevkoff/ECON386REPO/master/Data%20Cleaning%20Project/Task%201/activity_labels.txt")

##BY NOAH
##After importing the relevant tables, we have to assign new names to each data column to make them easier to work with later on
colnames(x_train1) <- features [,2]
colnames(x_test1) <- features [,2]
colnames(y_train1) <- "ActivityID"
colnames(y_test1) <- "ActivityID"
colnames(subject_train) <- "Subject"
colnames(subject_test) <- "Subject"
colnames(activity_labels) <- c("ActivityID", "Activity")

##BY TADZIO 
##Used the cbind command to merge the datasets into their respective training and testing variables
##By doing so I reduced the # of datasets from 4 to 2
training_data <- cbind(subject_train,y_train1,x_train1)
testing_data <- cbind(subject_test,y_test1,x_test1)
##To fully merge the two into one, I used the rbind command to combine the rows into one merged dataset
merged_data <- rbind(training_data, testing_data)

##BY NOAH
##In order to extract just the mean and standard deviation, we need to filter the column names in merged_data for those containing either "mean" or "std"
##The grepl function will filter through colNames returning a vector of logical TRUE and FALSE values that can then be used to extract the actual columns in merged_data
##Note that these extracted columns also need to include subject and activity ID's
colNames <- colnames(merged_data)
mean_std_filter <- (grepl("Subject", colNames) |
                        grepl("ActivityID", colNames) |
                        grepl("mean..", colNames) |
                        grepl("std..", colNames))
mean_std <- merged_data[ ,mean_std_filter==TRUE]
##We can then combine mean_std with activity_labels based on each activity's ID to form a complete data set of activities and measurements
activity_mean_std <- merge(mean_std, activity_labels, by="ActivityID")
##After that, we need to assign an Activity name to each Activity ID in activity_mean_std
activity_mean_std$Activity <- if_else(activity_mean_std$ActivityID == 1,"WALKING",(
  if_else(activity_mean_std$ActivityID == 2,"WALKING_UPSTAIRS",(
    if_else(activity_mean_std$ActivityID == 3, "WALKING_DOWNSTAIRS",(
      if_else(activity_mean_std$ActivityID == 4, "SITTING",(
        if_else(activity_mean_std$ActivityID == 5, "STANDING",(
          if_else(activity_mean_std$ActivityID == 6, "LAYING","NA")))))))))))
##Reordering the columns in activity_mean_std allows for easier reading of the table
activity_mean_std <- activity_mean_std[ ,c(2,82,3:81)]

##BY NOAH
##We then want to get average readings for each acceleromotor statistic for each subject and activity
##We can do this by forming a second tidy data set through the aggregate.data.frame function
tidy_data2 <- aggregate.data.frame(activity_mean_std, by=list(activity_mean_std$Subject, activity_mean_std$Activity), FUN=mean)
##We can then reorganize tidy_data2 for easier readability
tidy_data2 <- tidy_data2[,c(1,2,6:84)]
tidy_data2 <- tidy_data2[order(tidy_data2$Group.1,tidy_data2$Group.2),]
tidy_data2$Activity <- NULL
colnames(tidy_data2) [1] <- "Subject"
colnames(tidy_data2) [2] <- "Activity"

write.table(tidy_data2, "tidy1.txt")

