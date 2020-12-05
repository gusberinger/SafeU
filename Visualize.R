library(tidyverse)
library(leaflet)

data <- read.csv("data/SafeU_geocoded.csv", encoding = "latin-1")
data <- data %>% mutate(Date=as.Date(Date, "%m-%d-%Y"),
                        Time=as.Date(Time, "%H:%M"))



displayTypes <- data %>% filter(Type != "Update") %>% group_by(Type) %>% summarize(n = n()) %>% arrange(n) %>% filter(n > 1) %>% pull(Type)
data %>% 
  filter(Type != "Update") %>%
  mutate(Type = replace(Type, Type == "Shooting", "Other"),
         Type = replace(Type, Type == "Chemical Spill", "Other"),
         Type = replace(Type, Type == "Bomb Threat", "Other"),
         Type = replace(Type, Type == "Rabies", "Other"),
         Type = replace(Type, Type == "Barricade", "Other"),
         Type = replace(Type, Type == "Chemical Spill", "Other")) %>%
  leaflet() %>% 
  addTiles() %>%
  addProviderTiles(providers$Stamen.Toner, group = "Toner") %>%
  addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
  addMarkers(~long, ~lat, popup = ~Description, label = ~Type, group = ~Type) %>%
  addLayersControl(
    baseGroups = c("OSM (default)", "Toner", "Toner Lite"),
    overlayGroups = c(displayTypes, "Other")
  )

data %>% ggplot(aes(x = Type)) + geom_histogram(stat="count")
