corr <- function(directory, threshold = 0) {

#      Write a function that takes a directory of data files and a
#      threshold for complete cases and calculates the correlation
#      between sulfate and nitrate for monitor locations where the
#      number of completely observed cases (on all variables) is
#      greater than the threshold. The function should return a
#      vector of correlations for the monitors that meet the
#      threshold requirement. If no monitors meet the threshold
#      requirement, then the function should return a numeric vector
#      of length 0. A prototype of this function follows

     correlations.vector <- numeric()


     ## 'threshold' is a numeric vector of length 1 indicating the
     ## number of completely observed observations (on all
     ## variables) required to compute the correlation between
     ## nitrate and sulfate; the default is 0


     getcors.onefile <- function(filename){
          fromfile <- read.table(filename, header=TRUE, sep = ",")
          x <- fromfile["sulfate"]
          #print(x)
          y <- fromfile["nitrate"]
          #print(y)
          mymatrix <- as.data.frame(c(x,y))
          #print(filename)
          mycors <- cor(x, y, use="complete.obs")
          #print(mycors)
          return(c(mycors))
     }

     getcors.allfiles <- function(matrix.of.filenames) {
          result <- c()
          for(i in 1:nrow(matrix.of.filenames)) {
               name.good.file <- rownames(matrix.of.filenames[i,])
               one.result <- getcors.onefile(name.good.file)
               result <- c(result, one.result)
          }
          return(result)
     }

     ## 'directory' is a character vector of length 1 indicating
     ## the location of the CSV files


     ## create a matrix of data on the number of number of complete
     ## observations in each file
     returned.matrix <- complete(directory)
     ## subset the matrix for only observations over the threshold
     good.subset <- subset(returned.matrix, nobs > threshold)

     #if the subset is zero length, return 0
     rows.in.subset <- nrow(good.subset)
     if (nrow(good.subset) <= 0){
          correlations.vector <- numeric()
     }
     #if subset has entries get the correlations
     if (nrow(good.subset) > 0){
          #create a vector of filenames

          #run the routine on the vector of filenames
          correlations.matrix <- getcors.allfiles(good.subset)
          correlations.vector <- as.list(correlations.matrix)
          correlations.vector <- unlist(correlations.vector)
     }



     ## Return a numeric vector of correlations
     return(correlations.vector)
}