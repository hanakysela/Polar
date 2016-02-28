# Polar with R

## The idea behind
1. Manually download .tcx and .csv file from the [Polar Flow](wwww.flow.polar.com) website (preferably to a Dropbox folder)
2. run the `Polar.R` script (it contains a `PolarRead` function, or more likely the `PolarReadAll` function that loops through unprocessed files and PolarReads them.

The output is two .csv files (into a Dropbox subfolder)

- xxx_data.csv that contains all the available info in a nice csv file
- xxx_info.csv that has only one line of important values (max speed, average HR, dist, duration, ...)




## The goal
- Get familiar with R working on a topic that I like.
- learn ggplot and plot maps
- If things work, I would like to be able to recreate Endomondo/Polar functionality without the need of internet - and also doing something with the back-up exports I always do.
- learn a bit of Shiny




## Done so far

- organizing the files so there is some system (and they are properly = nicely named)
- using Git
- script that reads the files, cleanes them and outputs the things I wanted
- added text to inform what files will be read and what is currently happening
- dont drop cadence, power and stride-length - I now (Feb 2016) have wrist-based cadence for running and walking (shamefully, hiking is now excluded in that Polar update). 
- add heart rate zone limits
  0. do 93:white	Rest
  1. 94-112:gray	Warm Up
  2. 113-131:blue	Fat Burning
  3. 132-149:green	Aerobic
  4. 150-168:yellow	Anaerobic
  5. 169-188:red	Maximum
  
  aim: 
      calculate time spent in each zone
      add colour to the map
  

### xxx_data.csv file
done some plotting (w/google maps)

### xxx_info.csv
- merge of all headers into one file ('infotable.df")
- plotting some overview statistics




## ToDo
- Individual Plots
  - Different axes (alt, HR, speed, cadence) - not possible with ggplot2?!?

- can I speed up the parsing ?!?

- output to public Dropbox (the infotable copy + some charts?)

- what to do when new sport is added? (Feb2016 - first cross country skiing) - set default color for each sport

- option2 to access dropbox files on the internet, not only those stored on C:\

- individual files
  - smooting the curves (make them look like in Polar Flow) - or at least dont plot zero values for HR (that is nonsense)
  - handling situations when I pause the workout and then remember to resume after 5 minutes into the resumed workout
  - pausing vs time stamp
  - during winter time, 6:30 workout starts at 5:30, in summer 10 am workout starts at 8am when reading from tcx
  - run statistics and charts on _merge.csv files
  - function to plot files (if SWIMMING, only show small chart, if HIKING, show elevation, map, ...) but this information is stored elsewhere (info file) - not anymore :) Feb2016
  - Shiny (chose file and analysis + charts come up) 2nd tab

- multiple files
  - some statistics from that dataframe (personal bests, max values)
  - align sport colors with Endomondo colors (swim=blue, bike=yellow, ...)
  - triathlon related trainings analysis
  - running index trend
  - plots = charts
  - Shiny (total statistics) - 1st tab
  - punch card (when I tend to do sports) - first draft on 2015_11_21, but I only have November data
  - last 90 days (yearly statistics already available, next work is expected in January next year)


- nice to have
	- analyze swim data (scrape from Flow?)
	- SWOLF trend
	- analyze activity data (scrape from Flow?)
	- align with google docs file with weights
	- trainload analysis
	- calories of fat burned
	- heatmap on map (where the workouts started?)
	- strava-like "where do people run the most"
	- how are laps handled? (and when do I actually use them?)
	