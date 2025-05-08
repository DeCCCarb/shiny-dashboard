
library(tidyverse)
library(usdata)
library(tmap)
library(tigris)



# Step 2: Load the necessary libraries
library(tmap)
library(usdata)

usa <- states(cb=TRUE) |> 
    janitor::clean_names() |> 
    filter(stusps %in% c('NV', 'AZ', 'OR', 'ID'))

# Step 3: Get the shapefile for California counties
california_counties <- counties(state = "CA", cb = TRUE) |> 
    filter(NAME %in% c('Ventura', 'Santa Barbara', 'San Luis Obispo'))

california <- counties(state = "CA", cb = TRUE) 

bbox <- california |> 
    filter(NAME %in% c('Monterey', 'Los Angeles'))

# Step 4: Create a tmap visualization
# tm_graticules(labels.pos = c("right", "top"), )+

ccc <- tm_shape(usa, bbox = california) +
    tm_fill(col = '#dee0e4') +
    tm_graticules(alpha = .5) +
    tm_shape(california) +
    tm_polygons(col = 'NAME',
                palette = '#8bccb7',
                border.col = '#83c0c0',
                border.alpha = .5
            ) +
    tm_shape(california_counties) +
    tm_polygons(col = 'NAME',
                palette = '#e6863e',
                border.col = '#d77f79',
                border.alpha = .5) +
      # tm_compass(type = "8star",
      #          position = c(.1, .15),               # Position 8 star compass inside the boundaries
      #          size = 3) +
 #   tm_scale_bar(position = c(0.10, .05)) +   # Likewise positioning the scale bar accordingly
    tm_layout(frame = FALSE,
              main.title = "California Central Coast",
              main.title.position = "center",
              #bg.color = "#edf1efff",
              fontfamily = "Commissioner") +

    tm_legend(show = FALSE)


ccc
tmap_save(ccc, here::here('www', "california_counties_map.png"), dpi = 600)
 