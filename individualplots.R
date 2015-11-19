# 2015_11_05

# some plots on _merger files

setwd("C:/Users/Hana/Dropbox/Polar tcx/Polar_R_dataframes+infos")

# read the file
path_out <- "C:/Users/Hana/Dropbox/Polar tcx/Polar_R_dataframes+infos/"
allmerges <- list.files(path=path_out, pattern = "_merge.csv$") 


mydata <- read.csv("Hana_Kysela_2015-11-01_14-28-12_merge.csv")


    # ugly ones
        plot(x=mydata$distance, y=mydata$altitude)
        plot(x=mydata$distance, y=mydata$HR)
        plot(x=mydata$distance, y=mydata$pace)

#### GGPLOT2 ####  
      # install.packages("ggplot2")
      # install.packages("ggmap")
      
        library("ggplot2")
        library("ggmap")

# just overview of the track
  qplot(long, lat, data = mydata)
  
# blue trail on a google map   
  # requires internet connetion !!!

    mapImageData <- get_googlemap(center = c(lon = mean(mydata$long, na.rm = TRUE), lat = mean(mydata$lat, na.rm = TRUE)), 
                                  zoom = 13, maptype = c("terrain")) #typ muze byt roadmap, terrain nebo satellite
    map <- ggmap(mapImageData,
                 extent = "device") + # takes out axes, etc.
    geom_point(aes(x = long, y = lat), data = mydata, colour = "darkblue", size = 2, pch = 16)
    print(map)

    
## HEART RATE ANALYSIS
    
    HR.Min <- min(mydata$HR)
    HR.Med1 <- median(mydata$HR)
    HR.Med <- round(HR.Med1,0)
    HR.Max <- max(mydata$HR)
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