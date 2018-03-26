library(plotly)
grow_labels <- c("NAME", "CONTINENT", "GDP_GROW_RATE", "GDP_$_PER_CAPITA", "DOCTORS")
grow_per_doctors <- countries[grow_labels]
head(grow_per_doctors)

Sys.setenv("plotly_username"="fernando.barbeiro")
Sys.setenv("plotly_api_key"="65ogh8VsqAH6tqNlemP4")

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
