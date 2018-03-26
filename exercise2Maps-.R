#install.packages("plotly", dependencies = TRUE)
Sys.setenv("plotly_username"="fernando.barbeiro")
Sys.setenv("plotly_api_key"="6vP51eZN46dDUq6IbvVp")

library(plotly)
df <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2014_us_cities.csv')

df$q <- with(df, cut(pop, quantile(pop)))
levels(df$q) <- paste(c("1st", "2nd", "3rd", "4th", "5th"), "Quantile")
df$q <- as.ordered(df$q)



g <- list(
  scope = 'world',
  projection = list(type = 'albers usa'),
  showland = TRUE,
  landcolor = toRGB("gray85"),
  subunitwidth = 1,
  countrywidth = 1,
  subunitcolor = toRGB("white"),
  countrycolor = toRGB("white")
)

p <- plot_geo(df, locationmode = 'USA-states', sizes = c(1, 250)) %>%
  add_markers(
    x = ~lon, y = ~lat, size = ~pop, color = ~q, hoverinfo = "text",
    text = ~paste(df$name, "<br />", df$pop/1e6, " million")
  ) %>%
  layout(title = '2014 US city populations<br>(Click legend to toggle)', geo = g)

# Create a shareable link to your chart
# Set up API credentials: https://plot.ly/r/getting-started
chart_link = api_create(p, filename="scattergeo-bubble")
chart_link