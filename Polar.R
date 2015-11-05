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
  # Shiny (chose file and analysis + charts come up)
  # during winter time, 6:30 workout starts at 5:30, in summer 10 am workout starts at 8am when reading from tcx

  # run statistics and charts on _merge.csv files

## multiple files
  # some statistics from that dataframe (personal bests, max values)
  # plots = charts
  # Shiny (total statistics)