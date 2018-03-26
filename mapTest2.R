df <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv')
library(readxl) 
df_countries <- read_excel("~/Downloads/countries.xlsx")
Sys.setenv("plotly_username"="fernando.barbeiro")
Sys.setenv("plotly_api_key"="4eje4XY6wEABSvie9Jd")

library(plotly)
help.search("toRGB")
# light grey boundaries
l <- list(color = toRGB("grey"), width = 0.5)

# specify map projection/options
gp <- plot_geo(df) %>%
  add_trace(
    z = ~GDP..BILLIONS., color = ~GDP..BILLIONS., colors = 'Blues',
    text = ~COUNTRY, locations = ~CODE, marker = list(line = l)
  ) %>%
  colorbar(title = 'GDP Billions US$', tickprefix = '$') %>%
  layout(
    title = '2014 Global GDP<br>Source:<a href="https://www.cia.gov/library/publications/the-world-factbook/fields/2195.html">CIA World Factbook</a>',
    geo = g
  )

# Create a shareable link to your chart
# Set up API credentials: https://plot.ly/r/getting-started
chart_link = api_create(p, filename="choropleth-world")
chart_link