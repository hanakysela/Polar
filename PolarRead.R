# reads csv and tcx files, does some merging, cleaning and saving
# THE BASIC FUNCTION

# 2015_11_01
# 2016_02_20 no longer dumping info on cadence + changing output csv's naming

PolarRead<-function(x) {
  
        library("XML")
        library("lubridate")

  
#### READ + MODIFY INDIVIDUAL FILE'S DATA CSV (outputs "myinfo" and "mycsv" dataframes) ####
  # every Polar .csv contains header (general one line info about stats - gets aggregated into infotable later)
  
      cat("\n", "Working on", x, "\n")
      
      
        a <- paste(paste(path_in, x, sep = ""), "csv", sep = ".")
  
  ### MYINFO

      cat("..........Preparing data for the Infotable", "\n")
      
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
        
        # naming ...
            # store the sport type name in a variable - later used for naming of files
                sport_type<- paste(myinfo[1,1])
            # leave only the date from the original export file name
                date<-substr(x, 13, 50)
            
        # save the info file for later
            write.csv(myinfo, paste(path_out, paste(date, sport_type, "Info.csv", sep = "_"), sep=""), row.names=FALSE)
  ### CSV
  
      cat("..........Preparing data for each training", "\n")
          
          mycsv<-read.csv(a, skip = 2)
      
      # drop the sample rate and "X" column information
          mycsv$Sample.rate <- NULL
          mycsv$X <- NULL
      
      # name the columns
          names(mycsv) <- c("time", "HR", "speed.kmh", "pace.minkm", "cadence", "altitude", "stride.length", "distance", "temperature", "power")
      
      # assign correct class
          mycsv$time.s <- period_to_seconds(hms(mycsv$time))
          mycsv$pace <- period_to_seconds(hms(paste("00", mycsv$pace.minkm)))/60
      
          
  
#### READ + MODIFY INDIVIDUAL FILE'S TRACKPOINTS TCX  (outputs "mydf" dataframe) ####
  
        path_in <- "C:/Users/Hana/Dropbox/Polar tcx/"
        path_out <- "C:/Users/Hana/Dropbox/Polar tcx/Polar_R_dataframes+infos/"
      
    cat("..........Reading and parsing the tcx - that takes some time", "\n")
        
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
        names(mydf)[names(mydf) == 'value.Cadence'] <- 'cadence'
    
    
    
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
  
      if("cadence" %in% colnames(mydf)) 
        {mydf$HR<-as.integer(sub(",", ".", mydf$cadence, fixed = TRUE))}
  
  

      
     
#### MERGE MYCSV + MYDF ####
  
  # possible removal of the last row in mydf or mycsv (both cases have been observed)
        
    cat("..........Your training data is almost ready", "\n")
        
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
  

   # remove duplicit columns   # Maybe in the future also null power and stride length(if I ever get these metricss)
        myNEWcsv$HR<-NULL
        myNEWcsv$altitude <- NULL
        myNEWcsv$distance <- NULL
        myNEWcsv$cadence <- NULL
        
  # column bind  
       mymerge <- cbind(myNEWdf, myNEWcsv)
  
  # save the merged file
       write.csv(mymerge, paste(path_out, paste(date, sport_type, "data.csv", sep = "_"), sep=""), row.names=FALSE)
  
       
  cat("..........", x, " is processed and ready for further analysis", "\n")
  
  # FYI:
       # myNEWdf:
         # when
         # lat
         # long
         # altitude
         # distance
         # HR
         # cadence
       
       # myNEWcsv
         # time
         # speed.kmh
         # pace.minkm
         # stride.length
         # temperature
         # power
         # time.s
         # pace
}