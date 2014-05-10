plot3 <- function(data, destfile) {
  png(file=destfile, width=480, height=480)
  par(bg=NA, mfrow=c(1,1)) 
  plot(data$Date, data$Sub_metering_1,  type="l", col="black", 
       xlab="", ylab="Energy sub metering")
  lines(data$Date, data$Sub_metering_2, type="l", col="red")
  lines(data$Date, data$Sub_metering_3, type="l", col="blue")
  legend("topright", lty=1, col=c("black", "red", "blue"), 
         legend=colnames(data[6:8]))
#   dev.copy(png, file = destfile)
  dev.off()
}