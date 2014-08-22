<h1>The Code Book</h1>

This Codebook describes the data transformations which have been performed to process the raw data for further analysis. For information about the raw data, authors of the original data set and experimental setup, please refer to [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones "Human Activity Recognition Using Smartphones Data Set").

<h2>Data Transformations</h2>

<h3>Merging Training and Test Data</h3>
Let k be the number of training examples, l the number of test examples and m the number of features. Then the data will be merged in a [(k+l), m+2] dataframe. This dataframe combines the training and test data and contains the numeric subject and activity labels in the its first two columns.

<h3>Feature Extraction</h3>
From the identifiers in the feature vector, the characters "(", ")" are removed, while the characters "," and "-"  are replaced with underscores. After this preprocessing step all features with names containing the words "subject", "activity label", "Mean", "mean" and "std" are extracted.

<h3>Grouping and Averaging</h3>
The dataset is stacked vertically and the grouped by subject and activity labels. After that the mean function is applied to each variable and activity for each subject.