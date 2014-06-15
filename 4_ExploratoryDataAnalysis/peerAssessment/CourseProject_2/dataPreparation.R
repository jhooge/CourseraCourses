NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
data <- merge(NEI, SCC, by="SCC")
data <- data[order(data$year), ]

baltimore <- "24510"
losAngeles <- "06037"

subsetted <- subset(data, select=c("year", "Emissions", "fips", "type", 
                                   "SCC.Level.Three", "SCC.Level.Four"))
subsetted$fips <- as.factor(subsetted$fips)
subsetted$type <- as.factor(subsetted$type)
subsetted$year <- as.factor(subsetted$year)
coalCombLevels <- levels(data$SCC.Level.Four)[grepl("Coal", levels(data$SCC.Level.Four)) & 
                                              grepl("Combustion", levels(data$SCC.Level.Four))]

data1 <- aggregate(Emissions ~ year, subsetted, sum)
data2 <- aggregate(Emissions ~ year, subsetted[subsetted$fips == baltimore, ], sum)
data3 <- subsetted[subsetted$fips == baltimore, ]
data4 <- subsetted[subsetted$SCC.Level.Four %in% coalCombLevels, ]

data5 <- subsetted[subsetted$type == "ON-ROAD" & subsetted$fips == baltimore, ]
data6 <- subsetted[subsetted$type == "ON-ROAD" & (subsetted$fips == baltimore | 
                                                  subsetted$fips == losAngeles), ]

#   png(file=destfile, width=480, height=480)
#   par(bg=NA, mfrow=c(1,1)) 
barplot(data1$Emissions, xlab="Year", ylab="Emission", names.arg=grouped$year)
title(main = "Total PM2.5 Emission", font.main = 4)
#   dev.off()

#   png(file=destfile, width=480, height=480)
#   par(bg=NA, mfrow=c(1,1)) 
barplot(data2$Emissions, xlab="Year", ylab="Emission", names.arg=grouped$year)
title(main = "Total PM2.5 Emission (Baltimore)", font.main = 4)
#   dev.off()

##  png(file=destfile, width=480, height=480)
##  par(bg=NA, mfrow=c(1,1)) 
ggplot(data3, aes(x=data3$year, y=log(data3$Emissions), col=data3$type)) + 
  geom_boxplot(notch=TRUE) +
  labs(title = "Emission Types (Baltimore)") +
  labs(x = "Year", y = expression("log "* PM[2.5])) + 
  scale_colour_brewer(name = "Types")
##  dev.off()

##  png(file=destfile, width=480, height=480)
##  par(bg=NA, mfrow=c(1,1)) 
ggplot(data4, aes(x=data4$year, y=log(data4$Emissions), col=data4$SCC.Level.Four)) + 
  geom_boxplot() +
  labs(title = "Coal Combustion Emissions (USA)") +
  labs(x = "Year", y = expression("log "* PM[2.5])) + 
  opts(legend.direction = "vertical", legend.position = "bottom", legend.box = "vertical") +
  scale_colour_brewer(name = "Coal Combustion")
## dev.off()

##  png(file=destfile, width=480, height=480)
##  par(bg=NA, mfrow=c(1,1)) 
ggplot(data5, aes(x=data5$year, y=log(data5$Emissions), col=data5$SCC.Level.Three)) + 
  geom_boxplot() +
  labs(title = "Motor Vehicle Emissions\nBaltimore") +
  labs(x = "Year", y = expression("log "* PM[2.5])) + 
  scale_color_discrete(name ="Vehicle Type")
## dev.off()

##  png(file=destfile, width=480, height=480)
##  par(bg=NA, mfrow=c(1,1)) 
ggplot(data6, aes(x=data6$year, y=log(data6$Emissions), col=data6$fips)) + 
  geom_boxplot() +
  labs(title = "Motor Vehicle Emissions\nBaltimore and Los Angeles") +
  labs(x = "Year", y = expression("log "* PM[2.5])) + 
  scale_color_discrete(name ="City", labels=c("Los Angeles", "Baltimore"))
## dev.off()
  
  
