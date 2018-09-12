library(EIAdata)
library(tidyverse)

setwd("G://AverageAnalytics/Projects/EIA_Dta")
key <- "e5456a5a7c1050d86ddbf7edfa04c0ea"

# Get most general categories
all <- EIAdata::getCatEIA(key)

#store category id & names in new object
eia.cats <- tibble(id = all$Sub_Categories$category_id %>% as.character(),
                   name = all$Sub_Categories$name %>% as.character(),
                   level = 1
                   )


#loop to get all sub-categories
for(i in 1:nrow(eia.cats)){
  print(i)
  foo <- EIAdata::getCatEIA(key,eia.cats$id[i])

  bar <- tibble(id = foo$Sub_Categories$category_id %>% as.character(),
         name = paste(eia.cats$name[i],"!!!",foo$Sub_Categories$name %>% as.character()),
         level = 2)

  eia.cats <- eia.cats %>% rbind(bar)

}

# loop for all sub-sub-categories
for(i in 1:nrow(eia.cats)){
  if(eia.cats$level[i] == 2){
  print(i)
  foo <- EIAdata::getCatEIA(key,eia.cats$id[i])

  bar <- tibble(id = foo$Sub_Categories$category_id %>% as.character(),
                name = paste(eia.cats$name[i],"!!!",foo$Sub_Categories$name %>% as.character()),
                level = 3)

  eia.cats <- eia.cats %>% rbind(bar)
  }
}

# loop for all sub-sub-sub-categories
for(i in 1:nrow(eia.cats)){
  if(eia.cats$level[i] == 3){
    print(i)
    foo <- EIAdata::getCatEIA(key,eia.cats$id[i])

    bar <- tibble(id = foo$Sub_Categories$category_id %>% as.character(),
                  name = paste(eia.cats$name[i],"!!!",foo$Sub_Categories$name %>% as.character()),
                  level = 4)

    eia.cats <- eia.cats %>% rbind(bar)
  }
}

# Create Empty Object
eia.series <- tibble(series_id = "",name = "",f = "",units = "",updated = "")

# Populate Empty Object with Series info
for(i in i:nrow(eia.cats)){
    print(i)
    foo <- EIAdata::getCatEIA(key,eia.cats$id[i])


    if(nrow(foo$Series_IDs) != 0){

    bar <- foo$Series_IDs %>% as.tibble()

    eia.series <- eia.series %>% rbind(bar)
  }
}

eia.series <- eia.series[!eia.series$series_id %>% duplicated(),]

write_csv(eia.cats,"categories.csv")
write_csv(eia.series,"series.csv")

