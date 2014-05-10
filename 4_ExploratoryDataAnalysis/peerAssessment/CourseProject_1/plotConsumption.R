library(data.table)

source("plot1.R")
source("plot2.R")
source("plot3.R")
source("plot4.R")

#' Merges the fist two columns of the input data frame
#' to a POSIX Date object.
#' 
#' @param data A data frame representing household power consumption data.
#' 
#' @return data.frame{base}
reformatDates <- function(data) {
  data <- subset(data, data$Date %in% c("1/2/2007", "2/2/2007"))
  
  dates <- strptime(paste(data$Date, data$Time), 
                    format="%d/%m/%Y %H:%M:%S", 
                    tz="CEST")
  data <- subset(data, select=colnames(data)[3:ncol(data)])
  data <- cbind(data.frame(dates), data)
  data[ , 2:ncol(data)] <- mapply(as.numeric, data[,2:ncol(data)])
  colnames(data)[1] <- "Date"
  
  return(data)
}

#' This function reads and reformats the input data. It then generates a number of PNG figures
#' for exploratory data analysis and stores them in a user defined directory, thereby ensuring
#' that it exists. 
#' 
#' @note This function expects a zip file called exdata_data_household_power_consumption.zip
#' in the current working directory. 
#' 
#' @param directory The output directory where the plots will be stored
#' 
plotAll <- function(directory) {
  if (!file.exists(directory)){
    dir.create(file.path(directory))
  }
  
  print(sprintf("Reading data"))
  unzip("exdata_data_household_power_consumption.zip")
  data <- fread("household_power_consumption.txt", 
                sep=";",
                na.strings="?",
                colClasses="character")
  print("Reformating input data")
  data <- reformatDates(data)
  
  print("Generating figure plot1.png")
  plot1(data, paste(directory, "plot1.png", sep="/"))
  print("Generating figure plot2.png")
  plot2(data, paste(directory, "plot2.png", sep="/"))
  print("Generating figure plot3.png")
  plot3(data, paste(directory, "plot3.png", sep="/"))
  print("Generating figure plot4.png")
  plot4(data, paste(directory, "plot4.png", sep="/"))
  print("DONE")
  
}

plotAll("myfigures/")

