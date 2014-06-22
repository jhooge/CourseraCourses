library(caret)
library(reshape2) ## for melting data frames
library(gridExtra) ## grid Plotting

## doMC will enable multi-threading
## remove the following lines if you CPU does not support hyperthreading
library(doMC)
NTHREADS <- 30 ## set this value depending on the number of threads you want to
## reserve
registerDoMC(cores=NTHREADS)

## convenience functions
removeNACols <- function(df) {
  return(df[, colSums(is.na(df)) != nrow(df)])
}

isZeroVariance <- function(X) {
  return(apply(X, 2, function(x) length(unique(x)) == 1))
}

defactorize <-function(X) {
  isFactor <- sapply(X, class) == "factor"
  X[, isFactor] <- as.numeric(as.character(X[, isFactor]))
  return(X)
}

skewnessPlot <- function(X) {
  skewValues <- as.data.frame(sapply(X, skewness, na.rm=TRUE, type=1))
  skewValues$variable <- rownames(skewValues)
  rownames(skewValues) <- NULL
  colnames(skewValues) <- c("skewnessValue", "variable")
  skewValues$variable <- as.factor(skewValues$variable)
  
  fig <- ggplot(skewValues, aes(x=variable, y=skewnessValue)) +
    geom_bar(stat="identity", position="dodge") +
    theme_bw() + 
    theme(axis.text.x = element_text(angle = 90, hjust = 1))
  return(fig)
}

varDistPlot <- function(X) {
  X_molten <- melt(X)
  fig3 <- ggplot(X_molten, aes(x = value)) + 
    facet_wrap(~ variable, scales = "free_x") + 
    geom_histogram() +
    theme_bw()
  return(suppressMessages(print(fig3)))
}

## convenience functions

X_test <- read.csv("../data//pml-testing.csv", stringsAsFactors=TRUE)
X_train <- read.csv("../data//pml-training.csv", stringsAsFactors=TRUE)

# Split label vector from feature matrix, because it should not be defacorized
Y_train <- X_train$classe
## Remove the first few columns, as they seem to be measurement device sprecific
X_train <- subset(X_train, select=-c(X, raw_timestamp_part_1,
                                     raw_timestamp_part_2, cvtd_timestamp,
                                     new_window, num_window))
X_test <- subset(X_test, select=-c(X, raw_timestamp_part_1,
                                   raw_timestamp_part_2, cvtd_timestamp,
                                   new_window, num_window))
## just the accelerometer, as expressed in the peer assessment description.
accelerometers <- colnames(X_train)[grep("accel", colnames(X_train))]
X_train_selected <- subset(X_train, select=accelerometers)
X_test_selected <- subset(X_test, select=accelerometers)

## cast factor- to numeric columns and add label vector again
X_train <- defactorize(X_train[,2:ncol(X_train)])
X_train_selected <- defactorize(X_train_selected[,2:ncol(X_train_selected)])
X_test_selected <- defactorize(X_test_selected[,2:ncol(X_test_selected)])
## remove zero variance predictors. This will also take care of NA columns.
X_train <- X_train[, !isZeroVariance(X_train)]
X_train_selected <- X_train_selected[, !isZeroVariance(X_train_selected)]
X_test_selected <- X_test_selected[, !isZeroVariance(X_test_selected)]

## skewness plots
skewnessPlot(X_train_selected)
varDistPlot(X_train_selected)

## remove acceleration variance features and impute values for the 
## rest of the features. After that unskew the feature distribution by 
## Box-Cox- transforming, mean-center and scale the features.
X_train_selected <- subset(X_train_selected, 
                           select=-c(var_total_accel_belt,
                                     var_accel_arm,
                                     var_accel_dumbbell, 
                                     var_accel_forearm))

preProc <- preProcess(X_train_selected, c("knnImpute", "BoxCox", 
                                          "center", "scale"))
X_trans <- predict(preProc, X_train_selected)

## Let's look at the skewness Values and the feature distributions again.
skewnessPlot(X_trans)
varDistPlot(X_trans)

## Training
## If you dont't want to train the models yourself you can load them  with the 
## I've provided the model in RData objects:
load("knnModel.RData")
load("naiveBayesModel.RData")

## Naive Bayes
ctrl <- trainControl(
  method = "repeatedcv",  # cross-validation method
  number = 10,            # number of folds
  repeats = 10,           # number of complete sets of folds
  allowParallel = TRUE)

naiveBayesModel <- train(X_trans, Y_train, 
                         method = "nb", 
                         trControl = ctrl)
naiveBayesModel
save(file="naiveBayesModel.RData", data=naiveBayesModel)
plot(naiveBayesModel, type="h")

## k-nearest neighbor
grid <- expand.grid(.k = seq(1, 10, length=10))

knnModel <- train(X_trans, Y_train, 
                  method = "knn", 
                  trControl = ctrl,
                  tuneGrid = grid)
knnModel
save(file="knnModel.RData", data=knnModel)
plot(knnModel)

## Linear-Kernel SVM
## define a sequence of tuning parameters over whichc the 
## cv error will be minimized

## For svmLinear there exists only a single tuning parameter C. 
## The C parameter tells the SVM optimization how much you want 
## to avoid misclassifying each training example. For large values 
## of C, the optimization will choose a smaller-margin hyperplane 
# if that hyperplane does a better job of getting all the training 
## points classified correctly. Conversely, a very small value of C 
## will cause the optimizer to look for a larger-margin separating 
## hyperplane, even if that hyperplane misclassifies more points. 
## For very tiny values of C, you should get misclassified examples, 
## often even if your training data is linearly separable. 
## (http://stats.stackexchange.com/a/31067/46152)
grid <- expand.grid(.C = seq(10^(-5), 10^5, length=10))

svmLinearModel <- train(X_trans, Y_train, 
                        method = "svmLinear", 
                        trControl = ctrl,
                        tuneGrid = grid)
svmLinearModel
save(file="svmLinearModel.RData", data=svmLinearModel)


## Model Selection
accDensNB <- densityplot(naiveBayesModel)
accDensKNN <- densityplot(knnModel)
grid.arrange(accDensNB, accDensKNN, 
             main = "Cross Validation Accuracy",
             nrow=2)

resamps <- resamples(list(NaiveBayes = naiveBayesModel,
                          knn = knnModel))
summary(resamps)

trellis.par.set(caretTheme())
bwplot(resamps, layout = c(2, 1))
xyplot(resamps, what = "BlandAltman")
splom(resamps, alpha=0.3)
densityplot(resamps)

prediction <- data.frame(knn=predict(knnModel, na.omit(X_test_selected)),
                         naiveBayes=predict(naiveBayesModel, na.omit(X_test_selected)))
prediction$knn <- as.character(prediction$knn)
prediction$naiveBayes <- as.character(prediction$naiveBayes)

## Submission
source("submit.R")
pml_write_files(prediction$knn)

################################################################################
### Session Information

sessionInfo()




