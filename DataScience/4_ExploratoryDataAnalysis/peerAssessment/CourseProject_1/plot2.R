plot2 <- function(data, destfile) {
  png(file=destfile, width=480, height=480)
  par(bg=NA, mfrow=c(1,1)) 
  plot(data$Date, data$Global_active_power, 
       type="l", 
       xlab="", ylab="Global Active Power (kilowatts)")
  dev.off()
}