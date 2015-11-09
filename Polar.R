#### USUAL INTRO ####
setwd("C:/Users/Hana/R/Polar")

  # delete everything
    rm(list=ls(all=TRUE))
  
  # close all open graphics
    graphics.off()
    
  # source other functions
    source("PolarRead.R")
    
PolarReadAll # processes files that have not been processed yet