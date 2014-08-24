library(shiny)
library(mlbench)
library(shinyBS)

data(PimaIndiansDiabetes2)

data <- PimaIndiansDiabetes2
data <- data[complete.cases(data), ]
response <- data[,9]
data <- data[,-9]

# data <- iris[,-5]
# data <- rbind(solTrainX, solTestX)
# data <- data[, 209:228]

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Normal Mixture Modeling for Model-Based Clustering"),
    
    # Sidebar with a slider input for the number of bins
    sidebarLayout(
        sidebarPanel(
            helpText("Change the number of clusters to perform a 
                     Bayesian Information Criterion (BIC) based cluster analysis. BIC
                     values are compared to optimize parameters for up to 9
                     components. Tooltips give information about how to interact with the UI.
                     For more information on this app, please refer to the \"About\" tab 
                     to the right."),
            selectInput("x", label="X Variable", choices=names(data),
                        selected=names(data)),
            selectInput("y", label="Y Variable", choices=names(data),
                        selected=names(data)),
            sliderInput("clusters", "Number of Clusters", 1, 9, 2, step = 1),
            bsTooltip("x", "This changes the variable displayed on the x-axis.", "right"), 
            bsTooltip("y", "This changes the variable displayed on the y-axis", "right"), 
            bsTooltip("clusters", "This changes the number of components used for the Mixture Model", "right")
        ),
        
        mainPanel(
            tabsetPanel(id="modelSelection", type="pills", position="above",
                        tabPanel(title="Classification",
                                 plotOutput("classification", height = 600, width = 800),
                                 bsTooltip("classification", "Click to get information.", "top"),
                                 bsPopover("classification", "Classification Result", 
                                           "A coordinate projection of selected variables. Colors indicate class identity. The ellipses correspond to the covariances of the components.", 
                                           trigger="click", placement="left")
                        ),
                        tabPanel(title="Uncertainty",
                                 plotOutput("uncertainty", height = 600, width = 800),
                                 bsTooltip("uncertainty", "Click to get information.", "top"),
                                 bsPopover("uncertainty", "Classification Uncertainty", 
                                           "A coordinate projection of selected variables. Colors indicate class identity, while point size indicate the risk of misclassification. The ellipses correspond to the covariances of the components.", 
                                           trigger="click", placement="left")
                        ),
                        tabPanel(title="Errors",
                                 plotOutput("errors", height = 600, width = 800),
                                 bsTooltip("errors", "Click to get information.", "top"),
                                 bsPopover("errors", "Classification Error", 
                                           "A coordinate projection of selected variables. Colors indicate class identity, while black points indicate samples that have been misclassified. The ellipses correspond to the covariances of the components.", 
                                           trigger="click", placement="left")
                        ),
                        tabPanel(title="Density Estimation",
                                 plotOutput("density", height = 600, width = 800),
                                 bsTooltip("density", "Click to get information.", "top"),
                                 bsPopover("density", "Density Estimation",
                                           "A contour plot matrix of estimated variable densities, projected onto 2D space. Numbers indicate the height ", 
                                           trigger="click", placement="left")
                        ),
                        tabPanel(title="Model-based Clustering",
                                 plotOutput("modelSelection", height = 600, width = 800),
                                 HTML("<br><h2>BIC Values</h2><br>The best model is chosen over all components and 10 different covariance structures, 
                                      which determine the volume, shape and orientation of the gaussian hyper-spheres fitted to the data.
                                      The optimal fit is determined by the Bayesian Information Criterion (BIC). The BIC values as well
                                      as the top three models can be seen below. The missing values correspond to models and numbers of clusters for which parameter values
                                      could not be fit (using the default initialization). For multivariate data, the default initialization
                                      for all models uses the classification from hierarchical clustering based on an unconstrained model.
                                      For univariate data, the default is to classify the data by quantile for initialization.<br><br>"),
                                 verbatimTextOutput("modelSummary"),
                                 HTML("<br><h2>Parameterizations of the Covariance Matrix</h2><br><br>"),
                                 dataTableOutput("covStructures")
                        ),
                        tabPanel(title="About",
                                 HTML("<br>
                                      <h2>About</h2>
                                      <p style=\"width:800px;text-align:justify\"><span style=\"color:#000000;font-size:16px\">
                                      This tool has been created as part of the Coursera Course \"Developing Data Products\". 
                                      It uses Mixtures of Gaussians for a Model Based Cluster analysis of the Pima Indian Diabetes Database. 
                                      Up to ten components can be chosen for the mixtures. The supervised classification result, together 
                                      with classification uncertainty and errors can be observed in 2D projections of the feature space. 
                                      Densities for each feature is estimated and provides an overview of the feature space. The best model 
                                      is chosen over all components and 10 different covariance structures, which determine the volume, 
                                      shape and orientation of the gaussian hyper-spheres fitted to the data. The optimal fit is determined 
                                      by the Bayesian Information Criterion (BIC). When fitting models, it is possible to increase the 
                                      likelihood by adding parameters, but doing so may result in overfitting. The BIC resolves this problem  
                                      by introducing a penalty term for the number of parameters in the model.
                                      </span></p><br>

                                      <h2>The Pima Indian Diabetic Database (PIDD)</h2>
                                      <p style=\"width:800px;text-align:justify\"><span style=\"color:#000000;font-size:16px\">
                                      The Pima Indians may be genetically predisposed to diabetes (Hanson, Ehm et al.
                                      1998), and it was noted that their diabetic rate was 19 times that of a typical town in
                                      Minnesota (Knowler, Bennett et al. 1978). The National Institute of Diabetes and
                                      Digestive and Kidney Diseases of the NIH originally owned the Pima Indian Diabetes
                                      Database (PIDD). In 1990 it was received by the UC-Irvine Machine Learning
                                      Repository and can be downloaded at <a href='http://www.ics.uci.edu/~mlearn/MLRepository.html'
                                      target='_blank'>www.ics.uci.edu/~mlearn/MLRepository.html</a>. The
                                      database has n=768 patients each with 9 numeric variables: <br><br>
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
                                      </span></p><br>
                                      
                                      <h2>Acknowledgements</h2>
                                      <p style=\"width:800px;text-align:justify\"><span style=\"color:#000000;font-size:16px\">
                                      This application is based on the package <a href='http://www.stat.washington.edu/mclust/' 
                                      target='_blank'>mclust</a>, and a large part of the source code is inspired by the work 
                                      done by the mclust's authors.<br><br>

                                      Copyright © Jens Hooge 2014. All Rights Reserved.</span></p>"
                                      )
                        )
            )
        )
    )
))