library(data.table)

testData <- read.csv("data//pml-testing.csv", stringsAsFactors=TRUE)
trainingData <- read.csv("data//pml-training.csv", stringsAsFactors=TRUE)

removeNACols <- function(df) {
  return(df[, colSums(is.na(df)) != nrow(df)])
}

testData <- testData[, colSums(is.na(testData)) != nrow(testData)]

condition <- colSums(is.na(testData)) != nrow(testData)
names(condition) <- NULL

testData