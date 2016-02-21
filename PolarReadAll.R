# PolarRead all files that have not been processed yet = update
    
    # 2016_02_20 update needed (and done) -  I have changed naming system for the outputs
        
        path_in <- "C:/Users/Hana/Dropbox/Polar tcx/"
        path_out <- "C:/Users/Hana/Dropbox/Polar tcx/Polar_R_dataframes+infos/"
        
        
        files_in <- list.files(path=path_in, pattern = ".csv$")  
            # returns character vector of all files downloaded from Polar to Dropbox
        keys_in <- substr(files_in, 13, 31) # cuts every name in vector to a date
      

        files_out <- list.files(path=path_out, pattern = "_data.csv$") 
            # returns character vector of already processed files
        keys_out <- substr(files_out, 1, 19) # cuts every name in vector to a date
        
        
        new <- setdiff(keys_in, keys_out) #what was not processed yet?
       
        
        if ((length(new))==0) {
          cat("\n", "nothing to update", "\n")
        
        }else{
          cat("the following files will be updated:")
          cat("\n", new, sep = "\n")
          new_to_be_read <- paste("Hana_Kysela", new, sep="_")
          PolarReadAll<-lapply(new_to_be_read, PolarRead)}