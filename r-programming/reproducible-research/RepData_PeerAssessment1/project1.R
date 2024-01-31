#Global variables
csvpath="./data/temp/activity.csv"


# 
# 1)Load the data (i.e. read.csv())
# 2)Process/transform the data (if necessary) into a format suitable for your analysis

getdata <- function () {
  #download the data from the remote location and unzip the files
  
  if (!file.exists("data")){
    dir.create("data")
  }
  
  fileUrl <- "https://github.com/cubeconvict/RepData_PeerAssessment1/raw/master/activity.zip"
  
  
  myZip = "./data/activity.zip"
  
  #download the file and name it myzip
  download.file (fileUrl, destfile=myZip)
  
  #unzip the data package into a temp directory
  unzip(myZip, exdir="./data/temp")
  dateDownloaded <- date()
  print (dateDownloaded)
  
  mydata <- read.csv(csvpath)
  mydata$date <- as.Date(mydata$date)
  
  #head(mydata)
  
  return(mydata)
}



#For this part of the assignment, you can ignore the missing values in the dataset.
# 1) Make a histogram of the total number of steps taken each day

myhistogram <- function(mydata, summary.data){
  summary.data <- tapply(mydata$steps, mydata$date, FUN=sum)
  
  outputfilename <- "sum-of-steps.png"
  
  
  #png(file = outputfilename, width = 480, height = 480) ## Open the PNG Device
  
  cat("Creating plot",outputfilename,"\n") 
  
  barplot(summary.data, xlab="Day", ylab="Total steps")
  cat(outputfilename, "written to disc\n")
  return(summary.data)
  #dev.off()
}
# 2) Calculate and report the mean and median total number of steps taken per day

get.means.data <- function(mydata){
  means.data <- tapply(mydata$steps, mydata$date, FUN=mean, na.rm=TRUE)
  return(means.data)
}

get.summary.data <- function(mydata){
  x <- mydata$steps
  factor <- mydata$date
  mean.median <- function(x) c(mean = mean(x), median = median(x))
  summary.data <- simplify2array(tapply(x, factor, mean.median))
  return(summary.data)
}

get.medians.data <- function(mydata) {
  medians.data <- tapply(mydata$steps, mydata$date, median, na.rm=TRUE)
  #sapply(mydata, function(i) tapply(df[[i]], df$group, sd, na.rm=TRUE))
  
  return(medians.data)
}

# What is the average daily activity pattern?
# Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)
# Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

plot.daily.activity <- function(mydata) {
  daily.activity.data <- tapply(mydata$steps, mydata$interval, FUN=mean, na.rm=TRUE)
  class(daily.activity.data)
  
  plot(daily.activity.data, type="l", main='Daily Activity', xlab = "Interval", ylab="Average number of steps")
  return(daily.activity.data)
}


# Imputing missing values
# Note that there are a number of days/intervals where there are missing values (coded as NA). The presence of missing days may introduce bias into some calculations or summaries of the data.
# 1) Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)
# 2) Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. 
# For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.
# 3) Create a new dataset that is equal to the original dataset but with the missing data filled in.
# 4) Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

# Are there differences in activity patterns between weekdays and weekends?
# For this part the weekdays() function may be of some help here. Use the dataset with the filled-in missing values for this part.
# Create a new factor variable in the dataset with two levels -- "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.
# Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). The plot should look something like the following, which was created using simulated data:



  mydata <- getdata()
#   myhistogram(mydata)
  #steps.summary <- summarizedata(mydata)
  #print(steps.summary)
  
#   means.data <- get.means.data(mydata)
#   medians.data <- get.medians.data(mydata)
#   means.medians.matrix <- cbind(means.data, medians.data)
#   summary.data <- get.summary.data(mydata)
  FOO <- plot.daily.activity(mydata)
  #return(means.data)
#   return(medians.data)
#   return(mydata)
  return(foo)
