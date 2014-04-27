require(stringr)
require(dplyr)
require(data.table)
require(reshape2)

#' 
#' 
#' @author Jens Hooge jens.hooge@gmail.com

#' @title Merging Training and Test Data.
#' 
#' @description \code{mergeData} Merges test and training data.
#' 
#' @details
#' \code{mergeData} merges the training- and test datafames for later analysis.
#' This includes the response as well as the subject vector and activity labels.
#' Let k be the number of training examples, l the number of test examples and
#' m the number of features. The function merges the data in a [(k+l), m+2]
#' dataframe. It combines the training and test data and contains the numeric
#' subject and activity labels in the its first two columns.
#' 
#' @param XTrain A [k x m] data frame of training data.
#' @param XTest A [l x m] data frame of test data.
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

#' @title Extraction of columns in data frame which contain means and standard deviations.
#' 
#' @description \code{extractCols} extracts columns containing means and standard deviations.
#' 
#' @details
#' \code{extractCols} is a helper function for \code{run_analysis}, which removes the
#' the characters "(", ")" and replaces "," and "-" with underscores, from the
#' identifiers in the feature vector. It then extracts all columns from df with
#' a column name that contain the words "subject", "activity label", "Mean",
#' "mean" and "std" and returns it.
#' 
#' @param df A data frame which includes test- and training data as well as the subject and activity label vector.
#' @param features A data frame of feature lables.
#' 
#' @return data.frame {base}
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

#' @title Reshapes a preprocessed data frame
#' 
#' @description \code{reformat} groups the data by subject and activity labels.
#' 
#' @details
#' \code{extractCols}  is a helper function for \code{run_analysis}. It groups 
#' the data set by subject and activity labels, applies the mean function to 
#' each to variable for each activity and each subject and returns the resulting
#' data frame.
#' 
#' @param df A data frame which includes test- and training data as well as the subject and activity label vector.
#' 
#' @return data.frame {base}
reformat <- function(df) {
    df <- melt(df, id.vars=c("subject", "activity_label"))
    df <- aggregate(value~subject+activity_label+variable, data=df, mean)
    df <- dcast(df, subject+activity_label~variable, value.var="value")
    return(df)
}

#' @title Generation of a tidy dataset.
#' 
#' @description \code{run_analysis} reads the raw data files from the UCI Dataset and calls its helper functions to generate a tidy dataset.
#' 
#' @details
#' \code{run_analysis} is the actual main-function of this module, which uses 
#' \code{mergeData}, \code{extractCols} and \code{reformat} to generate a clean
#' dataset for further analysis, writes it to a csv-File called 
#' "tidy_dataset.txt" and returns the resulting data frame.
#' 
#' @return data.frame {base}
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
