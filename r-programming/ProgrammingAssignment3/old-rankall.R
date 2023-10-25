## NOTE: For the purpose of this part of the assignment
## (and for eficiency), your function should NOT call
## the rankhospital function from the previous section.

rankall <- function(outcome, num = "best", datapath="rprog-data-ProgAssignment3-data/outcome-of-care-measures.csv") {


     ## Read outcome data
     mydata <- read.csv(datapath, colClasses = "character")


     # Create the list of valid outcomes
     valid.outcomes <- c("heart attack", "heart failure", "pneumonia")

     #check to see if outcome is valid, throw error if not
     if (!is.element(outcome, valid.outcomes)){
          stop("invalid outcome")
     }

     #Column indices in the file are not the simple text being fed
     if (outcome == "heart attack") {
          outcome.index = 11
     }
     if (outcome == "heart failure") {
          outcome.index = 17
     }
     if (outcome == "pneumonia") {
          outcome.index = 23
     }



     ## Need to replace text "Not Available" with an NA
     mydata [mydata == "Not Available"] <- NA

     ## order the data
     ordered.data <- mydata[order(mydata[,outcome.index]),]

     ##initialize a variable for picking the appropriate row
     if (num == "best"){
          row.index <- 1
     }

     if (num == "worst"){
          ## if you are asked to return the worst, you need
          ## to reorder the matrix to have the worst on top and NAs on the bottom
          myvar <- mydata[,outcome.index]
          ordered.data <- mydata[order(myvar, na.last = TRUE, decreasing = TRUE),]
          row.index <- 1
     }
     else {
          row.index <- num
     }

     ## split the data
     s <- split(ordered.data, ordered.data$"State")

     ## pick the right row from each split

     hospital.matrix <- matrix(data = NA, nrow = 50, ncol=50, dimnames=NULL)

     alaska <- s["AK"]
     print(alaska[2,])

     for (i in state.abb){
          #bind each state's result to the hospital matrix
          mystate.data <- s[i]
          #get a row, and return the hospital and value columns
          myvector <- mystate.data[row.index]
          hospital.matrix <- rbind(hospital.matrix, myvector)
     }

     ## order the matrix by the best value

     ## Eliminate the value column from the output

     #row.names(hospital.matrix) <- hospital.matrix[,"State"]


     # return the rest of the list starting at the rank specified by num
     ## For each state, find the hospital of the given rank
     ## Return a data frame with the hospital names and the
     ## (abbreviated) state name

     return(hospital.matrix)

}

testrankall <- function(){
     head(rankall("heart attack", 20), 10)
     tail(rankall("pneumonia", "worst"), 3)
     tail(rankall("heart failure"), 10)

}