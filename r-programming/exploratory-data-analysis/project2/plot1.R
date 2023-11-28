# Plot number 1

# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission from 
# all sources for each of the years 1999, 2002, 2005, and 2008.

read.Interpret <- function(data.file="summarySCC_PM25.rds", code.file="Source_Classification_Code.rds") {
  
  
  ## This first line will likely take a few seconds. Be patient!
  NEI <- readRDS("summarySCC_PM25.rds")


  return(NEI)
}

NEI <- read.Interpret()
total.emissions <- tapply(NEI$Emissions, NEI$year, FUN=sum)

outputfilename <- "plot1.png"


png(file = outputfilename, width = 480, height = 480) ## Open the PNG Device

cat("Creating plot",outputfilename,"\n") 

barplot(total.emissions/1000000, xlab="Year", ylab="Total pm2.5 Emissions (millions)")
cat(outputfilename, "written to disc\n")


dev.off()

#rm(list = ls())

