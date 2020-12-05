library(tidyverse)
library(leaflet)

data <- read.csv("data/SafeU_geocoded.csv", encoding = "latin-1")
data <- data %>% mutate(Date=as.Date(Date, "%m-%d-%Y"),
                        Time=as.Date(Time, "%H:%M"))



displayTypes <- data %>% filter(Type != "Update") %>% group_by(Type) %>% summarize(n = n()) %>% arrange(n) %>% filter(n > 1) %>% pull(Type)
data %>% 
  filter(Type != "Update") %>%
  mutate(SpecialType = Type,
         SpecialType = replace(SpecialType, SpecialType == "Shooting", "Other"),
         SpecialType = replace(SpecialType, SpecialType == "Chemical Spill", "Other"),
         SpecialType = replace(SpecialType, SpecialType == "Bomb Threat", "Other"),
         SpecialType = replace(SpecialType, SpecialType == "Rabies", "Other"),
         SpecialType = replace(SpecialType, SpecialType == "Barricade", "Other"),
         SpecialType = replace(SpecialType, SpecialType == "Chemical Spill", "Other"),
         SpecialType = replace(SpecialType, SpecialType == "Attempted Carjacking", "Other")) %>%
  leaflet() %>% 
  addTiles() %>%
  addProviderTiles(providers$Stamen.Toner, group = "Toner") %>%
  addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
  addMarkers(~long, ~lat, popup = ~Description, label = ~Type, group = ~SpecialType) %>%
  addLayersControl(
    baseGroups = c("OSM (default)", "Toner", "Toner Lite"),
    overlayGroups = c(displayTypes, "Other")
  )

data %>% ggplot(aes(x = Type)) + geom_histogram(stat="count")
