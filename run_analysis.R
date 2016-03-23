library(dplyr)
# read in datafiles - already unpacked into working directory. 
features <- read.table("features.txt", stringsAsFactors = FALSE)
activity.labels <- read.table("activity_labels.txt", stringsAsFactors = FALSE)
subject.test <- read.table("test/subject_test.txt", stringsAsFactors = FALSE)
X.test <- read.table("test/X_test.txt", stringsAsFactors = FALSE)
y.test <- read.table("test/y_test.txt", stringsAsFactors = FALSE)
subject.train <- read.table("train/subject_train.txt", stringsAsFactors = FALSE)
X.train <- read.table("train/X_train.txt", stringsAsFactors = FALSE)
y.train <- read.table("train/y_train.txt", stringsAsFactors = FALSE)

# Join the test and training data (and activity and subject vectors)
X.all <- rbind(X.test, X.train)
y.all <- rbind(y.test, y.train)
subject.all <- rbind(subject.test, subject.train)

# to extract the column names with mean(), std()
# we need to get the indeces from features
# remember the chosen variable names and then select. 
chosen.colindeces <- grep("(.*mean().*)|(.*std().*)", features[,2])
chosen.colnames <- features [chosen.colindeces,2]
allObs.selectedvars <- select(X.all, chosen.colindeces)

# put in activity and subject columns
names(allObs.selectedvars) <- chosen.colnames
names(y.all) <- "Activity_nr"
names(subject.all) <- "Subject"
allObs.selectpluss <- cbind(allObs.selectedvars, y.all, subject.all)

# use merge to name activities by fetching and putting in activity labels
names (activity.labels) <- c("Activity_nr", "Activity_name")
obs.named.activity <- merge(allObs.selectpluss, activity.labels, by.x= "Activity_nr", by.y= "Activity_nr")

# group by activity and subject
groupedobs <- group_by(obs.named.activity, Activity_name, Subject)
# and then find the mean for each column
means.by.group <- summarize_each(groupedobs, funs(mean))

write.table(means.by.group, "means-by-group.txt")
