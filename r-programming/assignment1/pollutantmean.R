pollutantmean <- function(directory, pollutant, id = 1:332) {
     ## 'directory' is a character vector of length 1 indicating
     ## the location of the CSV files

     ## 'pollutant' is a character vector of length 1 indicating
     ## the name of the pollutant for which we will calculate the
     ## mean; either "sulfate" or "nitrate".

     ## 'id' is an integer vector indicating the monitor ID numbers
     ## to be used


     # Retrieve a vector of all the filenames
     files <- list.files(path=directory, pattern="*.csv", full.names=TRUE, recursive=FALSE)

     #function retrieves a vector of all valid pollutant values from a file
     get.pollutant <- function(x){
          #Get a vector of all pollutant entries from a given file
          fromfile <- read.table(x, header=TRUE, sep = ",")
          #subset the pollutant values

          valid.pollutant.values <- !is.na(fromfile[pollutant])
          pollutant.all <- fromfile[pollutant]
          pollutant.values <- pollutant.all[valid.pollutant.values]

          return (pollutant.values)

     }



     #iterate across all the files and get the pollutant values
     all.pollutants <- sapply(files[id], get.pollutant, simplify=TRUE)


     ## Return the mean of the pollutant across all monitors list
     ## in the 'id' vector (ignoring NA values)
     #output <- mean(all.pollutants)
     output <- mean(unlist(all.pollutants))

     return(output)
}