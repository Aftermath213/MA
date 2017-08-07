getwd()
#generate connection to DB
source("/home/dan/DW/connection.R")
#load packages for data analysis
library(dplyr)
library(ggplot2)
dbDisconnect(conEPM)
#execute query to bring in one day of data



#execute query to bring in PTP edits



#plot claims distribution



#run match on PTP edits and raw data