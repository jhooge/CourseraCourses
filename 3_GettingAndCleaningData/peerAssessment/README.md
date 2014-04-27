<h1>Getting and Cleaning Data</h1>

This repository contains the solution to the peer assessment fo the Coursera course "Getting and Cleaning data". In this peer assessment the [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones "Human Activity Recognition Using Smartphones Data Set") by Reyes-Ortiz et al. has to be preprocessed to create a tidy dataset for further analysis. The resulting dataset includes the training- as well as the testset, together with the subject vector and the vector with the activitiy labels.

The script run_analysis.R performs the following steps:

<ol>
    <li>Merging the training and the test sets to create one data set.</li>
    <li>Extraction only the measurements that contain the mean and standard deviation for each feature.</li>
    <li>Labeling each row of the dataset by human-readable activity labels.</li>
    <li>Labeling each column by human-readable feature labels</li>
    <li>Averaging of each variable for each activity and each subject.</li>
</ol>

The script uses the three helper functions mergeData, extractCols and reformat to encapsulate its preprocessing steps in the following order.

