# Required packages (might be necessary if library cannot be imported)
# install.packages(c("readxl", "plotrix", "countrycode"), dependencies = TRUE)

# PLEASE: In order to test, execute this boilerplate part (imports, keys, etc) and then execute the chunks of code
# separetely according to the comments delimiters: that is: Exercise 2 chart by chart, then exercise 3 and then 4.
# Thanks, regards

library(plotrix) 
library(readxl) 
library(plotly) 
library(dplyr)
library(countrycode)

# KEYS REQUIRED (it might be interesting to use your own keys if you want, mine are available)
Sys.setenv("plotly_username"="fernando.barbeiro")
Sys.setenv("plotly_api_key"="N8hSiiCTp8m0xiPRZEgr")


# setwd("~/Desktop/Master - Data Science/UOC/Data Mining/PECs/2-20180328/PEC2/")

countries <- read_excel("~/Desktop/Master - Data Science/UOC/Data Mining/PECs/2-20180328/countries.xlsx")

############################## EXERCISE 2 #####################################

## -------------------- chart countries by continent --------------------------------
summary(countries)

continents <- table(countries$CONTINENT)
lbls <- paste(names(continents), "\n", continents, sep="")
pie3D(continents
      , radius=0.9
      , labelcex= 0.8
      , labels = lbls
      , explode=0.1
      , main="Countries by Continents"
      , col = rainbow(length(lbls)
      ))
## ----------------------------------------------------------------------------------

## -------------------- chart GDP $ per capta per continent -------------------------
relevant_labels <- c("NAME", "CONTINENT", "GDP_$_PER_CAPITA")
continents_gdp_per_capta <- countries[relevant_labels]

head(continents_gdp_per_capta)

boxplot(`GDP_$_PER_CAPITA`/1000 ~ CONTINENT
        , col=rainbow(length(unique(continents_gdp_per_capta$CONTINENT)))
        , data=continents_gdp_per_capta
        , main="GDP $ per capta by Continents"
        , ylab = 'Amount per capta (K)'
)
## ----------------------------------------------------------------------------------

## -------------------- Tridimensional GDP $ / Doctors / Grow Rate  -------------------------
grow_labels <- c("NAME", "CONTINENT", "GDP_GROW_RATE", "GDP_$_PER_CAPITA", "DOCTORS")
grow_per_doctors <- countries[grow_labels]
head(grow_per_doctors)

p <- plot_ly(grow_per_doctors, x = ~GDP_GROW_RATE, y = ~`GDP_$_PER_CAPITA`, z = ~DOCTORS, color = ~CONTINENT, colors = rainbow(length(unique(grow_per_doctors$CONTINENT)))
             , text = ~paste('Country:', NAME, '<br>Nº Doctors:', DOCTORS, '<br>GDP $ per capta:', `GDP_$_PER_CAPITA`,
                             '<br>GDP Grow.:', GDP_GROW_RATE)
) %>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'GDP Grow Rate'),
                      yaxis = list(title = 'GDP $ per capta'),
                      zaxis = list(title = 'Nº Doctors')))

chart_link = api_create(p, filename="scatter3d-basic")
chart_link
## ----------------------------------------------------------------------------------

## -------------------- Interactive map population density  -------------------------
relevant_labels <- c("NAME", "CAPITAL", "TOTAL_AREA_KM2", "POPULATION", "DENSITY_KM2", "CAPITAL", "RURAL_POPULATION", "URBAN_POPULATION")
relevant_country_data <- countries[relevant_labels]
relevant_country_data["COUNTRY_CODE"] <- countrycode(relevant_country_data$NAME, 'country.name', 'iso3c')
relevant_country_data <- relevant_country_data[rowSums(is.na(relevant_country_data)) == 0,] # quitando lineas con N.A.

world <- map_data("world") # obtener datos como latitud y longitud



ordered_data_cities <- world.cities[world.cities$capital == '1', ] # ordenando por region y grupo
world_cities_with_coord <- ordered_data_cities[!duplicated(ordered_data_cities$country.etc),] # cogendo solo el primer valor del listado
world_cities_with_coord["COUNTRY_CODE"] <- countrycode(world_cities_with_coord$country.etc, 'country.name', 'iso3c')
world_cities_with_coord <- world_cities_with_coord[rowSums(is.na(world_cities_with_coord)) == 0,]
help.search("right_join")
countries_cities_with_lat_long <- right_join(world_cities_with_coord, relevant_country_data, by = "COUNTRY_CODE" ) #c("region" = "NAME")) 
head(countries_cities_with_lat_long)

countries_cities_with_lat_long$q <- with(countries_cities_with_lat_long, cut(POPULATION, quantile(POPULATION)))
levels(countries_cities_with_lat_long$q) <- paste(c("1st", "2nd", "3rd", "4th", "5th"), "Quantile")
countries_cities_with_lat_long$q <- as.ordered(countries_cities_with_lat_long$q)

g <- list(
  scope = 'world',
  projection = list(type = 'world2'),
  showland = TRUE,
  landcolor = toRGB("gray85"),
  subunitwidth = 1,
  countrywidth = 1,
  subunitcolor = toRGB("white"),
  countrycolor = toRGB("white")
)

p <- plot_geo(countries_cities_with_lat_long, locationmode = 'world', sizes = c(1, 25000)) %>%
  add_markers(
    x = ~long, y = ~lat, size = ~POPULATION, color = ~q, hoverinfo = "text",
    text = ~paste(countries_cities_with_lat_long$country.etc
                  , "<br />"
                  , countries_cities_with_lat_long$POPULATION/1e6, " million"
                  , "<br /> Urban Population: ", countries_cities_with_lat_long$URBAN_POPULATION, " %")
  ) %>%
  layout(title = 'World populations density PEC2<br>', geo = g)

chart_link2 = api_create(p, filename="scattergeo-bubble")
chart_link2
## ----------------------------------------------------------------------------------


############################## EXERCISE 3 #####################################

nat <- countries$NATURAL_GROWTH

is.factor(nat) # false / possible continuos
is.numeric(nat) # true

summary(nat)
hist(nat)
nat_grow_cat=cut(nat, br=c(-1.9, 15, 25, 30), labels = c("crec_bajo", "crec_moderado", "crec_alto"))
table(nat_grow_cat)

nat_grow_cat2=cut(nat, 3)
table(nat_grow_cat2)

barplot(table(nat_grow_cat))

############################## EXERCISE 4 #####################################
barrel_labels <- c("NAME", "CRUDE_OIL_BAR_DAY")
barrels <- countries[barrel_labels]

barrels <- barrels[rowSums(is.na(barrels)) == 0,]
head(barrels)
barrels$CRUDE_OIL_BAR_DAY <- barrels$CRUDE_OIL_BAR_DAY / 10e2
head(barrels)


barplot(barrels$CRUDE_OIL_BAR_DAY
        , main="Oil barrels per country"
        , horiz=TRUE
        , ylab = "Countries"
        , names.arg=barrels$NAME
        , xlab = "valores x 1000"
        , cex.names=0.6
        , col = rainbow(length(unique(barrels$NAME))))
