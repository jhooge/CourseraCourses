library(shiny)
library(mlbench)

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
            selectInput("x", label="X Variable", choices=names(data),
                        selected=names(data)),
            selectInput("y", label="Y Variable", choices=names(data),
                        selected=names(data)),
            sliderInput("clusters", "Number of Clusters", 1, 9, 2, step = 1),
            helpText("Change the the number of clusters to perform a BIC 
                     (Bayesian Information Criterion) based cluster analysis. BIC
                     values are compared to optimize parameters for up to 10
                     components. The ellipses superimposed on the classification 
                     and uncertainty plots correspond to the covariances 
                     of the components. While in the classification plots colors indicate 
                     class identity, point size in the uncertainty plots indicate the risk
                     of misclassification. These misclassifications are seen in black in
                     the error plots.
                     ")
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(id="modelSelection", type="pills", position="above",
                        tabPanel(title="Classification",
                                 plotOutput("classification")
                        ),
                        tabPanel(title="Uncertainty",
                                 plotOutput("uncertainty")),
                        tabPanel(title="Errors",
                                 plotOutput("errors")),
                        tabPanel(title="Density Estimation",
                                 plotOutput("density")),
                        tabPanel(title="ModelSelection",
                                 plotOutput("modelSelection"),
                                 verbatimTextOutput("modelSummary"),
                                 dataTableOutput("covStructures")),
                        tabPanel(title="About",
                                 HTML("<br>
                                      <p style=\"width:500px;text-align:justify\"><span style=\"color:#000000;font-size:16px\">
                                      <span style = \"font-weight:bold\">About</span><br><br>
                                      This tool has been created as part of the Coursera Course \"Developing Data Products\". 
                                      It uses Mixtures of Gaussians for a Model Based Cluster analysis of the Pima Indian Diabetes Database.
                                      Up to ten components can be chosen for the mixtures. The supervised classification result, together 
                                      with classification uncertainty and errors can be observed in 2D projections of the feature space.
                                      Densities for each feature is estimated and provides an overview of the feature space.
                                      The best model is chosen over all components and 10 different covariance structures, 
                                      which determine the volume, shape and orientation of the gaussian hyper-spheres fitted to the data.
                                      The optimal fit is determined by the Bayesian Information Criterion (BIC). 
                                      When fitting models, it is possible to increase the likelihood by adding parameters, 
                                      but doing so may result in overfitting. The BIC resolves this problem by introducing a 
                                      penalty term for the number of parameters in the model.
                                      
                                      <br><br>
                                      <span style = \"font-weight:bold\">The Pima Indian Diabetic Database (PID)</span><br><br>
                                      The Pima Indians may be genetically predisposed to diabetes (Hanson, Ehm et al.
                                      1998), and it was noted that their diabetic rate was 19 times that of a typical town in
                                      Minnesota (Knowler, Bennett et al. 1978). The National Institute of Diabetes and
                                      Digestive and Kidney Diseases of the NIH originally owned the Pima Indian Diabetes
                                      Database (PIDD). In 1990 it was received by the UC-Irvine Machine Learning
                                      Repository and can be downloaded at www.ics.uci.edu/~mlearn/MLRepository.html. The
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
                                      </br></br>
                                      Copyright © Jens Hooge 2014. All Rights Reserved.
                                      <br><br>
                                      </span></p>")
                        )
            )
        )
    )
))