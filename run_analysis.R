# Loading The library for use
library(dplyr)

# Assigning all data frame

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
activity <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/Y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/Y_train.txt", col.names = "code")

# Merging the trainig and test dataset to create
# a single dataset
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
Merged_data <- cbind(subject, x, y)

# Extracting only the measurements that contain mean and 
# standard deviation for each measurement

TidyData <- Merged_data %>% select(subject, code, contains("mean"), contains("std"))

# Assigning Descriptive Activity names to name the 
# activities in the dataset 

TidyData$code <- activity[TidyData$code, 2]

# Appropriately labelling the dataset with descriptive variable names

names(TidyData)[2] = "activity"
names(TidyData) <- gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData) <- gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData) <- gsub("BodyBody", "Body", names(TidyData))
names(TidyData) <- gsub("Mag", "Magnitude", names(TidyData))
names(TidyData) <- gsub("^t", "Time", names(TidyData))
names(TidyData) <- gsub("^f", "Frequency", names(TidyData))
names(TidyData) <- gsub("tBody", "TimeBody", names(TidyData))
names(TidyData) <- gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData) <- gsub("-std", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData) <- gsub("-freq", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData) <- gsub("angle", "Angle", names(TidyData))
names(TidyData) <- gsub("gravity", "Gravity", names(TidyData))

# Creating a final Dataset
FinalData <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name = FALSE)

# Final Data
str(FinalData)
