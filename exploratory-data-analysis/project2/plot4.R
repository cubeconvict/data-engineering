# Plot number 4

# Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?


read.Interpret <- function() {
  
  
  ## This first line will likely take a few seconds. Be patient!
  NEI <- readRDS("summarySCC_PM25.rds")
  SCCdata <- readRDS("Source_Classification_Code.rds")
  
  #head(NEI)
  #head(SCC)
  
  isit <- grepl("Coal|coal", SCCdata$EI.Sector)
  
  codes <- subset(SCCdata$SCC, isit, drop=FALSE)
  
  coal.data <- subset(NEI, NEI$SCC %in% codes)
  cat("Total data", dim(NEI),"\n")
  cat("Data from Coal sources", dim(coal.data),"\n")
  
  return(coal.data)
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
  
  g <- qplot(year, Emissions, data=mydata)
  g <- g + geom_smooth(method="lm")
  g <- g + ylab("Mean Emissions from Coal (all regions, by source)")
  g <- g + coord_cartesian(ylim = c(0,500))
  print(g)
  dev.off()
  
  
  cat(outputfilename, "written to disc\n")
  
}

#the main function
coal.data <- read.Interpret()

coal.data.aggregated <- aggregate(coal.data[, 'Emissions'], by=list(coal.data$year, coal.data$SCC), FUN="mean")

colnames(coal.data.aggregated) <- c("year", "SCC", "Emissions")


outputfilename="plot4.png"
createmyplot(coal.data.aggregated, outputfilename)

rm(list = ls())