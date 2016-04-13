
setwd("~/R_coursera/CleaningDataCourseProject/UCI HAR Dataset")

# Read activity, subject, and features files 
activityTest <- read.table("./test/Y_test.txt")
activityTrain <- read.table("./train/Y_train.txt")
activityLabels <- read.table("./activity_labels.txt")

subjectTest <- read.table("./test/subject_test.txt")
subjectTrain <- read.table("./train/subject_train.txt")

featuresTest <- read.table("./test/X_test.txt")
featuresTrain <- read.table("./train/X_train.txt")

# Merge activity, subject and features data by rbind
activityData <- rbind(activityTrain, activityTest)
subjectData <- rbind(subjectTrain, subjectTest)
featuresData <- rbind(featuresTrain, featuresTest)

# Name variables
names(activityData) <- c("activity")
names(subjectData) <- c("subject")
featuresNames <- read.table("./features.txt")
names(featuresData) <- featuresNames$V2

# Rename activity numbers with activity labels
activityData$activity <- as.factor(activityData$activity)
levels(activityData$activity) <- activityLabels$V2

# Merge all data
allData <- cbind(subjectData, activityData)
finalData <- cbind(featuresData, allData)

# Subset data with only mean or std in features names
subfeaturesNames <- featuresNames$V2[grep("mean\\(\\)|std\\(\\)", featuresNames$V2)]
namesSelected <- c(as.character(subfeaturesNames), "subject", "activity")
finalData <- subset(finalData, select=namesSelected)

# Label variables with descriptive names
names(finalData) <- gsub("^t", "time", names(finalData))
names(finalData) <- gsub("^f", "frequency", names(finalData))
names(finalData) <- gsub("Acc", "Accelerometer", names(finalData))
names(finalData) <- gsub("BodyBody", "Body", names(finalData))
names(finalData) <- gsub("Gyro", "Gyroscope", names(finalData))
names(finalData) <- gsub("Mag", "Magnitude", names(finalData))
names(finalData) <- gsub("mean()", "Mean", names(finalData))
names(finalData) <- gsub("std()", "StdDev", names(finalData))

# Create independent tidy data set for average of each variable for each activity and subject
meanData <- aggregate(. ~subject + activity, finalData, mean)
write.table(meanData, file = "tidydata.txt", row.name=FALSE)
