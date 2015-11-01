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
               
              # dfalltcxs <- as.data.frame(alltcxs, optional = FALSE) #returns dataframe ### NOT NEEDED
  
              allcsvs <- list.files(pattern = "\\.csv$")  # returns character vector
              alltcxs <- list.files(pattern = "\\.tcx$")  # returns character vector
    
              # What files can I choose from?
              alltcxs

              name <- "Hana_Kysela_2015-09-06_10-01-07"
    
 
#### READ AND SAVE THE FILE
    PolarRead("Hana_Kysela_2015-09-06_10-01-07")


    
    
#### INDIVIDUAL PLOTS ####
  
  plot(x=mydf$distance, y=mydf$altitude)
  plot(x=mydf$distance, y=mydf$HR)
  plot(x=mymerge$time, y=mymerge$pace.minkm)
  plot(x=mymerge$distance, y=mymerge$pace)

#### TODO ####
## individual files
  # reading from dropbox, saving...where? running from R/Polar
  # pausing vs time stamp
  # check if I already have processed the file into a namecsv or namemerge R
  # plots = charts
  # Shiny (chose file and analysis + charts come up)
  # not savint the namecsv, but appending it to an info file with all the data (after a check)

## multiple files
  # parse multiple headers into one dataframe
  # automate parsing headers of new files into dataframe
  # some statistics from that dataframe (personal bests, max values)
  # plots = charts
  # Shiny (total statistics)
 