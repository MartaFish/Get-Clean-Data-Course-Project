#this analysis will need the plyr and dplyr packages and may also need the utils package
#install.packages("plyr", dependencies = TRUE)
#install.packages("dplyr", dependencies = TRUE)
#install.packages("utils", dependencies = TRUE)
library(plyr)
library(dplyr)
library(utils)

#read in X data from both test and training and rbind them into one file, with test being the first rows
x_test <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
x_train <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
x_all <- rbind(x_test, x_train)

#read in the features table and use those values as column names for the merged X data from the last set
features <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt")
colnames(x_all) <- features[, 2]

#read in Y data from both test and training and rbind them into one file, with test being the first rows
#Add the y data as a column with the x data and name the column data from y
y_test <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
y_all  <- rbind(y_test, y_train) 
xy_all <- cbind(x_all, y_all)
colnames(xy_all)[colnames(xy_all) == "V1"] <- "Activity"

#read in subject data from both test and training and rbind them into one file, with test being the first rows
#Add the subject data as a column with the x & Y data and name the subject column data
subject_test <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
subject_all <- rbind(subject_test, subject_train)
xysub_all<- cbind(xy_all, subject_all)
colnames(xysub_all)[colnames(xysub_all) == "V1"] <- "Subject"

#remove duplicate column names, then select the columns we need 
# this will involve a 1st column selection on (Activity, subject, variables listed as mean but not meanfreq, any std)
# and a 2nd column selection to get rid of the means for a single axis, i.e. anything that ends with X, Y, or Z
xysub_nodups <- xysub_all[, !duplicated(colnames(xysub_all))]
xysub_selection <- select(xysub_nodups, 479, 478, contains("mean"), -contains("meanFreq"), contains("std"))
xysub_selection2 <- select(xysub_selection, -ends_with("-X"), -ends_with("-Y"), -ends_with("-Z"))

#rename the numbers in the Activity column with descriptions from the activity labels file
activities <-  read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
xysub_actname <- within(xysub_selection2, Activity <- factor(xysub_selection2$Activity, 
                                                            levels = activities[, 1], labels = activities[, 2]))

#rename columns with more descriptive labels
names(xysub_actname)[names(xysub_actname) == "tBodyAccMag-mean()"] <- "Time_Acceleration_Magnitude_mean" 
names(xysub_actname)[names(xysub_actname) == "tGravityAccMag-mean()"] <- "Time_Gravity_Accleration_Magnitude_mean"
names(xysub_actname)[names(xysub_actname) == "tBodyAccJerkMag-mean()"] <- "Time_Acceleration_JerkSignal_mean" 
names(xysub_actname)[names(xysub_actname) == "tBodyGyroMag-mean()"] <- "Time_Gyroscopic_Magnitude_mean"
names(xysub_actname)[names(xysub_actname) == "tBodyGyroJerkMag-mean()"] <- "Time_Gyroscopic_JerkSignal_mean" 
names(xysub_actname)[names(xysub_actname) == "fBodyAccMag-mean()"] <- "Freq_Acceleration_Magnitude_mean"
names(xysub_actname)[names(xysub_actname) == "fBodyBodyAccJerkMag-mean()"] <- "Freq_Acceleration_JerkSignal_mean"
names(xysub_actname)[names(xysub_actname) == "fBodyBodyGyroMag-mean()"] <- "Freq_Gyroscopic_Magnitude_mean" 
names(xysub_actname)[names(xysub_actname) == "fBodyBodyGyroJerkMag-mean()"] <- "Freq_Gyroscopic_JerkSignal_mean"
names(xysub_actname)[names(xysub_actname) == "angle(tBodyAccMean,gravity)"] <- "Angle_time_Acceleration_gravitymean" 
names(xysub_actname)[names(xysub_actname) == "angle(tBodyAccJerkMean),gravityMean)"] <- "Angle_time_Acceleration_JerkSignal_gravitymean"
names(xysub_actname)[names(xysub_actname) == "angle(tBodyGyroMean,gravityMean)"] <- "Angle_time_Gyroscopic_gravitymean"
names(xysub_actname)[names(xysub_actname) == "angle(tBodyGyroJerkMean,gravityMean)"] <- "Angle_time_Gyroscopic_JerkSignal_gravitymean"
names(xysub_actname)[names(xysub_actname) == "angle(X,gravityMean)"] <- "Angle_X_GravityMean"
names(xysub_actname)[names(xysub_actname) == "angle(Y,gravityMean)"] <- "Angle_Y_gravitymean"
names(xysub_actname)[names(xysub_actname) == "angle(Z,gravityMean)"] <- "Angle_Z_gravitymean" 
names(xysub_actname)[names(xysub_actname) == "tBodyAccMag-std()"] <- "Time_Acceleration_Magnitude_StdDev"
names(xysub_actname)[names(xysub_actname) == "tGravityAccMag-std()"] <- "Time_Gravity_Accleration_Magnitude_StdDev" 
names(xysub_actname)[names(xysub_actname) == "tBodyAccJerkMag-std()"] <- "Time_Acceleration_JerkSignal_StdDev" 
names(xysub_actname)[names(xysub_actname) == "tBodyGyroMag-std()"] <- "Time_Gyroscopic_Magnitude_StdDev"
names(xysub_actname)[names(xysub_actname) == "tBodyGyroJerkMag-std()"] <- "Time_Gyroscopic_JerkSignal_StdDev" 
names(xysub_actname)[names(xysub_actname) == "fBodyAccMag-std()"] <- "Freq_Acceleration_Magnitude_StdDev" 
names(xysub_actname)[names(xysub_actname) == "fBodyBodyAccJerkMag-std()"] <- "Freq_Acceleration_JerkSignal_StdDev"
names(xysub_actname)[names(xysub_actname) == "fBodyBodyGyroMag-std()"] <- "Freq_Gyroscopic_Magnitude_StdDev"
names(xysub_actname)[names(xysub_actname) == "fBodyBodyGyroJerkMag-std()"] <- "Freq_Gyroscopic_JerkSignal_StdDev"

#summarize the data by subject and activity for each variable
tidydata <- ddply(xysub_actname, .(Subject, Activity), summarise, 
                  Time_Acceleration_Magnitude_mean = mean(Time_Acceleration_Magnitude_mean), 
                  Time_Gravity_Accleration_Magnitude_mean = mean(Time_Gravity_Accleration_Magnitude_mean),
                  Time_Acceleration_JerkSignal_mean = mean(Time_Acceleration_JerkSignal_mean), 
                  Time_Gyroscopic_Magnitude_mean = mean(Time_Gyroscopic_Magnitude_mean),
                  Time_Gyroscopic_JerkSignal_mean = mean(Time_Gyroscopic_JerkSignal_mean), 
                  Freq_Acceleration_Magnitude_mean = mean(Freq_Acceleration_Magnitude_mean), 
                  Freq_Acceleration_JerkSignal_mean = mean(Freq_Acceleration_JerkSignal_mean),
                  Freq_Gyroscopic_Magnitude_mean = mean(Freq_Gyroscopic_Magnitude_mean),
                  Freq_Gyroscopic_JerkSignal_mean = mean(Freq_Gyroscopic_JerkSignal_mean), 
                  Angle_time_Acceleration_gravitymean = mean(Angle_time_Acceleration_gravitymean),
                  Angle_time_Acceleration_JerkSignal_gravitymean = mean(Angle_time_Acceleration_JerkSignal_gravitymean),
                  Angle_time_Gyroscopic_gravitymean = mean(Angle_time_Gyroscopic_gravitymean), 
                  Angle_time_Gyroscopic_JerkSignal_gravitymean = mean(Angle_time_Gyroscopic_JerkSignal_gravitymean), 
                  Angle_X_GravityMean = mean(Angle_X_GravityMean), 
                  Angle_Y_gravitymean = mean(Angle_Y_gravitymean),
                  Angle_Z_gravitymean = mean(Angle_Z_gravitymean),
                  Time_Acceleration_Magnitude_StdDev = mean(Time_Acceleration_Magnitude_StdDev),
                  Time_Gravity_Accleration_Magnitude_StdDev = mean(Time_Gravity_Accleration_Magnitude_StdDev),
                  Time_Acceleration_JerkSignal_StdDev = mean(Time_Acceleration_JerkSignal_StdDev),
                  Time_Gyroscopic_Magnitude_StdDev = mean(Time_Gyroscopic_Magnitude_StdDev),
                  Time_Gyroscopic_JerkSignal_StdDev = mean(Time_Gyroscopic_JerkSignal_StdDev),
                  Freq_Acceleration_Magnitude_StdDev = mean(Freq_Acceleration_Magnitude_StdDev),
                  Freq_Acceleration_JerkSignal_StdDev = mean(Freq_Acceleration_JerkSignal_StdDev),
                  Freq_Gyroscopic_Magnitude_StdDev = mean(Freq_Gyroscopic_Magnitude_StdDev),
                  Freq_Gyroscopic_JerkSignal_StdDev = mean(Freq_Gyroscopic_JerkSignal_StdDev))

#Instructions to Write the table for the assignment 
#code to read the data and look at it with promptdata is noted
write.table(tidydata, file = "tidydata.txt", row.names = FALSE)
#tidydata <- read.table("tidydata.txt", header = TRUE)
#promptdata(tidydata)