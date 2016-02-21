# 2015_11_05

# some plots on _merger files

setwd("C:/Users/Hana/Dropbox/Polar tcx/Polar_R_dataframes+infos")

# read the file

  library("ggplot2")
  library("ggmap")


        path_out <- "C:/Users/Hana/Dropbox/Polar tcx/Polar_R_dataframes+infos/"
        files_out <- list.files(path=path_out, pattern = "_data.csv$")  
        
        mydata <- read.csv("2016-02-20_10-02-09_CROSS-COUNTRY_SKIING_data.csv")

        
#### HR zones ####
   
        mydata$HRzone <- ifelse(mydata$HR > 168, "Zone5", 
                                ifelse(mydata$HR > 149, "Zone4", 
                                ifelse(mydata$HR > 131, "Zone3",
                                ifelse(mydata$HR > 112, "Zone2", 
                                ifelse(mydata$HR > 93, "Zone1",
                                       "NoZone")))))
       
            mydata$HRzone <- as.factor(mydata$HRzone)
        
        #Create a custom color scale
                myColors <- c("white", "grey", "deepskyblue3","springgreen3", "gold", "red3")
                names(myColors) <- levels(mydata$HR)
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
          geom_line(aes(y=altitude), colour="black", size=1) + 
          geom_line(aes(y=cadence), colour="green3", size=1) # if cadence is not available, it does not plot anything at all
        
    # Plot elevations and smoother
        
        ggplot(mydata, aes(distance, HR)) +
          stat_smooth() +
          geom_point()
        
        ggplot(mydata, aes(distance, cadence)) +
          stat_smooth() +
          geom_point()
        
        
          

#### track info ####
        
    # just overview of the track
          qplot(long, lat, data = mydata)
        
        
    # requires internet connetion !!!
    
        mapImageData <- get_googlemap(center = c(lon = mean(mydata$long, na.rm = TRUE), lat = mean(mydata$lat, na.rm = TRUE)), 
                                      zoom = 15, maptype = c("terrain")) #typ muze byt roadmap, terrain nebo satellite
      
      # VARIANTA A - je to podle konkretni tepove frekvence (HR)    
        map <- ggmap(mapImageData, extent = "device") + # takes out axes, etc.
        geom_path(data = mydata, aes(long, lat, color = HR), size = 1.5, lineend = "round") + 
        scale_color_gradient(low="green", high="red", limits=c(100, 170), na.value = "grey83")
        print(map)
        
     # VARIANTA B - je to podle tepove zony - viz PolarFlow (HRzone)
        map <- ggmap(mapImageData, extent = "device") + # takes out axes, etc.
        geom_point(data = mydata, aes(long, lat, color = HRzone), size = 1.5) +
          colScale
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