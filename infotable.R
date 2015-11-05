# 2015_11_05

##### PREPARE THE TABLE

  # create info file from all .info sources (does not take that long)
    path_out <- "C:/Users/Hana/Dropbox/Polar tcx/Polar_R_dataframes+infos/"
    allinfos <- list.files(path=path_out, pattern = "_Info.csv$")
    
    setwd("C:/Users/Hana/Dropbox/Polar tcx/Polar_R_dataframes+infos")
    tables <- lapply(allinfos, read.csv, header = TRUE)
    infotable <- do.call(rbind , tables)
  
  # drop info about cadence, stride length and notes (not available at the moment)
    infotable$average.cadence <- NULL
    infotable$average.stride.length <- NULL
    infotable$notes <- NULL

#### RUN SOME STATISTICS ####
    str(infotable)
    summary(infotable)
    