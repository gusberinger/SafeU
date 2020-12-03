library(tidyverse)
library(leaflet)
library(shiny)

data <- read.csv("SafeU_geocoded.csv")
data <- data %>% mutate(Date=as.Date(Date, "%m-%d-%Y"),
                        Time=as.Date(Time, "%H:%M"))

data %>% ggplot(aes(x = Date, y = Time)) + geom_point()


icon.glyphicon <- makeAwesomeIcon(icon= 'flag', markerColor = 'blue', iconColor = 'black')
icon.fa <- makeAwesomeIcon(icon = 'flag', markerColor = 'red', library='fa', iconColor = 'black')
icon.ion <- makeAwesomeIcon(icon = 'home', markerColor = 'green', library='ion')
data %>% filter(Type != "update") %>% leaflet() %>% addTiles() %>%
  addMarkers(~long, ~lat, popup = ~Description, label = ~Type)

