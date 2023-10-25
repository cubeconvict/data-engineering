# Plot number 6

#Compare emissions from motor vehicle sources in Baltimore City with 
# emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?


read.Interpret <- function() {
  
  
  ## This first line will likely take a few seconds. Be patient!
  NEI <- readRDS("summarySCC_PM25.rds")
  SCCdata <- readRDS("Source_Classification_Code.rds")
  

  two.emissions <- subset(NEI, fips=="24510"|fips=="06037")
  isit <- grepl("vehicle", SCCdata$SCC.Level.Two, ignore.case = TRUE)
  codes <- subset(SCCdata$SCC, isit, drop=FALSE)
  
  car.data <- subset(two.emissions, two.emissions$SCC %in% codes)
  
  car.data <- as.data.frame(lapply(car.data, function(x) {gsub("24510", "Baltimore City", x) }))
  car.data <- as.data.frame(lapply(car.data, function(x) {gsub("06037", "Los Angeles County", x) }))
  

  return(car.data)
}

createmyplot <- function(mydata, outputfilename) {
  #x=Global Active Power(kilowatts)
  #y=Frequency
  # Type of graph: Histogram
  
  library(ggplot2)
  
  cat("Creating plot",outputfilename,"\n") 
  
  png(file = outputfilename, width = 480, height = 480) ## Open the PNG Device
  
  
  # create  plots of Baltimore & LA emissions based upon point type

  

  g <- qplot(year, Emissions, data=mydata, facets = .~fips)
  g <- g + stat_smooth(method = "lm", se = FALSE, lwd=3)
  g <- g + geom_point(aes(color=fips))
  g <- g + ggtitle("Total Emissions from Motor Vehicles")
  print(g)
  dev.off()
  
  
  cat(outputfilename, "written to disc\n")
  
}

#the main function
outputfilename="plot6.png"

car.data <- read.Interpret()
car.data[,'Emissions'] <- as.numeric(car.data[,'Emissions'] )
car.data.aggregated <- aggregate(car.data[, 'Emissions'], by=list( car.data$year, car.data$fips), FUN="mean")
colnames(car.data.aggregated) <- c("year", "fips", "Emissions")

createmyplot(car.data.aggregated, outputfilename)

rm(list = ls())
