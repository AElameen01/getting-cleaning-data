# Getting and Cleaning Data - Course Project

This repo contains a single script, `run_analysis.R`, that turns the UCI HAR (Human Activity Recognition Using Smartphones) data into a tidy data set.

## Files

| File | Purpose |
|---|---|
| `run_analysis.R` | Downloads the raw data, cleans it, and writes `tidy_data.txt` |
| `CodeBook.md` | Describes the variables, the data, and every transformation |
| `tidy_data.txt` | Output: average of each variable per subject and activity |

## How to run

1. Open R in the repo folder.
2. Run `source("run_analysis.R")`.

The script downloads and unzips the data into `UCI HAR Dataset/` if it is not already there. It uses base R only. Output is `tidy_data.txt` in the working directory.

To read the result:

```r
tidy <- read.table("tidy_data.txt", header = TRUE)
```

## How the script works

1. **Download and read.** Gets the zip, reads `features.txt` and `activity_labels.txt`, then reads `X_`, `y_` and `subject_` files for both `train` and `test`.
2. **Merge (step 1).** Row-binds train and test for the measurements, activity ids and subject ids, then column-binds them.
3. **Extract (step 2).** Keeps only features whose names contain `mean()` or `std()` (66 variables). `meanFreq()` is excluded.
4. **Activity names (step 3).** Replaces activity ids 1-6 with lower-case labels from `activity_labels.txt`.
5. **Variable names (step 4).** Expands abbreviations and removes punctuation, e.g. `tBodyAcc-mean()-X` becomes `TimeBodyAccelerometerMeanX`.
6. **Tidy output (step 5).** Averages every variable by subject and activity with `aggregate()`, giving 180 rows (30 subjects x 6 activities), and writes `tidy_data.txt`.

The raw data description is at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
