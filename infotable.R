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
    

## plot y=distance, x=date, color = specific for discipline
    qplot(when, total.dist, data = infotable, color=sport)
    

## aggregation by month/year for distance/duration
    
    short.date = strftime(infotable$when, "%Y/%m")
    aggr.dist = aggregate(total.dist ~ short.date + sport, data=infotable, FUN = sum)
    qplot(short.date, total.dist, data=aggr.dist, color=sport)
    
    aggr.dur = aggregate(duration.s ~ short.date + sport, data=infotable, FUN = sum)
    qplot(short.date, duration.s/3600, data=aggr.dur, color=sport)
    

## Stacked Bar Plot with Colors and Legend #number of workounts / COUNT function
    counts <- table(aggr.dist$sport, aggr.dist$short.date)
    barplot(counts, main="Car Distribution by Gears and VS",
            xlab="Number of Gears", col=c("green","yellow", "green", "blue", "red"),
            legend = rownames(counts)) 
