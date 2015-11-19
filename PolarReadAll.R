# PolarRead all files that have not been processed yet = update

path_in <- "C:/Users/Hana/Dropbox/Polar tcx/"
path_out <- "C:/Users/Hana/Dropbox/Polar tcx/Polar_R_dataframes+infos/"

allcsvs <- list.files(path=path_in, pattern = ".csv$")  # returns character vector
allmerges <- list.files(path=path_out, pattern = "_merge.csv$") 

y1 <- setdiff(allcsvs, (gsub("_merge", "", allmerges)))
notreadyet <- gsub(".csv", "", y1)


if ((length(notreadyet))==0) {
cat("\n", "nothing to update", "\n")
}else{
  cat("the following files will be updated:")
  cat("\n", notreadyet, sep = "\n")}
  

PolarReadAll<-lapply(notreadyet, PolarRead)

if ((length(notreadyet))>0) {
  cat("\n", "all files are updated now", "\n")
}