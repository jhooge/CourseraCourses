require(stringr)
require(dplyr)
require(data.table)
require(reshape2)

#' The following functions enable so called "caching" of the inverse of a
#' square matrix.
#' @author Jens Hooge jens.hooge@gmail.com

#' @title Merging Training and Test Data.
#' 
#' @description \code{mergeData} Merges test and training data.
#' 
#' @details
#' \code{mergeData} expects the training and test data in dataframes. This
#' includes the response as well as the subject vector and activity labels.
#' 
#' @param XTrain A [k x n] data frame of training data.
#' @param XTest A [l x n] data frame of test data.
#' @param yTrain A [k x 1] data frame representing a slice of the training response vector .
#' @param yTest A [l x 1] data frame representing a slice of the test response vector.
#' @param subjectsTrain A [k x 1] data frame representing a slice of subjects used for training.
#' @param subjectsTest A [l x 1] data frame representing a slice of subjects used for testing.
#' @param labels A [6 x 2] data frame representing the mapping of numeric and human readable activity labels.
#' 
#' @return data.frame {base} 
mergeData <- function(XTrain, XTest,
                      yTrain, yTest,
                      subjectsTrain, subjectsTest,
                      labels) {
    y <- rbind(yTrain, yTest)
    subjects <- rbind(subjectsTrain, subjectsTest)
    X <- rbind(XTrain, XTest)
    X <- cbind(y, X)
    X <- cbind(subjects, X)
    X[, 1] <- as.factor(X[, 1])
    X[, 2] <- factor(X[, 2], labels=as.character(labels$V2))
    return(X)
}

extractCols <- function(df, features) {
    colnames(df)[1] <- "subject"
    colnames(df)[2] <- "activity_label"
    colnames(df)[3:dim(df)[2]] <- str_replace_all(as.character(features[, 2]), "[()]", "")
    colnames(df) <- str_replace_all(colnames(df), "[,-]", "_")
    columnNames <- colnames(df)[str_detect(colnames(df), "subject")]
    columnNames <- c(columnNames, colnames(df)[str_detect(colnames(df), "activity_label")])
    columnNames <- c(columnNames, colnames(df)[str_detect(colnames(df), "mean")])
    columnNames <- c(columnNames, colnames(df)[str_detect(colnames(df), "Mean")])
    columnNames <- c(columnNames, colnames(df)[str_detect(colnames(df), "std")])
    return(df[columnNames])
}

reformat <- function(df) {
    df <- melt(df, id.vars=c("subject", "activity_label"))
    df <- aggregate(value~subject+activity_label+variable, data=df, mean)
    df <- dcast(df, subject+activity_label~variable, value.var="value")
    return(df)
}

run_analysis <- function() {
    features <- read.csv("./UCI_HAR_Dataset/features.txt", 
                         sep="", header=FALSE)
    labels <- read.csv("./UCI_HAR_Dataset//activity_labels.txt", 
                       sep="", header=FALSE)
    XTest <- read.csv("./UCI_HAR_Dataset/test/X_test.txt", 
                      sep="", header=FALSE)
    XTrain <- read.csv("./UCI_HAR_Dataset/train/X_train.txt",
                       sep="", header=FALSE)
    yTest <- read.csv("./UCI_HAR_Dataset/test/y_test.txt",
                      sep="", header=FALSE)
    yTrain <- read.csv("./UCI_HAR_Dataset/train/y_train.txt",
                       sep="", header=FALSE)
    subjectsTest <- read.csv("./UCI_HAR_Dataset/test/subject_test.txt",
                      sep="", header=FALSE)
    subjectsTrain <- read.csv("./UCI_HAR_Dataset/train/subject_train.txt",
                       sep="", header=FALSE)
    
    X <- mergeData(XTrain, XTest,
                   yTrain, yTest,
                   subjectsTrain, subjectsTest,
                   labels)
    X <- extractCols(X, features)
    X <- reformat(X)
    
    write.csv(X, file="./UCI_HAR_Dataset/tidy_dataset.txt")
    return(X)
}

X <- run_analysis()
