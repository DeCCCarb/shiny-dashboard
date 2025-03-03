
library(tidyverse)
library(usdata)
library(tmap)
library(tigris)



# Step 2: Load the necessary libraries
library(tmap)
library(usdata)

# Step 3: Get the shapefile for California counties
california_counties <- counties(state = "CA", cb = TRUE) |> 
    filter(NAME %in% c('Ventura', 'Santa Barbara', 'San Luis Obispo'))

california <- counties(state = "CA", cb = TRUE) 

bbox <- california |> 
    filter(NAME %in% c('Monterey', 'Los Angeles'))

# Step 4: Create a tmap visualization
ccc <- tm_shape(california) +
    tm_fill(fill = '#f4f3ee') +
    tm_shape(california_counties) +
    tm_borders() + 
    tm_polygons(col = 'NAME',
                palette = c('Ventura' = '#c9ada7',                                    # Color each grade in order
                            'Santa Barbara' = '#9a8c98',
                            'San Luis Obispo' = '#4a4e69')) +
    #   tm_compass(type = "8star",
    #            position = c(.1, .15),               # Position 8 star compass inside the boundaries 
    #            size = 3) +
    # tm_scale_bar(position = c(0.10, .05)) +   # Likewise positioning the scale bar accordingly
    tm_layout(frame = FALSE,
              main.title = " ",
              main.title.position = "center",
              #bg.color = "#edf1efff",
              fontfamily = "serif") +
    tm_legend(show = FALSE)

tmap_save(ccc, here::here("www", "california_counties_map.png"))
