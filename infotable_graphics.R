# 2015_11_21

#### read the infotable.csv ####
path_out <- "C:/Users/Hana/Dropbox/Polar tcx/Polar_R_dataframes+infos/"
infotable<-read.csv(paste(path_out, "infotable.csv", sep = ""))

#### fix classes ####

        infotable$when <- as.POSIXct((strptime(infotable$when, format = "%Y-%m-%d %H:%M:%S")))
        
        infotable$year <- as.integer(infotable$year)
        
        months <- c("January", "February", "March", "April", "May", "June", "July", 
                    "August", "September", "October", "November", "December")
        infotable$month <- factor(infotable$month, levels = months)
        
        infotable$week <- as.integer(infotable$week)
        
        week <- c("Sunday", "Saturday", "Friday", "Thursday", "Wednesday", "Tuesday", "Monday")
        infotable$WeekDay <- factor(infotable$WeekDay, levels = week)
        
        infotable$hour <- as.integer(infotable$hour)

##### simple plots ####
          # libraries
             library("ggplot2")
          
          ## plot individual workouts - duration or distance ##
            qplot(when, total.dist, data = infotable, color=sport, size=I(5))
            qplot(when, duration.s/3600, data = infotable, color=sport, size=I(5))
          
          .
          ## Plot summaries: aggregation by month for distance/duration/calories/traiload/ascent/freq
          ## THIS WOULD BE FANTASTIC FOR SHINY: choose metric AND period
          
              aggr.dist = aggregate(total.dist ~ week + sport, data=infotable, FUN = sum)
              ggplot(aggr.dist, aes(week, total.dist, fill=sport))+
                geom_bar(stat="identity", position = "stack") +
                xlab("Week") + ylab("Total distance (km)")
              
             aggr.dist = aggregate(total.dist ~ month + sport, data=infotable, FUN = sum)
                 ggplot(aggr.dist, aes(month, total.dist, fill=sport))+
                   geom_bar(stat="identity", position = "stack") +
                   xlab("Month") + ylab("Total distance (km)")
    
              
              aggr.dur = aggregate(duration.s ~ month + sport, data=infotable, FUN = sum)
                 ggplot(aggr.dur, aes(month, duration.s/3600, fill=sport))+
                   geom_bar(stat="identity", position = "stack") +
                   xlab("Month") + ylab("Total duration (hours)")
    
                 
              aggr.cal = aggregate(calories ~ month + sport, data=infotable, FUN = sum)
                 ggplot(aggr.cal, aes(month, calories, fill=sport))+
                   geom_bar(stat="identity", position = "stack") +
                   xlab("Month") + ylab("Calories")
                 
              aggr.load = aggregate(trainload ~ month + sport, data=infotable, FUN = sum)
                 ggplot(aggr.load, aes(month, trainload, fill=sport))+
                   geom_bar(stat="identity", position = "stack") +
                   xlab("Month") + ylab("Trainload")
                 
              aggr.asc = aggregate(ascent ~ month + sport, data=infotable, FUN = sum)
                 ggplot(aggr.asc, aes(month, ascent, fill=sport))+
                   geom_bar(stat="identity", position = "stack") +
                   xlab("Month") + ylab("Total ascent (m)")
          
            ## ALL PREVIOUS ONLY DISPLAY MONTHS WHERE DATA IS AVAILABLE, THOUGH COUNTS DISPLAY IT ACROSS ALL MONTHS     
                 
              counts <- data.frame(table(infotable$sport, infotable$month))
                 ggplot(counts, aes(Var2, Freq, fill=Var1))+
                    geom_bar(stat="identity", position = "stack") +
                    xlab("Month") + ylab("Frequency")
            

#### punchcards ####
      library("ggplot2")
      library("plyr")
      
      
      # create a punchcard table (aggregated stats)
              
              ggplot(infotable, aes(sport, WeekDay, size=duration.s, fill=trainload)) +
                geom_point(shape=21, alpha=1/3)
              
              ggplot(infotable, aes(trainload, WeekDay, fill=sport, size=calories)) +
                geom_point(shape=21, alpha=1/3)
              
          # my favourite - trainload on weekdays, different color for sports, hue acc to calories    
              ggplot(infotable, aes(trainload, WeekDay, fill=sport, alpha=calories)) +
                geom_point(shape=21, size=5)
              
              
            punchcard <- count(infotable, c('sport', 'hour','WeekDay'))
              
              ggplot(punchcard, aes(hour, WeekDay, size=freq, fill=sport)) + 
                geom_point(shape=21, alpha=1/3) +
                scale_x_continuous(breaks=seq(6, 22, 2)) # popis os co 2 hodiny

              qplot(hour, WeekDay, data = infotable, colour = sport, alpha=1/3, size=10)
              qplot(trainload, WeekDay, data = infotable, colour = sport, alpha=1/5, size=calories)