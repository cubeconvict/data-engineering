rankhospital <- function(state, outcome, num = "best", datapath="rprog-data-ProgAssignment3-data/outcome-of-care-measures.csv") {
     ## Read outcome data

     ## Check that state and outcome are valid



     ## Read outcome data
     mydata <- read.csv(datapath, colClasses = "character")
     s <- split(mydata, mydata$"State")

     ## Check that state and outcome are valid
     # Check to see if the state argument being passed is in the state.abb list
     if (!is.element(state, state.abb)) {
          stop("invalid state")
     }

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

     mystate.data <- s[[state]]


     ## Need to replace text "Not Available" with an NA
     mystate.data [mystate.data == "Not Available"] <- NA
     #print(mystate.data)

     ordered.data <- mystate.data[order(mystate.data[,outcome.index]),]


     ##initialize a variable for picking the top row
     if (num == "best"){
          row.index <- 1
     }

     if (num == "worst"){
          ## if you are asked to return the worst, you need
          ## to reorder the matrix to have the worst on top and NAs on the bottom
          myvar <- mystate.data[,outcome.index]
          ordered.data <- mystate.data[order(myvar, na.last = TRUE, decreasing = TRUE),]
          row.index <- 1
     }
     else {
          row.index <- num
     }

     ## Return hospital name in that state with the given rank
     hospital <- ordered.data[row.index,2]

     ## 30-day death rate
     return(hospital)

}

testrankhospital <- function(){
     print(rankhospital("TX", "heart failure", 4))
     print(rankhospital("MD", "heart attack", "worst"))
     print(rankhospital("MN", "heart attack", 5000))
     print(rankhospital("NC", "heart attack", "worst"))
}





