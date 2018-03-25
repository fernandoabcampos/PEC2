# used by pie3D
# install.packages("plotrix") # required
library(plotrix) 

library(readxl) # used by View funcion


setwd("~/Desktop/Master - Data Science/UOC/Data Mining/PECs/2-20180328/PEC2/")

countries <- read_excel("~/Desktop/Master - Data Science/UOC/Data Mining/PECs/2-20180328/countries.xlsx")

head(countries) # first 6 rows
tail(countries) # last 6 rows
dim(countries) # object dimension

#View(countries)

# First plot, countries distribution per continent
continents <- table(countries$CONTINENT)

bp <- barplot(continents
        , main = 'Countries by Continent'
        , ylab = 'Amount of countries'
        , args.legend = TRUE
        , col = rainbow(5)
      )

text(x=bp, y=continents, labels=round(continents,0), pos=3, xpd=NA)

# Second chart
# Pie Chart from data frame with Appended Sample Sizes
lbls <- paste(names(continents), "\n", continents, sep="")
pie3D(continents
    , radius=0.9
    , labelcex= 0.8
    , labels = lbls
    , explode=0.1
    , main="Countries by Continents"
    , col = rainbow(length(lbls)
  ))


