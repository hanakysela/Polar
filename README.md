# Polar with R

## The idea behind
1. download .tcx and .csv file from the [Polar Flow](wwww.flow.polar.com) website (preferably to a Dropbox folder)
2. run the `Polar.R` script (it contains a `PolarRead` function, that checks if the file was processed already and if not, does the job. 

The output is two .csv files:

- xxx_merge.csv that contains all the available info in a nice csv file
- xxx_info.csv that has only one line of important values (max speed, average HR, dist, duration, ...)






## The goal
For me is to get familiar with R working on a topic that I like.
If things work, I would like to be able to recreate Endomondo/Polar functionality without the need of internet - and also doing something with the back-up exports I always do.








## Done so far

- organizing the files so there is some system
- using Git
- script that reads the files, cleanes them and outputs the things I wanted
- added a "checker" to know which files to look for (those that have not been processed yet) + use of the `apply` function!

### xxx_merge.csv file
done some plotting (w/google maps)

### xxx_info.csv
- merge of all headers into one file ('infotable.df")
- plotting some overview statistics






## ToDo

- individual files
  - pausing vs time stamp
  - Shiny (chose file and analysis + charts come up)
  - during winter time, 6:30 workout starts at 5:30, in summer 10 am workout starts at 8am when reading from tcx
  - run statistics and charts on _merge.csv files



- multiple files
  - some statistics from that dataframe (personal bests, max values)
  - plots = charts
  - Shiny (total statistics)
