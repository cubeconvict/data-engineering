# Plot number 5

# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?


read.Interpret <- function() {
  
  
  ## This first line will likely take a few seconds. Be patient!
  NEI <- readRDS("summarySCC_PM25.rds")
  SCCdata <- readRDS("Source_Classification_Code.rds")
  
  #head(NEI)
  #head(SCC)
  
  baltimore.all.emissions <- subset(NEI, fips=="24510")
  isit <- grepl("vehicle", SCCdata$SCC.Level.Two, ignore.case = TRUE)
  codes <- subset(SCCdata$SCC, isit, drop=FALSE)
  
  baltimore.car.data <- subset(baltimore.all.emissions, baltimore.all.emissions$SCC %in% codes)

  return(baltimore.car.data)
}

createmyplot <- function(mydata, outputfilename) {

  library(ggplot2)
  
  cat("Creating plot",outputfilename,"\n") 
  
  png(file = outputfilename, width = 480, height = 480) ## Open the PNG Device
  
  g <- qplot(mydata$year, mydata$Emissions, data=mydata, geom = "point")
  g <- g + geom_smooth(method="lm", se=FALSE)
  g <- g + ggtitle("Baltimore")
  g <- g + ylab("Total PM25 Emissions from Motor Vehicles")
  g <- g + xlab("Year")
  print(g)
  dev.off()
  
  
  cat(outputfilename, "written to disc\n")
  
}

#the main function
car.data <- read.Interpret()

car.data.aggregated <- aggregate(car.data[, 'Emissions'], by=list(car.data$year, car.data$fips), FUN="sum")
colnames(car.data.aggregated) <- c("year", "fips", "Emissions")


outputfilename="plot5.png"
createmyplot(as.data.frame(car.data.aggregated), outputfilename)

rm(list = ls())
