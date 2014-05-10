plot1 <- function(data, destfile) {
  png(file=destfile, width=480, height=480)
  par(bg=NA, mfrow=c(1,1)) 
  hist(data$Global_active_power, 
       col="red", main="Global Active Power", 
       xlab="Global Active Power (kilowatts)", 
       xlim=c(0,6),
       ylim=c(0,1200))
#   dev.copy(png, file = destfile)
  dev.off()
}
