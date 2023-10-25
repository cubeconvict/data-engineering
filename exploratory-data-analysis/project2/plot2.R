# Plot number 2

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? 
# Use the base plotting system to make a plot answering this question.

read.Interpret <- function(data.file="summarySCC_PM25.rds", code.file="Source_Classification_Code.rds") {
  
  
  ## This first line will likely take a few seconds. Be patient!
  NEI <- readRDS("summarySCC_PM25.rds")


  return(NEI)
}

createmyplot <- function(mydata, outputfilename) {
  #x=Global Active Power(kilowatts)
  #y=Frequency
  # Type of graph: Histogram
  
  cat("Creating plot",outputfilename,"\n") 
  
  png(file = outputfilename, width = 480, height = 480) ## Open the PNG Device
  
  
  barplot(baltimore.emissions/1000000, ylab = "PM25 Emissions (millions)", xlab = "Year", main="Baltimore")

  
  cat(outputfilename, "written to disc\n")
  dev.off()
  
}

#the main functtion
NEI <- read.Interpret()
baltimore.emissions <- subset(NEI, fips=="24510"&Pollutant=="PM25-PRI")
baltimore.emissions <- tapply(NEI$Emissions, NEI$year, FUN=sum)
outputfilename="plot2.png"
createmyplot(baltimore.emissions, outputfilename)

rm(list = ls())
