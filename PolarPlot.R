# 2016-08-22
# basic loop to plot tracks


setwd("C:/Users/hanak/Dropbox/Polar tcx/Polar_R_dataframes+infos")

PolarPlot <- function (x) {
  
  a <- read.csv(x)
  
  mapImageData <- get_googlemap(center = c(lon = 14.5, lat = 50), 
                                zoom = 10, maptype = c("terrain")) #maptype can be roadmap, terrain or satellite
  ggmap(mapImageData, extent = "device") + # takes out axes, etc.
    geom_path(data = a, aes(long, lat), size = 2, color = "blue", na.rm = TRUE)
  
}



PolarPlotAll

x = "2016-08-18_10-46-48_CYCLING_data.csv"


