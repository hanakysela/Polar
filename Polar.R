setwd("C:/Users/Hana/R/Polar")

#delete everything
  rm(list=ls(all=TRUE))
  
#balicky
  #install.packages("XML")
  library("XML")

   
doc = xmlParse("Hana_Kysela_2015-10-29_06-26-27.tcx") #plavani bez HR a GPS
doc = xmlParse("Hana_Kysela_2015-10-17_12-06-34.tcx") #walk bez HR (jen GPS)
doc = xmlParse("Hana_Kysela_2015-09-06_10-01-07.tcx") #Ostravsky pulmarathon - HR i GPS, laps

xmlToDataFrame(nodes <- getNodeSet(doc, "//ns:Trackpoint", "ns"))
mydf  <- plyr::ldply(nodes, as.data.frame(xmlToList))


    #PLAVANI
      colnames(mydf) <- c('time', 'distance', 'sensor')
      
    #CHUZE BEZ HR
      colnames(mydf) <- c('time', 'altitude', 'distance', 'sensor', 'lat', 'long')
    
    #BEH
      colnames(mydf) <- c('time', 'altitude', 'distance', 'HR', 'sensor', 'lat', 'long')
  
  
#upraveni classes  
  mydf$altitude<-as.numeric(mydf$altitude)
  mydf$distance<-as.numeric(mydf$distance)
  mydf$HR<-as.integer(mydf$HR)
  mydf$lat<-as.numeric(mydf$lat)
  mydf$long<-as.numeric(mydf$long)
  
  
  class(mydf$time) #factor

 #### PLOTS ####
  
  plot(x=mydf$distance, y=mydf$altitude) #????


#### HEADER, automation with ID and names, monthly stats, laps!
