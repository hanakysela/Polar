# 2015_11_01

# starts PolarRead function in case both csv and tcx file is present INPUT info
# IMPORTANT FUNCTION

PolarRead <- function(x) {
  
          #check for presence of file
              allcsvs <- list.files(pattern = "\\.csv$")  # returns character vector
              alltcxs <- list.files(pattern = "\\.tcx$")  # returns character vector
  
              if(any(grepl((paste(x, "tcx", sep = ".")), alltcxs))){
                if(any(grepl((paste(x, "csv", sep = ".")), allcsvs))){
                  PolarRead1(x)
                }else{
                  print("file does not have a tcx")
                }
              }else{
                print("file does not have a csv")
              }
}