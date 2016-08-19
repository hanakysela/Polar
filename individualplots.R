# 2015_11_05

# some plots on _merger files

setwd("C:/Users/hanak/Dropbox/Polar tcx/Polar_R_dataframes+infos")

# read the file
    if (!require("pacman")) install.packages("pacman")
    pacman::p_load(ggplot2, ggmap)
  

        path_out <- "C:/Users/hanak/Dropbox/Polar tcx/Polar_R_dataframes+infos/"
        files_out <- list.files(path=path_out, pattern = "_data.csv$")  
        
        mydata <- read.csv("2016-02-27_11-09-32_CYCLING_data.csv")
        mydata <- read.csv("2016-03-05_10-54-18_HIKING_data.csv")
        mydata <- read.csv(paste(new, "_HIKING_data.csv", sep=""))
        
        
#### HR zones ####
   
        mydata$HRzone <- ifelse(mydata$HR > 168, "Zone5 - Maximum", #red 
                                ifelse(mydata$HR > 149, "Zone4 - Anaerobic", #yellow
                                ifelse(mydata$HR > 131, "Zone3 - Aerobic", #green
                                ifelse(mydata$HR > 112, "Zone2 - Fat Burning", #blue
                                ifelse(mydata$HR > 93, "Zone1 - Warm Up", #grey
                                       "NoZone"))))) # white
       
            mydata$HRzone <- as.factor(mydata$HRzone)
        
        #Create a custom color scale
                myColors <- c("white", "grey", "deepskyblue3","springgreen3", "gold", "red3")
                names(myColors) <- c("NoZone", "Zone1 - Warm Up", "Zone2 - Fat Burning", "Zone3 - Aerobic", "Zone4 - Anaerobic", "Zone5 - Maximum")
                colScale <- scale_colour_manual(name = "HR zones",values = myColors)
                
        
        
#### training info ####
       
         # ugly fast ones - to see if everything is OK
        plot(x=mydata$distance, y=mydata$altitude)
        plot(x=mydata$distance, y=mydata$HR)
        plot(x=mydata$distance, y=mydata$pace)
        plot(x=mydata$distance, y=mydata$cadence)
        
        ggplot(mydata, aes(distance/1000)) +
          geom_line(aes(y=HR), colour="red3", size=1) +
          geom_line(aes(y=pace), colour="blue", size=1)  + 
          geom_ribbon(aes(y=altitude, ymin=0, ymax=altitude), fill="grey70", alpha=0.5) + 
          geom_line(aes(y=cadence), colour="green3", size=1) # if cadence is not available, it does not plot anything at all
        
    # Plot elevations and smoother
        
        ggplot(mydata, aes(distance, HR)) +
          stat_smooth() +
          geom_point()
        
        ggplot(mydata, aes(distance, cadence)) +
          stat_smooth() +
          geom_point()
        
        
          

#### track info ####
        
      
     # HR zones during the workout - on a map
        # requires internet connetion !!!
        mapImageData <- get_googlemap(center = c(lon = mean(mydata$long, na.rm = TRUE), lat = mean(mydata$lat, na.rm = TRUE)), 
                                      zoom = 12, maptype = c("terrain")) #typ muze byt roadmap, terrain nebo satellite
        map <- ggmap(mapImageData, extent = "device") + # takes out axes, etc.
        geom_point(data = mydata, aes(long, lat, color = HRzone), size = 3) +
          colScale
        print(map)
        
        # VARIANTA B - je to podle konkretni tepove frekvence (HR)    
        geom_path(data = mydata, aes(long, lat, color = HR), size = 2.5, lineend = "round") + 
        scale_color_gradient(low="green", high="red", limits=c(50, 170), na.value = "grey83")
        print(map)              
                

#### HEART RATE ANALYSIS ####
    
    HR.Min <- min(mydata$HR, na.rm=TRUE)
    HR.Med1 <- median(mydata$HR, na.rm=TRUE)
    HR.Med <- round(HR.Med1,0)
    HR.Max <- max(mydata$HR, na.rm=TRUE)
    HR.plot <- qplot(distance, 
                      HR, 
                      data = mydata, 
                      geom = "point")
    HR <- HR.plot + 
      geom_hline(aes(yintercept=HR.Med), 
                 color="red",
                 linetype="dashed") +
      labs(title="HR vs distance [km]") +
      annotate("text", 
               x = 0.25, 
               y = HR.Med+2, 
               label = "Median HR", 
               color = "red") +
      annotate("text", 
               x = 0.25, 
               y = HR.Med-2, 
               label = HR.Med, 
               color = "red")
    
    print(HR)