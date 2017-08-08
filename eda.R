getwd()
#generate connection to DB
source("./setup/connect.R")
#load packages for data analysis
library(data.table)
library(dplyr)
library(ggplot2)

dbDisconnect(conAPA)


#execute query to bring in one day of data



#execute query to bring in PTP edits

ptp <- dbGetQuery(conAPA, "select    /*+ parallel */
                   col1,
                   col2
                   from dss.ptp_practitioner
                   where part_effdt = '01-JUL-2017'
                   and deletion_dt > '01-JUL-2014'
                   or part_effdt = '01-JUL-2017'
                   and deletion_dt is null")

rm(claims)
claims <- dbGetQuery(conAPA, "select    /*+ parallel */
                             *
                             from      dss.t_ca_icn_20170731_proc 
                             where     dte_fdos between '01-JUL-2014' and '30-JUN-2017'")


head(claims)
head(ptp)

names(claims) <- c("sakclaims", "fromdos", "procs")
names(ptp) <- c("claim1", "claim2")

a <- ptp$claim1
b <- ptp$claim2

nrow(ptp)
i <- 1
a[[i]]
data <- data.table()
for (i in length(a)) {
  baddies <- filter(claims, grepl(a[i], procs, fixed=TRUE) & grepl(b[i], procs, fixed=TRUE))
  if (nrow(baddies) > 1) {
    baddies$a <- a[i]
    baddies$b <- b[i]
    data <- rbind(data, baddies)
  }
}

str(data)

filter(ptp, claim1 == "38500" & claim2 == "J2001")


baddies <- filter(claims, grepl(ptp$claim1, procs, fixed=TRUE) & grepl(ptp$claim2, procs, fixed=TRUE))
str(baddies)



#setting them up as data.tables is unnecessary, performance wise
rm(claimDT, ptpDT)

claimDT <- data.table(claims)
ptpDT <- data.table(ptp)

claimDT[procs %like% ptpDT$claim1 & procs %like% ptpDT$claim2]

#plot claims distribution



#run match on PTP edits and raw data