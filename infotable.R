# 2015_11_05

##### PREPARE THE TABLE ####

  cat("..........Preparing the infotable", "\n")

  # create info file from all .info sources (does not take that long)
      path_out <- "C:/Users/hanak/Dropbox/Polar tcx/Polar_R_dataframes+infos/"
      allinfos <- list.files(path=path_out, pattern = "_Info.csv$")
      
      setwd("C:/Users/hanak/Dropbox/Polar tcx/Polar_R_dataframes+infos")
      tables <- lapply(allinfos, read.csv, header = TRUE)
      infotable <- do.call(rbind , tables)
  
  # drop info about stride length and notes
      infotable$average.stride.length <- NULL
      infotable$notes <- NULL

      
#### DATE ####
  # add more date related columns eg. from when = "2015-09-06 10:01:07"
    
    # 2015
        infotable$year <- strftime(infotable$when, "%Y")
       
    # September
        infotable$month <- strftime(infotable$when, "%B")
        
    # 36
        infotable$week <- strftime(infotable$when, "%V")
      
    # Sunday
        infotable$WeekDay <- weekdays(strptime(infotable$when, "%Y-%m-%d" ))
       
    # 10 (hour of start)
        infotable$hour <- strftime(infotable$when, "%H")
        
  # reorder columns (shift "when" to the beginning)
        infotable<-infotable[,c(1, 21, 2:20, 22:27)]
        
#### SAVE ####
        write.csv(infotable, paste(path_out, "infotable.csv", sep = ""), row.names=FALSE)
        cat("..........Infotable saved as csv", "\n")