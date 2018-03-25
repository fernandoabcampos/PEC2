# install.packages(c("ggplot2", "devtools", "dplyr", "stringr"), dependencies = TRUE) # generic packages
# install.packages(c("maps", "mapdata", "ggmap"), dependencies = TRUE) # deal with maps

library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)
library(dplyr)

citation('ggmap')
world <- map_data("world")
countries <- read_excel("~/Desktop/Master - Data Science/UOC/Data Mining/PECs/2-20180328/countries.xlsx")
relevant_labels <- c("NAME", "CAPITAL", "TOTAL_AREA_KM2", "POPULATION", "DENSITY_KM2")
relevant_country_data <- countries[relevant_labels]

worldssss  <- world[world$region %in% world.cities$country.etc, ]

unique(worldssss[,c('region')])
aaaaa<-group_by(worldssss, worldssss$group, add = FALSE)
#right_join(world.cities, 
           
res <- subset(world, 
       subset = !duplicated(world[c("group")]),
       select = c("group", "lat", "long", "region"))
           

library(data.table)
dt <- data.table(world, key="group, lat, long, region")    
dt[cumsum>=99, .SD[1], by=key(dt)]


res <- map_data("world")
res <- subset(res, 
              subset = !duplicated(res[c("region")]),
              select = c("group", "lat", "long", "region"))

res2 <- !duplicated(countries[c("NAME")])
res2 

countries_density <- subset(countries, select = c("NAME", "DENSITY_KM2"))

countries_with_lat_long <- right_join(res, countries_density, by = c("region" = "NAME"))           
           

countries_withr_lat_long <- right_join(world.cities[world.cities$capital == '1', ], relevant_country_data, by = c("country.etc" = "NAME"))

# ggplot() + geom_polygon(data = world, aes(x=long, y = lat, group = group), col="white") + 
#  coord_fixed(1.3)
ditch_the_axes <- theme(
  axis.text = element_blank(),
  axis.line = element_blank(),
  axis.ticks = element_blank(),
  panel.border = element_blank(),
  panel.grid = element_blank(),
  axis.title = element_blank()
)

head(world)

world_base <- ggplot(data = countries_with_lat_long, mapping = aes(x = long, y = lat, group = group)) + 
  coord_fixed(1.3) + 
  geom_polygon(fill = "gray")
world_base + theme_nothing()

countries_with_lat_long$people_per_km <- countries_with_lat_long$DENSITY_KM2

global_plot <- world_base + 
  geom_polygon(data = countries_with_lat_long, aes(fill = DENSITY_KM2), color = "white") +
  geom_polygon(color = "white", fill = NA) +
  theme_bw() +
  ditch_the_axes

head(countries_with_lat_long)

global_plot
head(countries_with_lat_long)
global_plot + scale_fill_gradient(trans = "log10")


elbow_room1 <- world_base + 
  geom_polygon(data = countries_with_lat_long, aes(fill = people_per_km), color = "white") +
  geom_polygon(color = "black", fill = NA) +
  theme_bw() +
  ditch_the_axes

elbow_room1 + scale_fill_gradient(trans = "log10")




ggplot(world, aes(long, lat, group=group, fill=countries_with_lat_long$people_per_km)) +
  geom_polygon() + 
  ggtitle("Hong Kong 18 Districts: Area")
