# Plot number 3

# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
# which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
# Which have seen increases in emissions from 1999–2008? 
# Use the ggplot2 plotting system to make a plot answer this question.


read.Interpret <- function(data.file="summarySCC_PM25.rds", code.file="Source_Classification_Code.rds") {
  
  
  ## This first line will likely take a few seconds. Be patient!
  NEI <- readRDS("summarySCC_PM25.rds")


  return(NEI)
}

createmyplot <- function(mydata, outputfilename) {
  #x=Global Active Power(kilowatts)
  #y=Frequency
  # Type of graph: Histogram
  
  library(ggplot2)
  
  cat("Creating plot",outputfilename,"\n") 
  
  png(file = outputfilename, width = 480, height = 480) ## Open the PNG Device
  
  
  # create four plots of Baltimore emissions based upon point type
  # point, nonpoint, onroad, nonroad
  
  g <- qplot(year, Emissions, data=mydata, facets=.~type, geom = "point")
  g <- g + geom_smooth(method="lm")
  g <- g + coord_cartesian(ylim = c(0,100))
  print(g)
  dev.off()
  
  
  cat(outputfilename, "written to disc\n")
  
}

#the main functtion
NEI <- read.Interpret()
baltimore.emissions <- subset(NEI, fips=="24510"&Pollutant=="PM25-PRI")
outputfilename="plot3.png"
createmyplot(baltimore.emissions, outputfilename)

rm(list = ls())

