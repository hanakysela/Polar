#### USUAL INTRO ####
setwd("C:/Users/Hana/R/Polar")

  # delete everything
    rm(list=ls(all=TRUE))
  
  # close all open graphics
    graphics.off()
    
  # packages
    library("XML")
    library("lubridate")
  
  # source other functions
    source("PolarRead.R")
    source("PolarRead1.R")
  

              # EXAMPLE FILES
              #   doc = xmlParse("Hana_Kysela_2015-10-29_06-26-27.tcx") #SWIM, no HR or GPS
              #   doc = xmlParse("Hana_Kysela_2015-10-17_12-06-34.tcx") #WALK no HR (GPS only)
              #   doc = xmlParse("Hana_Kysela_2015-09-06_10-01-07.tcx") #RUN - both GPS and HR, laps = Ostravsky halfmarathon
               
             
              # What files can I choose from?
              path_in <- "C:/Users/Hana/Dropbox/Polar tcx/"
              alltcxs <- list.files(path=path_in, pattern = ".tcx$")  # returns character vector
              alltcxs
              
              allcsvs <- list.files(path=path_in, pattern = ".csv$")  # returns character vector
              allcsvs

              x<-"Hana_Kysela_2015-11-03_06-30-51"
 
#### READ AND SAVE THE FILE
    PolarRead("Hana_Kysela_2015-11-03_06-30-51")
    PolarRead(x)

    
    
#### INDIVIDUAL PLOTS ####
  
  plot(x=mydf$distance, y=mydf$altitude)
  plot(x=mydf$distance, y=mydf$HR)
  plot(x=mymerge$time, y=mymerge$pace.minkm)
  plot(x=mymerge$distance, y=mymerge$pace)

#### TODO ####
## individual files
  # pausing vs time stamp
  # plots = charts
  # Shiny (chose file and analysis + charts come up)
  # not savint the namecsv, but appending it to an info file with all the data (after a check)
  # loop to get all source data into a csv format + one info table

## multiple files
  # parse multiple headers into one dataframe
  # automate parsing headers of new files into dataframe
  # some statistics from that dataframe (personal bests, max values)
  # plots = charts
  # Shiny (total statistics)
  

  
#### SOME MAPS BEFORE SLEEP ####  
  install.packages("ggplot2")
  library("ggplot2")
  
  install.packages("ggmap")
  library("ggmap")
  
  
  qplot(long, lat, data = mydf)
  
  mapImageData <- get_googlemap(center = c(lon = mean(mydf$long), lat = mean(mydf$lat)), 
                                zoom = 13, maptype = c("roadmap"))
  
  map <- ggmap(mapImageData,
               extent = "device") + # takes out axes, etc.
    geom_point(aes(x = long, y = lat), data = mydf, colour = "darkblue", size = 2, pch = 16)
  print(map)
 
  cat("iteration = ", "\n")