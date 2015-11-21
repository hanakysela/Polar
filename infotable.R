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

## libraries
    library("ggplot2")

## plot y=distance, x=date, color = specific for discipline
    qplot(when, total.dist, data = infotable, color=sport, size=I(5))
    

## aggregation by month/year for distance/duration
    
    infotable$short.date <- strftime(infotable$when, "%Y/%m")
    
    aggr.dist = aggregate(total.dist ~ short.date + sport, data=infotable, FUN = sum)
    qplot(short.date, total.dist, data=aggr.dist, color=sport, 
          main = "Monthly distances (km)",
          xlab = "Month", ylab="Distance (total) in km", 
          size=I(5))
    
    aggr.dur = aggregate(duration.s ~ short.date + sport, data=infotable, FUN = sum)
    qplot(short.date, duration.s/3600, data=aggr.dur, color=sport,
          main = "Monthly hours",
          xlab = "Month", ylab="Hours", 
          size=I(5))
    

## Stacked Bar Plot with Colors and Legend #number of workounts / COUNT function
    counts <- table(aggr.dist$sport, aggr.dist$short.date)
    barplot(counts, main="Training sessions per month",
            xlab="Month", ylab="Number of Seesions", col=c("darkgreen","lightblue", "brown", "yellow"),
            legend = rownames(counts)) 

## ggplot
    ggplot(infotable, aes(short.date, total.dist, fill=sport))+
      geom_bar(stat="identity", position = "stack")
    
#### punchcard ####
    library(ggplot2)
    library("plyr")
    
    # first I need a time and dayofweek variable
    infotable$WeekDay <- weekdays(strptime(infotable$when, "%Y-%m-%d" ))
    week <- c("Sunday", "Saturday", "Friday", "Thursday", "Wednesday", "Tuesday", "Monday")
    infotable$WeekDay <- factor(infotable$WeekDay, levels = week)
   
    infotable$hour <- strftime(infotable$when, "%H")
    infotable$hour <- as.integer(infotable$hour)
    
    # create a punchcard table (aggregated stats)
    punchcard <- count(infotable, c('sport', 'hour','WeekDay'))
    
    ggplot(punchcard, aes(hour, WeekDay, size=freq, fill=sport)) + 
      geom_point(shape=21, alpha=1/3) +
      scale_x_continuous(breaks=seq(6, 22, 2)) # popis os co 2 hodiny
    
    ggplot(infotable, aes(hour, WeekDay, size=duration.s, fill=sport)) +
      geom_point(shape=21, alpha=1/3) +
      scale_x_continuous(breaks=seq(6, 22, 2)) # popis os co 2 hodiny
    
    
    ggplot(infotable, aes(sport, WeekDay, size=duration.s, fill=trainload)) +
      geom_point(shape=21, alpha=1/3)
    
    ggplot(infotable, aes(trainload, WeekDay, fill=sport)) +
      geom_point(shape=21, alpha=1/3, size=5)
