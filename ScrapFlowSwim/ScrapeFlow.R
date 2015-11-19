# 2015_11_13
# Manual colapsing of "laps" in Polar Flow, 
# Exporting firtst bit to notepad and saving as .csv, 
# then adding different columns and also manually saving

c<-read.csv("Scrap_coll.csv", header = FALSE)

b<-read.csv("scrap_coll2.csv", header = FALSE)

c1 <- matrix(c[1:(nrow(c)-1),1], nrow=7)
b1 <- matrix(b[, 1], nrow=7)

# merge
aa <- merge(c1, b1, all=TRUE)
  
#transpose




## delete absolete columns
aa[,1 ]<-NULL