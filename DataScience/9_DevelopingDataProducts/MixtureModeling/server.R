library(shiny)
library(mlbench)
library(mclust)
library(caret)

data(PimaIndiansDiabetes2)

# data <- iris[,-5]
# data <- rbind(solTrainX, solTestX)
# data <- data[, 209:228]

data <- PimaIndiansDiabetes2
data <- data[complete.cases(data), ]
response <- data[,9]
data <- data[,-9]


# preProc <- caret::preProcess(data[,-9], method=c("knnImpute"))
# data <- predict(preProc, data[,-9])

model <- mclustBIC(data)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    densities <- reactive({
        c(densityMclust(selectedData()[1]),
          densityMclust(selectedData()[2]))
    })
    
    selectedData <- reactive({
        c(input$x, input$y)
    })
    
    clusters <- reactive({input$clusters})
    
    clusters <- reactive({
        mclust(selectedData(), clusters())
    })
    
    output$classification <- renderPlot({
        modelSummary <- summary(model, data=data, input$clusters)
        coordProj(data=data, dimens=selectedData(), what="classification",
                  parameters = modelSummary$parameters, z = modelSummary$z)
    })
    
    output$uncertainty <- renderPlot({
        modelSummary <- summary(model, data=data, input$clusters)
        coordProj(data=data, dimens=selectedData(), what="uncertainty",
                  parameters = modelSummary$parameters, z = modelSummary$z)
    })
    
    output$errors <- renderPlot({
        modelSummary <- summary(model, data=data, input$clusters)
        coordProj(data=data, dimens=selectedData(), what="errors",
                  parameters = modelSummary$parameters, z = modelSummary$z,
                  truth=response)
    })
    
    output$density <- renderPlot({
        variableDensities <- densityMclust(data)
        plot(variableDensities)  
    })
    
    output$modelSelection <- renderPlot({
        plot(model)
    })
    
    output$modelSummary <- renderPrint({
#         summary(model, data)
        model
    })
    
    output$covStructures <- renderDataTable({
        covarianceStructures <- data.frame(Identifier=c("E", "V","EII", "VII", "EEI", "VEI", "EVI", "VVI", "EEE", "EEV", "VEV", "VVV"),
                                           Distribution=c("univariate", "univariate","spherical", "spherical", "diagonal", "diagonal", "diagonal", "diagonal", "ellipsoidal", "ellipsoidal", "ellipsoidal", "ellipsoidal"),
                                           Volume=c("equal", "variable","equal", "variable", "equal", "variable", "equal", "variable", "equal", "equal", "variable", "variable"),
                                           Shape=c(NA, NA, "equal", "equal", "equal", "equal", "variable", "variable", "equal", "equal", "equal", "variable"),
                                           Orientation=c(NA, NA, NA, NA, "coord. axes", "coord. axes", "coord. axes", "coord. axes", "equal", "variable", "variable", "variable"))
        covarianceStructures
    })
})
