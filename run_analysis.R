
# Loading FEATURES to tables (features_Test_Data, features_Train_Data)

features_Test_Data <- read.table("C:\\Users\\jari\\Data_Science\\working_Dir\\data\\UCI HAR Dataset\\test\\X_test.txt",header = FALSE)
features_Train_Data <- read.table("C:\\Users\\jari\\Data_Science\\working_Dir\\data\\UCI HAR Dataset\\train\\X_train.txt",header = FALSE)

# Loading ACTIVITIES to tables (activity_Test_Data, activity_Train_Data)

activity_Test_Data <- read.table("C:\\Users\\jari\\Data_Science\\working_Dir\\data\\UCI HAR Dataset\\test\\Y_test.txt",header = FALSE)
activity_Train_Data <- read.table("C:\\Users\\jari\\Data_Science\\working_Dir\\data\\UCI HAR Dataset\\Train\\Y_train.txt",header = FALSE)

# Loading SUBJECTS to tables (subject_Train_Data, subject_Test_Data)

subject_Train_Data <- read.table("C:\\Users\\jari\\Data_Science\\working_Dir\\data\\UCI HAR Dataset\\Train\\subject_train.txt",header = FALSE)
subject_Test_Data <- read.table("C:\\Users\\jari\\Data_Science\\working_Dir\\data\\UCI HAR Dataset\\Test\\subject_test.txt",header = FALSE)

# ---------------------------------------------------------------------
# Merge existing sets to one data set - Concatenate the data tables BY ROWS

features_Data <- rbind(features_Test_Data, features_Train_Data)
activity_Data <- rbind(activity_Test_Data, activity_Train_Data)
subject_Data <- rbind(subject_Train_Data, subject_Test_Data)

# Name the variables of table

names_features_Data <- read.table("C:\\Users\\jari\\Data_Science\\working_Dir\\data\\UCI HAR Dataset\\features.txt",head=FALSE)
names(features_Data) <- names_features_Data$V2
names(activity_Data) <- c("Activity")
names(subject_Data) <- c("Subject")

#---------------------------------------------------------------------
# Merge COLUMNS ( = data frame ready)

combined_Data <- cbind(activity_Data, subject_Data)
My_Data <- cbind(features_Data, combined_Data)

subdata_names_features_Data <- names_features_Data$V2[grep("mean\\(\\)|std\\(\\)", names_features_Data$V2)]
selected_Names <- c(as.character(subdata_names_features_Data), "Subject", "Activity" )
My_Final_Data<-subset(My_Data,select=selected_Names)

# Read descriptive activity names from “activity_labels.txt”

Labels <- read.table("C:\\Users\\jari\\Data_Science\\working_Dir\\data\\UCI HAR Dataset\\activity_labels.txt",header = FALSE)

# SIMPLIFYING COLUMN NAMES

names(My_Final_Data) <- gsub("^t", "Time", names(My_Final_Data))
names(My_Final_Data) <- gsub("^f", "Frequency", names(My_Final_Data))
names(My_Final_Data) <- gsub("Acc", "Accelerometer", names(My_Final_Data))
names(My_Final_Data) <- gsub("Gyro", "GyroScope", names(My_Final_Data))
names(My_Final_Data) <- gsub("Mag", "Magnitude", names(My_Final_Data))
names(My_Final_Data) <- gsub("BodyBody", "Body", names(My_Final_Data))

#---------------------------------------------------------------------
#
# CREATING Tidy Data (Stored to working directory)

library(plyr);

Tidy_Data <- aggregate(. ~Subject + Activity, My_Final_Data, mean)
Tidy_Data <- Tidy_Data[order(Tidy_Data$Subject,Tidy_Data$Activity),]
write.table(Tidy_Data, file = "tidydata.txt",row.name=FALSE)
