#### DATE ####

infotable$when <- as.POSIXct((strptime(infotable$when, format = "%Y-%m-%d %H:%M:%S")))

# add more date related columns eg. from when = "2015-09-06 10:01:07"

# 2015
infotable$year <- strftime(infotable$when, "%Y")
infotable$year <- as.integer(infotable$year)

# September
infotable$month <- strftime(infotable$when, "%B")
months <- c("January", "February", "March", "April", "May", "June", "July", 
            "August", "September", "October", "November", "December")
infotable$month <- factor(infotable$month, levels = months)

# 36
infotable$week <- strftime(infotable$when, "%V")
infotable$week <- as.integer(infotable$week)

# Sunday
infotable$WeekDay <- weekdays(strptime(infotable$when, "%Y-%m-%d" ))
week <- c("Sunday", "Saturday", "Friday", "Thursday", "Wednesday", "Tuesday", "Monday")
infotable$WeekDay <- factor(infotable$WeekDay, levels = week)

# 10 (hour of start)
infotable$hour <- strftime(infotable$when, "%H")
<<<<<<< HEAD
<<<<<<< HEAD
infotable$hour <- as.integer(infotable$hour)


#### colors for sports ####

a1<-c("CYCLING", "HIKING", "MOUNTAIN_BIKING", "POOL_SWIMMING", "WALKING", "RUNNING")
b1<-c("yellow", "red", "orange", "blue", "green", "brown")


a<-c("RUNNING", "HIKING", "MOUNTAIN_BIKING", "POOL_SWIMMING", "CYCLING", "WALKING")
b<-c("yellow", "red", "orange", "blue", "green", "brown")

# I can set sports colors, but not the stack order (yet)

ggplot(aggr.dist, aes(month, total.dist, fill=sport))+
  geom_bar(stat="identity", position = "stack") +
  scale_fill_manual(breaks = a, values = b)

attributes(aggr.dist$sport)
levels(aggr.dist$sport)
=======
infotable$hour <- as.integer(infotable$hour)
>>>>>>> cf92f76f52b7840535e4751db8dda2f2b0670b89
=======
infotable$hour <- as.integer(infotable$hour)
>>>>>>> cf92f76f52b7840535e4751db8dda2f2b0670b89
