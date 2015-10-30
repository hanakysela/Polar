#### USUAL INTRO ####
setwd("C:/Users/Hana/R/Polar")

  #delete everything
    rm(list=ls(all=TRUE))
    
  #packages
    #install.packages("XML")
    library("XML")

#### READ + MODIFY INDIVIDUAL FILE ####
    doc = xmlParse("Hana_Kysela_2015-10-29_06-26-27.tcx") #SWIM, no HR or GPS
    doc = xmlParse("Hana_Kysela_2015-10-17_12-06-34.tcx") #WALK no HR (GPS only)
    doc = xmlParse("Hana_Kysela_2015-09-06_10-01-07.tcx") #RUN - both GPS and HR, laps = Ostravsky halfmarathon
    
    xmlToDataFrame(nodes <- getNodeSet(doc, "//ns:Trackpoint", "ns"))
    mydf  <- plyr::ldply(nodes, as.data.frame(xmlToList))

# human readable column names
    #SWIM
      colnames(mydf) <- c('time', 'distance', 'sensor')
      
    #WALK without HR
      colnames(mydf) <- c('time', 'altitude', 'distance', 'sensor', 'lat', 'long')
    
    #RUN
      colnames(mydf) <- c('time', 'altitude', 'distance', 'HR', 'sensor', 'lat', 'long')
  
  
#change classes  
  mydf$altitude<-as.numeric(mydf$altitude)
  mydf$distance<-as.numeric(mydf$distance)
  mydf$HR<-as.integer(mydf$HR)
  mydf$lat<-as.numeric(mydf$lat)
  mydf$long<-as.numeric(mydf$long)
  
  class(mydf$time) #factor
  
#### INDIVIDUAL PLOTS ####
  
  plot(x=mydf$distance, y=mydf$altitude)


#### HEADER, automation with ID and names, monthly stats, laps!
#### TODO ####
## individual files
  # date-time handling
  # check colnames and make them human readable
    # drop sensor column (it only says "Present") - double check
  # instead of mydf - filename ?
  # plots = charts
  # Shiny (chose file and analysis + charts come up)

## multiple files
  # read the header (maxs, totals, sport type, ...)
  # parse header into dataframe
  # parse multiple headers into one dataframe
  # automate parsing headers of new files into dataframe
  # some statistics from that dataframe (personal bests, max values)
  # plots = charts
  # Shiny (total statistics)
