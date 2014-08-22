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
coalCombLevels <- levels(data$SCC.Level.Four)[grepl("Coal", levels(data$SCC.Level.Four)) & 
                                              grepl("Combustion", levels(data$SCC.Level.Four))]
data <- data[data$SCC.Level.Four %in% coalCombLevels, ]

png(file="plot4.png", width=480, height=480)
par(bg=NA, mfrow=c(1,1)) 
ggplot(data, aes(x=data$year, y=log(data$Emissions), col=data$SCC.Level.Four)) + 
  geom_boxplot() +
  labs(title = "Coal Combustion Emissions (USA)") +
  labs(x = "Year", y = expression("log "* PM[2.5])) +
  theme(legend.position="bottom", 
        legend.direction="vertical", 
        legend.title=element_text("Combustion Type"))
dev.off()