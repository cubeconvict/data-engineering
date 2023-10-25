

best <- function(state, outcome, datapath="rprog-data-ProgAssignment3-data/outcome-of-care-measures.csv") {
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

     ## Test line to be sure you've got the right columns
     ## print(colnames(mystate.data[c(11,17,23)]))
     ## print(mystate.data)

     ## Need to replace text "Not Available" with an NA
     mystate.data [mystate.data == "Not Available"] <- NA


     ## Return hospital name in that state with lowest 30-day death rate
     ## column.data <- mystate.data[,outcome.index]
     ## print(column.data)
     row.index <- which.min(as.numeric(mystate.data[,outcome.index]))
     ##
     #min.row.num = apply(mystate.data,2,which.min)

#      a<- cbind(mystate.data, max=apply(mystate.data,2,min),
#            min.row.num = apply(mystate.data,2,which.min) ,
#            min.row.name = names(mystate.data)[apply(mystate.data,1,which.min)]  )
     ##
     hospital <- mystate.data[row.index,2]
     #hospital <- mystate.data[row.index]
     return(hospital)
}


testbest <- function() {
     best("TX", "heart attack")
     best("TX", "heart failure")
     best("MD", "heart attack")
     best("MD", "pneumonia")
     best("BB", "heart attack")
     best("NY", "hert attack")

}

