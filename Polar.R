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


#### READ AND SAVE THE FILE
    # PolarRead a single file
    PolarRead("Hana_Kysela_2015-11-05_06-19-35")

    
    
    # PolarRead all files that have not been processed yet
    
          path_in <- "C:/Users/Hana/Dropbox/Polar tcx/"
          path_out <- "C:/Users/Hana/Dropbox/Polar tcx/Polar_R_dataframes+infos/"
          
          allcsvs <- list.files(path=path_in, pattern = ".csv$")  # returns character vector
          allmerges <- list.files(path=path_out, pattern = "_merge.csv$") 
          
          y1 <- setdiff(allcsvs, (gsub("_merge", "", allmerges)))
          notreadyet <- gsub(".csv", "", y1)
          
    lapply(notreadyet, PolarRead)
    
#------------------------------------------------------------ #    


#### TODO ####
## individual files
  # pausing vs time stamp
  # plots = charts
  # Shiny (chose file and analysis + charts come up)
  # not savint the namecsv, but appending it to an info file with all the data (after a check)
  # show me a list of files that have not been "PolarRead" yet
  # loop to get all source data into one info table
  # during winter time, 6:30 workout starts at 5:30, in summer 10 am workout starts at 8am when reading from tcx


## multiple files
  # parse multiple headers into one dataframe
  # automate parsing headers of new files into dataframe
  # some statistics from that dataframe (personal bests, max values)
  # plots = charts
  # Shiny (total statistics)
  

#### INDIVIDUAL PLOTS ####
    
    plot(x=mydf$distance, y=mydf$altitude)
    plot(x=mydf$distance, y=mydf$HR)
    plot(x=mymerge$time, y=mymerge$pace.minkm)
    plot(x=mymerge$distance, y=mymerge$pace)
  
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