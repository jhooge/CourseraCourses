download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","FNEI_data.zip")
unzip("FNEI_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
data <- merge(NEI, SCC, by="SCC")
data <- data[order(data$year), ]

data <- subset(data, select=c("year", "Emissions", "fips", "type", 
                              "SCC.Level.Three", "SCC.Level.Four"))
data$fips <- as.factor(data$fips)
data$type <- as.factor(data$type)
data$year <- as.factor(data$year)

baltimore <- "24510"
data <- aggregate(Emissions ~ year, subsetted[subsetted$fips == baltimore, ], sum)

png(file="plot2.png", width=480, height=480)
par(bg=NA, mfrow=c(1,1)) 
barplot(data$Emissions, xlab="Year", ylab="Emission", names.arg=data$year)
title(main = "Total PM2.5 Emission (Baltimore)", font.main = 4)
dev.off()