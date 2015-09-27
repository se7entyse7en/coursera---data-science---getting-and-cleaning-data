library("dplyr")


runAnalysis <- function() {
    basePath <- "UCI HAR Dataset"

    dataSets <- getDatasets(basePath)

    allInOneDataSet <- mergeDatasets(
        dataSets$xTrain, dataSets$yTrain, dataSets$subTrain,
        dataSets$xTest, dataSets$yTest, dataSets$subTest)
    allInOneDataSet <- expandActivityValues(basePath, allInOneDataSet)

    filteredDataSet <- extractMeanStdCols(allInOneDataSet)

    groupedDataSet <- group_by(filteredDataSet, activity, subject)
    summarizedDataSet <- summarizeMean(groupedDataSet)

    summarizedDataSet
}

getDatasets <- function(basePath) {
    colNamesX <- read.table(file.path(basePath, "features.txt"))$V2
    colNameY <- "activity"
    colNameSubject <- "subject"

    trainPath <- file.path(basePath, "train")
    testPath <- file.path(basePath, "test")

    trainingDataSetX <- read.table(
        file.path(trainPath, "X_train.txt"), col.names=colNamesX)
    trainingDataSetY <- read.table(
        file.path(trainPath, "y_train.txt"), col.names=colNameY)
    trainingDataSetSubject <- read.table(
        file.path(trainPath, "subject_train.txt"), col.names=colNameSubject)
    testingDataSetX <- read.table(
        file.path(testPath, "X_test.txt"), col.names=colNamesX)
    testingDataSetY <- read.table(
        file.path(testPath, "y_test.txt"), col.names=colNameY)
    testingDataSetSubject <- read.table(
        file.path(testPath, "subject_test.txt"), col.names=colNameSubject)

    list(xTrain=trainingDataSetX, yTrain=trainingDataSetY,
         subTrain=trainingDataSetSubject,
         xTest=testingDataSetX, yTest=testingDataSetY,
         subTest=testingDataSetSubject)
}

mergeDatasets <- function(trainingDataSetX, trainingDataSetY,
                          trainingDateSetSub,
                          testingDataSetX, testingDataSetY,
                          testingDataSetSub) {
    mergedTrainingDataSet <- cbind(trainingDataSetX, trainingDataSetY,
                                   trainingDateSetSub)
    mergedTestingDataSet <- cbind(testingDataSetX, testingDataSetY,
                                  testingDataSetSub)
    allInOneDataSet <- rbind(mergedTrainingDataSet, mergedTestingDataSet)

    allInOneDataSet
}

expandActivityValues <- function(basePath, dataSet) {
    activityValues <- read.table(file.path(basePath, "activity_labels.txt"))
    mapping <- list()
    mapping[activityValues$V1] <- as.character(activityValues$V2)
    dataSet[, "activity"] <- unlist(mapping[dataSet[, "activity"]])

    dataSet
}

extractMeanStdCols <- function(dataSet) {
    colNames <- names(dataSet)
    filteredDataSet <- select(dataSet, matches("\\.mean\\."), matches("\\.std\\."),
                              activity, subject)

    filteredDataSet
}

summarizeMean <- function(dataSet) {
    summarizedDataSet <- summarize_each(dataSet, funs(mean))

    oldNames <- names(summarizedDataSet)
    newNames <- c(oldNames[1:2], paste("mean", oldNames[3:length(oldNames)], sep="."))
    names(summarizedDataSet) <- newNames

    summarizedDataSet
}
