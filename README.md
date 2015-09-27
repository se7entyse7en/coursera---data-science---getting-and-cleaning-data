# Coursera - Data Science Specialization - Getting and Cleaning Data

## Course Project


This project consists in collecting, working and cleaning the dataset provided at the following link:

    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

This dataset was built by measuring the signals of the accelerometer and the gyroscope of a smartphone (Samsung Galaxy S II) worn on the waist by a group of volunteers by performing six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING). For more details about this dataset please see its `README.txt` file.

### Files

- `README.md`: This file
- `CodeBook.md`: Codebook explaining the variables of the resulting dataset
- `UCI HAR Dataset/`: Folder containing the unzipped original dataset
- `run_analysis.R`: R script to use to clean the original dataset and to create a new tidy dataset as described in `CodeBook.md`

### Processing steps

To run the analysis and create the new tidy dataset run the `runAnalysis` function with no arguments present in `run_analysis.R` file.
The steps performed by the `runAnalysis` function are the following:

1. `getDataSets`:
    1. Retrieves the names of the columns of the dataset from the second column of `UCI HAR Dataset/features.txt`.
    2. Retrieves the different components of the training dataset `UCI HAR Dataset/train/X_train.txt`, `UCI HAR Dataset/train/y_train.txt`, `UCI HAR Dataset/train/subject_train.txt` and add the column names retrieved in "1.i" for the first dataset. The other two datasets have both a single column and are named "activity" and "subject" respectively.
    3. Retrieves the different components of the testing dataset `UCI HAR Dataset/test/X_test.txt`, `UCI HAR Dataset/test/y_test.txt`, `UCI HAR Dataset/test/subject_test.txt` and add the column names retrieved in "1.i" for the first dataset. The other two datasets have both a single column and are named "activity" and "subject" respectively.
2. `mergeDataSets`:
    1. Combines the columns of the three training datasets into one (using `cbind`).
    2. Combines the columns of the three testing datasets into one (using `cbind`).
    3. Combines the rows of the newly created datasets in "2.i" and "2.ii" into one (using `rbind`).
3. `expandActivityValues`:
    1. Retrieves the activity labels from the second column of `UCI HAR Dataset/activity_labels.txt`.
    2. Substitute the numerical values in the "activity" column of the merged dataset with its corresponding label (1 -> WALKING, 2 -> WALKING_UPSTAIRS, etc.).
4. `extractMeanStdCols`: Create a new dataset by selecting only the columns "activity", "subject" and those containing the string ".mean." or ".std." (which correspond to those containing the string "-mean()" or "-std()" in the original dataset).
5. `group_by`: Group the dataset by "activity" and "subject".
6. `summarizeMean`:
    1. Apply the `mean` function to all the non-grouping variables of the dataset.
    2. Rename the all the non-grouping variables columns by prefixing them with the string "mean.".

The resulting tidy dataset contains a row for each couple `(<activity>, <subject>)`. The values contained in each of the other columns correspond to the mean of the values in the original dataset grouped by "activity", and "subject" (See also `CodeBook.md`).
