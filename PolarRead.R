# 2015_11_01

# starts PolarRead function in case both csv and tcx file is present INPUT info
# IMPORTANT FUNCTION

# 2015_11_01

# starts PolarRead only if the output file is not there

PolarRead <- function(x) {
  
          #check for presence of file
      cat("checking for csv and tcx source file", "\n")
              path_in <- "C:/Users/Hana/Dropbox/Polar tcx/"
 
              allcsvs <- list.files(path=path_in, pattern = ".csv$")  # returns character vector
              alltcxs <- list.files(path=path_in, pattern = ".tcx$")  # returns character vector
  
              if(any(grepl((paste(x, "tcx", sep = ".")), alltcxs))){
                if(any(grepl((paste(x, "csv", sep = ".")), allcsvs))){
                  PolarRead2(x)
                }else{
                  print("file does not have a tcx")
                }
              }else{
                print("file does not have a csv")
              }
}


PolarRead2 <- function(x) {
  #check for presence of file
  cat("checking for output files", "\n")
  path_out <- "C:/Users/Hana/Dropbox/Polar tcx/Polar_R_dataframes+infos/"
  
  alloutputs <- list.files(path=path_out, pattern = ".csv$") # returns character vector
  
  if(any(grepl((paste(x, "_merge.csv", sep = "")), alloutputs))){
    print("merge file is here")
  }else{
    if(any(grepl((paste(x, ":info.csv", sep = "")), alloutputs))){
    print("info is already here")
    }else{
     PolarRead1(x)
      }
    }
  }