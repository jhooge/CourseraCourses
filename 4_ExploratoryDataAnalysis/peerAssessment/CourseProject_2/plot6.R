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
losAngeles <- "06037"
data <- subsetted[subsetted$type == "ON-ROAD" & (subsetted$fips == baltimore | 
                                                 subsetted$fips == losAngeles), ]

png(file="plot6.png", width=480, height=480)
par(bg=NA, mfrow=c(1,1)) 
ggplot(data, aes(x=data$year, y=log(data$Emissions), col=data$fips)) + 
  geom_boxplot() +
  labs(title = "Motor Vehicle Emissions\nBaltimore and Los Angeles") +
  labs(x = "Year", y = expression("log "* PM[2.5])) + 
  scale_color_discrete(name ="City", labels=c("Los Angeles", "Baltimore"))
dev.off()

