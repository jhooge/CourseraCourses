![](images/shinyApp.png?raw=true)

This shiny app has been created as part of the Coursera Course “Developing Data Products”. 
It uses Mixtures of Gaussians for a Model Based Cluster analysis of the Pima Indian Diabetes Database. 
Up to ten components can be chosen for the mixtures. The supervised classification result, together 
with classification uncertainty and errors can be observed in 2D projections of the feature space. 
Densities for each feature is estimated and provides an overview of the feature space. The best model 
is chosen over all components and 10 different covariance structures, which determine the volume, 
shape and orientation of the gaussian hyper-spheres fitted to the data. The optimal fit is determined 
by the Bayesian Information Criterion (BIC). When fitting models, it is possible to increase the 
likelihood by adding parameters, but doing so may result in overfitting. The BIC resolves this problem 
by introducing a penalty term for the number of parameters in the model.

## The Pima Indian Diabetic Database (PIDD)

The Pima Indians may be genetically predisposed to diabetes (Hanson, Ehm et al. 1998), and it was noted 
that their diabetic rate was 19 times that of a typical town in Minnesota (Knowler, Bennett et al. 1978).
The National Institute of Diabetes and Digestive and Kidney Diseases of the NIH originally owned the Pima 
Indian Diabetes Database (PIDD). In 1990 it was received by the UC-Irvine Machine Learning Repository and 
can be downloaded at [www.ics.uci.edu/~mlearn/MLRepository.html](www.ics.uci.edu/~mlearn/MLRepository.html). 
The database has n=768 patients each with numeric variables.


<ul>
    <li>number of times pregnant</li>
    <li>2-hour OGTT plasma glucose</li>
    <li>diastolic blood pressure</li>
    <li>triceps skin fold</li>
    <li>thickness</li>
    <li>2-hour serum insulin</li>
    <li>BMI</li>
    <li>diabetes pedigree function</li>
    <li>age</li>
    <li>diabetes onset within 5 years (0, 1)</li>
</ul>

## Usage

This app is hosted on [shinyapps.io](http://jhooge.shinyapps.io/MixtureModeling/).
However if you would like to run it in your own environment follow the instructions below.

```R
library(shiny)

# Easiest way is to use runGitHub
runGitHub(“CourseraCourses/DataScience/ß_DevelopingDataProducts/MixtureModeling”, “jhooge”)
```

Or you can clone the git repository, then use `runApp()`:

```R
# First clone the repository with git. If you have cloned it into
# ~/MixtureModeling, first go to that directory, then use runApp().
setwd(“~/CourseraCourses/DataScience/9_DevelopingDataProducts/MixtureModeling”)
runApp()
```

## Acknowledgements

This application is based on the package [mclust](http://www.stat.washington.edu/mclust/), and a large part of the source code 
is inspired by the work done by the mclust’s authors.

Copyright © Jens Hooge 2014. All Rights Reserved.
