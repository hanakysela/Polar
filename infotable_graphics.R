# 2015_11_21

#### read the infotable.csv ####
path_out <- "C:/Users/hanak/Dropbox/Polar tcx/Polar_R_dataframes+infos/"
infotable<-read.csv(paste(path_out, "infotable.csv", sep = ""))


#### Rarely used sports ####
  # if the sport has only few mentions (like that one time I went cross-country skiing), drop the info #TODO

  # Drop CROSS-COUNTRY_SKIING specifically - this should be made simpler #ToDo
    infotable <- infotable[!(infotable$sport == "CROSS-COUNTRY_SKIING"), ] 

    # how many times is the sport in the table?
    sportcount <- count(infotable, 'sport')
    sportcount$rare <- sportcount$freq < 7

    # should there be dropping of sport? Which one(s) ?
    
    
      

        
        # You can also work with a so called boolean vector, aka logical:
        # row_to_keep = c(TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE)
        # myData = myData[row_to_keep,]
        # 
        # Note that the ! operator acts as a NOT, i.e. !TRUE == FALSE:
        # myData = myData[!row_to_keep,]
        # This seems a bit cumbersome in comparison to @mrwab's answer (+1 btw :)), but a logical vector can be generated on the fly, e.g. where a column value exceeds a certain value:
        # 
        # myData = myData[myData$A > 4,]
        # myData = myData[!myData$A > 4,] # equal to myData[myData$A <= 4,]
        # 
        # You can transform a boolean vector to a vector of indices:
        # row_to_keep = which(myData$A > 4)
        # 
        # Finally, a very neat trick is that you can use this kind of subsetting not only for extraction, but also for assignment:
        # myData$A[myData$A > 4,] <- NA
        # where column A is assigned NA (not a number) where A exceeds 4.


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
 
      if (!require("pacman")) install.packages("pacman")
      pacman::p_load(ggplot2, plyr)
      
      
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


#### How the hell is trainload calculated? ####
              ggplot(infotable, aes(x = calories, y = trainload, col = sport)) + 
                geom_point() + 
                geom_smooth(method = "lm", se = F)