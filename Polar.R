#### USUAL INTRO ####
setwd("C:/Users/Hana/R/Polar")

  # delete everything
    rm(list=ls(all=TRUE))
  
  # close all open graphics
  graphics.off()
    
  # packages
    #install.packages("XML")
    #install.packages("lubridate")
    
    library("XML")
    library("lubridate")

#### READ + MODIFY INDIVIDUAL FILE'S TRACKPOINTS TCX ####
    doc = xmlParse("Hana_Kysela_2015-10-29_06-26-27.tcx") #SWIM, no HR or GPS
    doc = xmlParse("Hana_Kysela_2015-10-17_12-06-34.tcx") #WALK no HR (GPS only)
    doc = xmlParse("Hana_Kysela_2015-09-06_10-01-07.tcx") #RUN - both GPS and HR, laps = Ostravsky halfmarathon
    
    xmlToDataFrame(nodes <- getNodeSet(doc, "//ns:Trackpoint", "ns"))
    mydf  <- plyr::ldply(nodes, as.data.frame(xmlToList))
    
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
  
  myinfo<-read.csv("Hana_Kysela_2015-09-06_10-01-07.csv", header = TRUE, nrows = 1)
      
      # drop the name and "X" column information
        myinfo$Name <- NULL      
        myinfo$X <- NULL  
  
      # name the columns
        names(myinfo) <- c("sport", "date", "start", "duration", "total.dist", "average.HR", "average.speed", "max.speed", "average.pace", "max.pace", "calories", "fat.percent", "average.cadence", "average.stride.length", "running.index", "trainload", "ascent", "descent", "notes", "height", "weight", "max.HR", "sit.HR", "VO2max")

      # assign correct class
        myinfo$when = paste(myinfo$date, myinfo$start, sep= " ")
        myinfo$when <- as.POSIXct(myinfo$when, format =  "%m.%d.%Y %H:%M:%S")
        
        myinfo$duration.s <- period_to_seconds(hms(myinfo$duration))
        
      # drop the obsolete date and start columns
        myinfo$date <- NULL      
        myinfo$start <- NULL
      
      # reorder by columns
        myinfo<-myinfo[,c(1, (ncol(myinfo)-1), 2, (ncol(myinfo)), 3:(ncol(myinfo)-2))]

               
  mycsv<-read.csv("Hana_Kysela_2015-09-06_10-01-07.csv", skip = 2)
      
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
 
  # remove last row in mydf
        myNEWdf<-mydf[-nrow(mydf),]
        
  # remove duplicit columns   
        myNEWcsv <- mycsv
        myNEWcsv$HR<-NULL
        myNEWcsv$altitude <- NULL
        myNEWcsv$distance <- NULL
        
  # column bind  
        mymerge <- cbind(myNEWdf, myNEWcsv)

  # organize columns
        mymerge<-mymerge[,c(1, 7, 8, 4, 3, 9, 10, 11, 5, 6, 2, 12)]

#### INDIVIDUAL PLOTS ####
  
  plot(x=mydf$distance, y=mydf$altitude)
  plot(x=mydf$distance, y=mydf$HR)
  plot(x=mymerge$time, y=mymerge$pace.minkm)
  plot(x=mymerge$distance, y=mymerge$pace)

#### TODO ####
## individual files
  # pausing vs time stamp
  # instead of mydf - filename ?
  # plots = charts
  # Shiny (chose file and analysis + charts come up)

## multiple files
  # parse multiple headers into one dataframe
  # automate parsing headers of new files into dataframe
  # some statistics from that dataframe (personal bests, max values)
  # plots = charts
  # Shiny (total statistics)
 