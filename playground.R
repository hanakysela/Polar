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
infotable$hour <- as.integer(infotable$hour)