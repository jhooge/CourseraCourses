plot4 <- function(data, destfile) {
  png(file=destfile, width=480, height=480)
  par(bg=NA, mfcol=c(2, 2)) 
  
  plot(data$Date, data$Global_active_power, 
       type="l", 
       xlab="", ylab="Global Active Power (kilowatts)")
  
  plot(data$Date, data$Sub_metering_1,  type="l", col="black", 
       xlab="", ylab="Energy sub metering")
  lines(data$Date, data$Sub_metering_2, type="l", col="red")
  lines(data$Date, data$Sub_metering_3, type="l", col="blue")
  legend("topright", lty=1, col=c("black", "red", "blue"), 
         legend=colnames(data[6:8]), bty="n")
  
  plot(data$Date, data$Voltage, type="l", xlab="datetime", ylab="Voltage")
  
  plot(data$Date, data$Global_reactive_power, type="l",
       ylim=c(0,0.5),
       xlab="datetime", ylab="Global_reactive_power")
  
#   dev.copy(png, file = destfile)
  dev.off()
}