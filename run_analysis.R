#download and unzip the data
if(!file.exists("data")){
  dir.create("data")
}

data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists("./data/UCI_HAR_dataset.zip")){
  download.file(data_url, destfile="./data/UCI_HAR_dataset.zip", method="auto")
}

if(!file.exists("./data/UCI HAR Dataset")){
  unzip("./data/UCI_HAR_dataset.zip", exdir="./data")
}


#step 1: merge training and test data into one set
features <- read.table("./data/UCI HAR Dataset/features.txt")

train_data <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
train_labels <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
train_subject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

test_data <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
test_labels <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
test_subject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")


names(train_data) <- features$V2
names(test_data) <- features$V2

#create new columns populated with subjects and labels
train_data$subject <- train_subject$V1
test_data$subject <- test_subject$V1

train_data$activity <- train_labels$V1
test_data$activity <- test_labels$V1

merged_data <- rbind(train_data, test_data)


#step 2: extract only the measurements on the mean and
#standard deviation

#extract columns with 'mean' or 'std' (when not a parameter)
#add two TRUE values to preserve subject and activity
mean_std_data <- merged_data[,c(grepl("[Mm]ean.*\\(|[Ss]td.*\\(",features$V2),TRUE,TRUE)]


#step 3: use descriptive activity names to name
# the activities in the data set

activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
mean_std_data$activity_labels <- factor(mean_std_data$activity, levels=activities$V1, labels=activities$V2)


#step 4: appropriately label the data set with descriptive variable names
#columns already have appropriate labels based on features.txt

#write out the 1st data set
write.table(mean_std_data, "mean_std_data.txt")

#step 5: create a second, independent tidy data set with the 
#average of each variable for each activity and each subject

library(plyr)
library(reshape2)

#find index up to which to select column names (to exclude activity and subject)
actv_subj_index <- min(match(c("activity_labels","subject"),names(mean_std_data)))-1

molten_data <- melt(mean_std_data, id.vars=c("activity_labels","subject"),
                    measure.vars=names(mean_std_data)[1:actv_subj_index])

avg_actv_subj_data <- ddply(molten_data, .(subject,activity_labels,variable), summarize, mean=mean(value))

write.table(avg_actv_subj_data, "avg_actv_subj_data.txt", row.names=FALSE)
