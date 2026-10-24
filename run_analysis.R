# run_analysis.R
# Getting and Cleaning Data - course project
# Produces tidy_data.txt from the UCI HAR Dataset (Samsung Galaxy S accelerometer data).
# Base R only; no extra packages required.

# ---- 0. Download and unzip --------------------------------------------------
data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zip_file <- "UCI_HAR_Dataset.zip"
base_dir <- "UCI HAR Dataset"

if (!file.exists(base_dir)) {
  if (!file.exists(zip_file)) {
    download.file(data_url, zip_file, mode = "wb")
  }
  unzip(zip_file)
}

# ---- 1. Read lookup tables --------------------------------------------------
features <- read.table(file.path(base_dir, "features.txt"),
                       col.names = c("index", "name"),
                       stringsAsFactors = FALSE)
activity_labels <- read.table(file.path(base_dir, "activity_labels.txt"),
                              col.names = c("id", "activity"),
                              stringsAsFactors = FALSE)

# ---- 2. Read and merge training and test sets (step 1) ----------------------
read_set <- function(set) {
  x <- read.table(file.path(base_dir, set, paste0("X_", set, ".txt")))
  y <- read.table(file.path(base_dir, set, paste0("y_", set, ".txt")),
                  col.names = "activity_id")
  s <- read.table(file.path(base_dir, set, paste0("subject_", set, ".txt")),
                  col.names = "subject")
  list(x = x, y = y, s = s)
}

train <- read_set("train")
test  <- read_set("test")

x_all <- rbind(train$x, test$x)
y_all <- rbind(train$y, test$y)
s_all <- rbind(train$s, test$s)

# ---- 3. Keep only mean() and std() measurements (step 2) --------------------
# meanFreq() is excluded on purpose: it is a weighted frequency average,
# not the mean of a measurement.
keep <- grep("-(mean|std)\\(\\)", features$name)
x_all <- x_all[, keep]
var_names <- features$name[keep]

# ---- 4. Descriptive variable names (step 4) ---------------------------------
clean_names <- function(n) {
  n <- gsub("\\(\\)", "", n)
  n <- gsub("-mean", "Mean", n)
  n <- gsub("-std", "StdDev", n)
  n <- gsub("-", "", n)
  n <- gsub("^t", "Time", n)
  n <- gsub("^f", "Frequency", n)
  n <- gsub("BodyBody", "Body", n)
  n <- gsub("Acc", "Accelerometer", n)
  n <- gsub("Gyro", "Gyroscope", n)
  n <- gsub("Mag", "Magnitude", n)
  n
}
names(x_all) <- clean_names(var_names)

# ---- 5. Descriptive activity names (step 3) ---------------------------------
activity <- factor(y_all$activity_id,
                   levels = activity_labels$id,
                   labels = tolower(activity_labels$activity))

merged <- cbind(subject = s_all$subject, activity = activity, x_all)

# ---- 6. Tidy data set of averages (step 5) ----------------------------------
tidy <- aggregate(. ~ subject + activity, data = merged, FUN = mean)
tidy <- tidy[order(tidy$subject, tidy$activity), ]
rownames(tidy) <- NULL

write.table(tidy, "tidy_data.txt", row.names = FALSE)

# To read back in:
# read.table("tidy_data.txt", header = TRUE)
