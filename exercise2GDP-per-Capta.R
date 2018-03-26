library(readxl) # used by View funcion

countries <- read_excel("~/Desktop/Master - Data Science/UOC/Data Mining/PECs/2-20180328/countries.xlsx")

# First plot, countries distribution per continent
relevant_labels <- c("NAME", "CONTINENT", "GDP_$_PER_CAPITA")
continents_gdp_per_capta <- countries[relevant_labels]

head(continents_gdp_per_capta)

boxplot(`GDP_$_PER_CAPITA`/1000 ~ CONTINENT
        , col=rainbow(length(unique(continents_gdp_per_capta$CONTINENT)))
        , data=continents_gdp_per_capta
        , main="GDP $ per capta by Continents"
        , ylab = 'Amount per capta (K)'
      )
