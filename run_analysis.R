## run_analysis.R
## Leonardo Mendes de Oliveira

############################
### Files 
###
# File URL to download
fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
# Local data file
downloadZipFile <- "./getdata-projectfiles-UCI-HAR-Dataset.zip"
# File of the tidy data:
tidyDataFile       <- "./tidyUciHar.txt"
tidyDataFileAVGtxt <- "./tidyUciHarAvg.txt"

### Download and Unzip
if (file.exists(downloadZipFile) == FALSE) { download.file(fileUrl, destfile = downloadZipFile) }
if (file.exists("./UCI HAR Dataset") == FALSE) {  unzip(downloadZipFile)  }


########################################
## STEP 1
## Merges the training and the test sets to create one data set:


# Read files
x_train    <- read.table("./UCI HAR Dataset/train/X_train.txt"      , header = FALSE)
x_test     <- read.table("./UCI HAR Dataset/test/X_test.txt"        , header = FALSE)
y_train    <- read.table("./UCI HAR Dataset/train/y_train.txt"      , header = FALSE)
y_test     <- read.table("./UCI HAR Dataset/test/y_test.txt"        , header = FALSE)
subj_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subj_test  <- read.table("./UCI HAR Dataset/test/subject_test.txt"  , header = FALSE)

# Data table (train vs test) 
# I chose rbind for union this tables.

x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
s <- rbind(subj_train, subj_test)


########################################
## STEP 2
## Extracts only the measurements on the mean and standard deviation for each measurement:

# Read features labels and set names to features column
features <- read.table("./UCI HAR Dataset/features.txt")
names(features) <- c('feat_id', 'feat_name')

# Search for matches to argument mean or standard deviation (sd)  within each element of character vector
# the index returns numbers of columns matches 
idxFeatures <- grep("-mean\\(\\)|-std\\(\\)", features$feat_name) 
x <- x[, idxFeatures] 

# Replaces all matches of a string features 
# And cut chars ()-  
names(x) <- gsub("\\(|\\)|\\-", "", (features[idxFeatures, 2]))

########################################
## STEP 3
## Uses descriptive activity names to name the activities in the data set

# Read activity labels
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")

########################################
## STEP 4
## Appropriately labels the data set with descriptive variable names.

# Names to activities 
names(activities) <- c('act_id', 'act_name')
y[, 1] = activities[y[, 1], 2]

names(y) <- "Activity"
names(s) <- "Subject"

# Combines data table by columns
tidyData <- cbind(s, y, x)

# Creating csv (tidy data set)
write.table(tidyData, tidyDataFile)

########################################
## STEP 5
## From the data set in step 4, creates a second, independent tidy data set with the average 
## of each variable for each activity and each subject.

temp <- tidyData[, 3:dim(tidyData)[2]] 
tidyDataAVGSet <- aggregate(temp,list(tidyData$Subject, tidyData$Activity), mean)

# the columns were with generic names (Group.1, Group.2) 
# renaming below:
names(tidyDataAVGSet)[1] <- "Subject"
names(tidyDataAVGSet)[2] <- "Activity"

# Creating txt (tidy data set average) 
write.table(tidyDataAVGSet, tidyDataFileAVGtxt)

# End.

