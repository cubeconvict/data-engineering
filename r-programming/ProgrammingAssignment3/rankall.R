## NOTE: For the purpose of this part of the assignment
## (and for eficiency), your function should NOT call
## the rankhospital function from the previous section.

getrankhospital <- function(state, outcome.index, rank.index="best", mysplitdata) {
     ## Read outcome data



     # Check to see if the state argument being passed is in the state.abb list
     if (!is.element(state, state.abb)) {
          stop("invalid state")
     }

     mystate.data <- mysplitdata[[state]]


     ## Need to replace text "Not Available" with an NA
     mystate.data [mystate.data == "Not Available"] <- NA
     #print(mystate.data)

     ordered.data <- mystate.data[order(mystate.data[,outcome.index]),]


     ##initialize a variable for picking the top row
     if (rank.index == "best"){
          row.index <- 1
     }

     if (rank.index == "worst"){
          ## if you are asked to return the worst, you need
          ## to reorder the matrix to have the worst on top and NAs on the bottom
          myvar <- mystate.data[,outcome.index]
          ordered.data <- mystate.data[order(myvar, na.last = TRUE, decreasing = TRUE),]
          row.index <- 1
     }
     else {
          row.index <- rank.index
     }


     ## Check that row index is
     ## not greater than number of hospitals in the state
     if (row.index > nrow(mystate.data)){
          hospital <- "NA"
     }
     else {
          ## Return hospital name in that state with the given rank
          hospital <- ordered.data[row.index,2]
     }
     ## 30-day death rate
     return(hospital)

}

#############################################


rankall <- function(outcome, num = "best", datapath="rprog-data-ProgAssignment3-data/outcome-of-care-measures.csv") {

     ## Read outcome data

     ## Check that state and outcome are valid
     #################
     ## Start here all processes moved out of subroutine
     ## Check that state and outcome are valid

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

     ## Read outcome data
     mydata <- read.csv(datapath, colClasses = "character")
     my.split.data <- split(mydata, mydata$"State")


     ###########################
     hospital.matrix <- NULL
     ## For each state, find the hospital of the given rank
     for (i in state.abb){
          state.vector <- c(getrankhospital(i, outcome.index, num, my.split.data), i)
          hospital.matrix <- rbind(hospital.matrix, state.vector)
     }
     # row.names(hospital.matrix, )
     ## Return a data frame with the hospital names and the
     ## (abbreviated) state name
     colnames(hospital.matrix) <- c("hospital","state")
     state.rows <- hospital.matrix[,2]
     rownames(hospital.matrix) <- state.rows
     hospital.matrix <- hospital.matrix[order(hospital.matrix[,2]),]
     hospital.matrix <- as.data.frame(hospital.matrix)

     return(hospital.matrix)

}

testrankall <- function(){
     head(rankall("heart attack", 20), 10)
     tail(rankall("pneumonia", "worst"), 3)
     tail(rankall("heart failure"), 10)

}