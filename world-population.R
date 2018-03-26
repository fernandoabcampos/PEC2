library(plotly)
library(dplyr)
library(countrycode) # it was necessary to install.pagckages("countrycode")

countries <- read_excel("~/Desktop/Master - Data Science/UOC/Data Mining/PECs/2-20180328/countries.xlsx")
relevant_labels <- c("NAME", "CAPITAL", "TOTAL_AREA_KM2", "POPULATION", "DENSITY_KM2", "CAPITAL", "RURAL_POPULATION", "URBAN_POPULATION")
relevant_country_data <- countries[relevant_labels]
relevant_country_data["COUNTRY_CODE"] <- countrycode(relevant_country_data$NAME, 'country.name', 'iso3c')
relevant_country_data <- relevant_country_data[rowSums(is.na(relevant_country_data)) == 0,] # quitando lineas con N.A.

world <- map_data("world") # obtener datos como latitud y longitud



ordered_data_cities <- world.cities[world.cities$capital == '1', ] # ordenando por region y grupo
world_cities_with_coord <- ordered_data_cities[!duplicated(ordered_data_cities$country.etc),] # cogendo solo el primer valor del listado
#world_cities_with_coord <- subset(world_with_coord, select = c("lat", "long", "region")) # transformacion reducindo atributos
world_cities_with_coord["COUNTRY_CODE"] <- countrycode(world_cities_with_coord$country.etc, 'country.name', 'iso3c')

help.search("right_join")
countries_cities_with_lat_long <- right_join(world_cities_with_coord, relevant_country_data, by = "COUNTRY_CODE" ) #c("region" = "NAME")) 
head(countries_cities_with_lat_long)

countries_cities_with_lat_long$q <- with(countries_cities_with_lat_long, cut(POPULATION, quantile(POPULATION)))
levels(countries_cities_with_lat_long$q) <- paste(c("1st", "2nd", "3rd", "4th", "5th"), "Quantile")
countries_cities_with_lat_long$q <- as.ordered(countries_cities_with_lat_long$q)

#help.search("countrycode")
#countrycode('UK', 'country.name', 'iso3c')
#countrycode('United Kingdom', 'country.name', 'iso3c')


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

# Create a shareable link to your chart
# Set up API credentials: https://plot.ly/r/getting-started
chart_link = api_create(p, filename="scattergeo-bubble")
chart_link