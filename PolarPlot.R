# 2016-08-22
# basic loop to plot tracks


setwd("C:/Users/hanak/Dropbox/Polar tcx/Polar_R_dataframes+infos")

if (!require("pacman")) install.packages("pacman")
pacman::p_load(ggplot2, ggmap)

PolarReadRoute <- function (x) {
  
  a <- read.csv(x)
  b<-a[,c("when", "lat", "long")]
    
  date <- substr(paste(b[1,1]), 1, 19)
  sport_type <- substr(x, 21, (nchar(x) - 9))
  
  b$when <- date
  b$sport <- sport_type
  
  return(b)
  
  }

path_out <- "C:/Users/hanak/Dropbox/Polar tcx/Polar_R_dataframes+infos/"
allMTB <- list.files(path=path_out, pattern = "_MOUNTAIN_BIKING_data.csv$") # only reads in MTB
allinfos <- list.files(path=path_out, pattern = "_data.csv$") # reads everything (INCL Swim without GPS!)

# if the line contains swimming, drop it #ToDo


tables <- lapply(allMTB, PolarReadRoute)
longlist <- do.call(rbind , tables)


#### THE MAPPING!! ####

mapImageData <- get_googlemap(center = c(lon = 14.5, lat = 50), 
                             zoom = 11, maptype = c("terrain")) #maptype can be roadmap, terrain or satellite
map <- ggmap(mapImageData, extent = "device") # takes out axes, etc.
lines <- geom_path(data = longlist, aes(long, lat), size = 1, na.rm = TRUE, col ="red")
 
map + lines

