#### USUAL INTRO ####
setwd("C:/Users/Hana/R/Polar")

  # delete everything
    rm(list=ls(all=TRUE))
  
  # close all open graphics
    graphics.off()
    
  # source other functions
    source("PolarRead.R")
    source("PolarReadAll.R") #this also runs the PolarReadAll
    source("infotable.R")