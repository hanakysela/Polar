## Install packages
# install.packages("devtools")
# install.packages("Rtools")
# find_rtools()

# install_github("ramnathv/htmlwidgets") 
# install_github("smartinsightsfromdata/rpivotTable")

## Load rpivotTable
library(devtools)
library(rpivotTable)


rpivotTable(infotable, 
            rows="when", 
            col="sport", 
            aggregatorName="Sum", 
            vals="trainload", 
            rendererName="Table")