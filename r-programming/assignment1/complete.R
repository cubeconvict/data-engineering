complete <- function(directory, id = 1:332) {
     ## 'directory' is a character vector of length 1 indicating
     ## the location of the CSV files


     ## create a vector of all csv files in the directory
     # Retrieve a vector of all the filenames
     files <- list.files(path = directory, pattern = "*.csv", full.names = TRUE, recursive=FALSE)

     ## To debug whether you are getting the right list of files
     #print(files)

     ## 'id' is an integer vector indicating the monitor ID numbers
     ## to be used

     files.subset <- files[id]

     ## create a function for determining the number of complete cases in a file

     get.complete <- function(x){
          #Get a vector of all complete entries from a given file
          fromfile <- read.table(x, header=TRUE, sep = ",")
          #subset the pollutant values

          complete.sets <- complete.cases(fromfile)
          if (min(fromfile["ID"])== max(fromfile["ID"])){
               sensor.id <- (min(fromfile["ID"]))
          }
          ## To debug if you are getting the sensor.id
          #print (sensor.id)
          data.vector <- c(sensor.id, sum(complete.sets))
          #print(class(data.vector))
          return (data.vector)

     }



     ## Return a data frame of the form:
     ## id nobs
     ## 1  117
     ## 2  1041
     ## ...
     ## where 'id' is the monitor ID number and 'nobs' is the
     ## number of complete cases

     #iterate across all the files and get the number of complete values

     all.pollutants <- sapply(files.subset, get.complete, simplify=FALSE)
     all.pollutants.matrix <- do.call(rbind, all.pollutants)
     #print(dimnames(all.pollutants))
     colnames(all.pollutants.matrix) <- c("id", "nobs")
     myrows <- nrow(all.pollutants.matrix)
     #rownames(all.pollutants.matrix) <- c(1:myrows)
     #print(get.complete(files[1]))

     return(as.data.frame(all.pollutants.matrix))

}