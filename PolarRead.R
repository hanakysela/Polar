# 2015_11_01

# reads csv and tcx files, does some merging, cleaning and saving
# THE BASIC FUNCTION

PolarRead<-function(x) {
  
        library("XML")
        library("lubridate")
  
  
  #### READ + MODIFY INDIVIDUAL FILE'S TRACKPOINTS TCX ####
  path_in <- "C:/Users/Hana/Dropbox/Polar tcx/"
  path_out <- "C:/Users/Hana/Dropbox/Polar tcx/Polar_R_dataframes+infos/"

  cat("\n", "Working on", x, "\n")
    
  cat("..........Reading and parsing the tcx", "\n")
  a <- paste(paste(path_in, x, sep = ""), "tcx", sep = ".")

  doc = xmlParse(a)
  
  xmlToDataFrame(nodes <- getNodeSet(doc, "//ns:Trackpoint", "ns"))
  mydf  <- plyr::ldply(nodes, as.data.frame(xmlToList)) #that time consuming part
  
  # drop the sensor information
  mydf$value.SensorState <- NULL
  
  # human readable column names
  names(mydf)[names(mydf) == 'value.Time'] <- 'when'
  names(mydf)[names(mydf) == 'value.AltitudeMeters'] <- 'altitude'
  names(mydf)[names(mydf) == 'value.DistanceMeters'] <- 'distance'
  names(mydf)[names(mydf) == 'value.Value'] <- 'HR'
  names(mydf)[names(mydf) == 'value.Position.LatitudeDegrees'] <- 'lat'
  names(mydf)[names(mydf) == 'value.Position.LongitudeDegrees'] <- 'long'
  
  
  
  #change classes
  
  mydf$when <- gsub('.{5}$', '', mydf$when)
  mydf$when <- as.POSIXct(mydf$when, format = "%Y-%m-%dT%H:%M:%S")
  
  if("altitude" %in% colnames(mydf)) 
  {mydf$altitude<-as.numeric(sub(",", ".", mydf$altitude, fixed = TRUE))
  mydf$lat<-as.numeric(sub(",", ".", mydf$lat, fixed = TRUE))
  mydf$long<-as.numeric(sub(",", ".", mydf$long, fixed = TRUE))}
  
  if("distance" %in% colnames(mydf)) 
  {mydf$distance<-as.numeric(sub(",", ".", mydf$distance, fixed = TRUE))}
  
  if("HR" %in% colnames(mydf)) 
  {mydf$HR<-as.integer(sub(",", ".", mydf$HR, fixed = TRUE))}
  
  
  
  
  #### READ + MODIFY INDIVIDUAL FILE'S DATA CSV ####
  
  cat("..........Reading and modifying the csv in Myinfo", "\n")
  a <- paste(paste(path_in, x, sep = ""), "csv", sep = ".")
  
  ### MYINFO
  
  myinfo<-read.csv(a, header = TRUE, nrows = 1)
  
  # drop the name and "X" column information
  myinfo$Name <- NULL      
  myinfo$X <- NULL  
  
  # name the columns
  names(myinfo) <- c("sport", "date", "start", "duration", "total.dist", "average.HR", "average.speed", "max.speed", "average.pace", "max.pace", "calories", "fat.percent", "average.cadence", "average.stride.length", "running.index", "trainload", "ascent", "descent", "notes", "height", "weight", "max.HR", "sit.HR", "VO2max")
  
  # assign correct class
  myinfo$when = paste(myinfo$date, myinfo$start, sep= " ")
  myinfo$when <- as.POSIXct(myinfo$when, format =  "%d.%m.%Y %H:%M:%S")
  
  myinfo$duration.s <- period_to_seconds(hms(myinfo$duration))
  
  # drop the obsolete date and start columns
  myinfo$date <- NULL      
  myinfo$start <- NULL
  
  # reorder by columns
  myinfo<-myinfo[,c(1, (ncol(myinfo)-1), 2, (ncol(myinfo)), 3:(ncol(myinfo)-2))]
  
  # save the info file for later
  write.csv(myinfo, paste(paste(path_out, x, sep = ""), "_Info.csv", sep = ""), row.names=FALSE)
  
  ### CSV
  
  cat("..........Reading and modifying the csv in Mycsv", "\n")
  mycsv<-read.csv(a, skip = 2)
  
  # drop the sample rate and "X" column information
  mycsv$Sample.rate <- NULL
  mycsv$X <- NULL
  
  # name the columns
  names(mycsv) <- c("time", "HR", "speed.kmh", "pace.minkm", "cadence", "altitude", "stride.length", "distance", "temperature", "power")
  
  # drop info about stride length, cadence and power (I do not have devices to record that)
  mycsv$cadence <- NULL
  mycsv$stride.length <- NULL
  mycsv$power <- NULL
  
  # assign correct class
  mycsv$time.s <- period_to_seconds(hms(mycsv$time))
  mycsv$pace <- period_to_seconds(hms(paste("00", mycsv$pace.minkm)))/60
  
  # reorder by columns
  mycsv<-mycsv[,c(1, 8, 6, 3, 4, 9, 2, 5, 7)]
  
  
  
 
  #### MERGE MYCSV + MYDF ####
  
  # possible removal of the last row in mydf or mycsv (both cases have been observed)
  cat("..........Mergin Mycsv and mydf", "\n")
  
  if(nrow(mydf)>nrow(mycsv)) {
    myNEWdf<-mydf[-nrow(mydf),]  
  }else{
    myNEWdf<-mydf 
  }
  
  if(nrow(mydf)<nrow(mycsv)) {
    myNEWcsv<-mycsv[-nrow(mycsv),]  
  }else{
    myNEWcsv<-mycsv 
  }
  

  # remove duplicit columns   
  myNEWcsv$HR<-NULL
  myNEWcsv$altitude <- NULL
  myNEWcsv$distance <- NULL
  
  # column bind  
  mymerge <- cbind(myNEWdf, myNEWcsv)
  
  # organize columns
  # mymerge<-mymerge[,c(1, 7, 8, 4, 3, 9, 10, 11, 5, 6, 2, 12)]
  
  # save the merged file
  write.csv(mymerge, paste(paste(path_out, x, sep = ""), "_merge.csv", sep = ""), row.names=FALSE)
}