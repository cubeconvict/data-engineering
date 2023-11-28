# You should create one R script called run_analysis.R that does the following.
# 1) Merges the training and the test sets to create one data set.
# 2) Extracts only the measurements on the mean and standard deviation for each measurement.
# 3) Uses descriptive activity names to name the activities in the data set
# 4) Appropriately labels the data set with descriptive variable names.
# 5) From the data set in step 4, creates a second, independent tidy data set with the average of
# each variable for each activity and each subject.

##original codebook http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

getdata <- function () {
     #download the data from the remote location and unzip the files

     if (!file.exists("data")){
          dir.create("data")
     }

     fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"


     myZip = "./data/projectdata.zip"

     #download the file and name it myzip
     download.file (fileUrl, destfile=myZip)

     #unzip the data package into a temp directory
     unzip(myZip, exdir="./data/temp")
     dateDownloaded <- date()
     print (dateDownloaded)




}



testdimensions <- function(){

     #tell the program where file is found
     print("Featrures File being read")
     featuresfile = "./data/temp/UCI HAR Dataset/features.txt"
     featuresdata <- read.table(featuresfile)
     print(dim(featuresdata))

     #tell the program where file is found
     print("X Training File being read")
     trainxfile = "./data/temp/UCI HAR Dataset/train/X_train.txt"
     trainxdata <- read.table(trainxfile)
     print(dim(trainxdata))

     #Y training file
     print("y Training File being read")
     trainyfile = "./data/temp/UCI HAR Dataset/train/Y_train.txt"
     trainydata <- read.table(trainyfile)
     print(dim(trainydata))


     #X Test File
     print("X Test File being read")
     testxfile = "./data/temp/UCI HAR Dataset/test/X_test.txt"
     testxdata <- read.table(testxfile)
     print(dim(testxdata))

     #Y Test File
     print("Y Test File being read")
     testyfile = "./data/temp/UCI HAR Dataset/test/Y_test.txt"
     testydata <- read.table(testyfile)
     print(dim(testydata))



}

mergedata <- function() {

     #tell the program where the files are
     # features file found
     featuresfile = "./data/temp/UCI HAR Dataset/features.txt"
     # labels file
     activitylabelsfile = "./data/temp/UCI HAR Dataset/activity_labels.txt"
     #x training file
     trainxfile = "./data/temp/UCI HAR Dataset/train/X_train.txt"
     #Y training file
     trainyfile = "./data/temp/UCI HAR Dataset/train/Y_train.txt"

     #X Test File
     testxfile = "./data/temp/UCI HAR Dataset/test/X_test.txt"
     #Y Test File
     testyfile = "./data/temp/UCI HAR Dataset/test/Y_test.txt"
     #subject training file
     trainsubjectfile = "./data/temp/UCI HAR Dataset/train/subject_train.txt"
     #subject Test File
     testsubjectfile = "./data/temp/UCI HAR Dataset/test/subject_test.txt"


     #readntyenfeatures file into memory
     featuresdata <- read.table(featuresfile, )
     #create a new data table with the features as columns
     featuresdata <- t(featuresdata)
     message("Features File transposed")
     print(dim(featuresdata))



     #read the X files
     trainxdata <- read.table(trainxfile)
     message("trainx data")
     print(dim(trainxdata))
     testxdata <- read.table(testxfile)
     message("testxdata")
     print(dim(testxdata))


     #bind the two x files together into a new dataframe
     newxdata <- rbind(testxdata, trainxdata)
     message("Two X files joined")
     print(dim(newxdata))
     #set the column names to the features file
     featurecolumns <- as.vector(featuresdata[2,])
     colnames(newxdata) <- featurecolumns



     #bind the test & train y files together
     testydata <- read.table(testyfile)
     message("Test Y Data")
     print(dim(testydata))
     trainydata <- read.table(trainyfile)
     message("Train Y Data")
     print(dim(trainydata))
     newydata <- rbind(testydata, trainydata)
     message("Two y files joined")
     print(dim(newydata))

     #bind the test&train subject files together
     testsubjectdata <- read.table(testsubjectfile)
     trainsubjectdata <- read.table(trainsubjectfile)
     newsubjectdata <- rbind(testsubjectdata, trainsubjectdata)
     colnames(newsubjectdata) <- c("subject")
     message("Subject data")
     print(dim(newsubjectdata))


     #replace activity labels with text
     activitylabels <- read.table(file=activitylabelsfile)
     activitydata <- merge(newydata, activitylabels)
     colnames(activitydata) <- c("code","activity")
     message("Activity file merged with labels file")
     print(dim(activitydata))

     #add the subject column to the other y columns
     columndata <- cbind(newsubjectdata, activitydata)
     message("subject & columns together")
     print(dim(columndata))

     # we should have:
     # activity, subject

     #so we need to drop unnecessary columns
     # subset the data to only mean and std columns
     message("Subsetting the columns - extracting only columns that contain 'mean' or 'std'")
     selectedcolumns <- newxdata[,grep("mean|std", colnames(newxdata))]
     message("number of selected column")
     print(dim(selectedcolumns))
     print(dim(newxdata))

     #add the activity and subject columns to the selected columns of X data
     results <- cbind(columndata, selectedcolumns)
     message("merged data")
     print(dim(results))

     #write the table to a file for submission
     write.csv(results, file="./data/temp/tidydata.csv")
     return(results)

}

summarizedata <- function(results){


}

project <- function(){
     getdata()
     results <- mergedata()
     summarizedata(results)

}