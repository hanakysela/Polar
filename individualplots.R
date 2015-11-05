# 2015_11_05

# some plots on _merger files

# read the file
path_out <- "C:/Users/Hana/Dropbox/Polar tcx/Polar_R_dataframes+infos/"
allmerges <- list.files(path=path_out, pattern = "_merge.csv$") 


mydata <- read.csv("Hana_Kysela_2015-09-06_10-01-07_merge.csv")


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

    mapImageData <- get_googlemap(center = c(lon = mean(mydata$long, na.rm = TRUE), lat = mean(mydata$lat, na.rm = TRUE)), 
                                  zoom = 13, maptype = c("roadmap"))
    map <- ggmap(mapImageData,
                 extent = "device") + # takes out axes, etc.
    geom_point(aes(x = long, y = lat), data = mydata, colour = "darkblue", size = 2, pch = 16)
    print(map)