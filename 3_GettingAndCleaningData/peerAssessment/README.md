<h1>Getting and Cleaning Data</h1>

This repository contains the solution to the peer assessment fo the Coursera course "Getting and Cleaning data". In this peer assessment the [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones "Human Activity Recognition Using Smartphones Data Set") by Reyes-Ortiz et al. has to be preprocessed to create a tidy dataset for further analysis. The resulting dataset includes the training- as well as the testset, together with the subject vector and the vector with the activitiy labels.

The script run_analysis.R performs the following steps:

<ol>
    <li>Merging the training and the test sets to create one data set.</li>
    <li>Extraction only the measurements that contain the mean and standard deviation for each feature.</li>
    <li>Labeling each row of the dataset by human-readable activity labels.</li>
    <li>Labeling each column by human-readable feature labels</li>
    <li>Averaging of each variable for each activity and each subject.</li>
<ol>

<h2>Merging Training and Test Data</h2>
Let k be the number of training examples, l the number of test examples and m the number of features. Then the data will be merged in a [(k+l), m+2] dataframe. This dataframe combines the training and test data and contains the numeric subject and activity labels in the its first two columns.

<h2>Feature Extraction</h2>
From the identifiers in the feature vector, the characters "(", ")" are removed, while the characters "," and "-"  are replaced with underscores. After this preprocessing step all features with names containing the words "subject", "activity label", "Mean", "mean" and "std" are extracted.

<h2>Grouping and Averaging</h2>
The dataset is stacked vertically and the grouped by subject and activity labels. After that the mean function is applied to each variable and activity for each subject.

