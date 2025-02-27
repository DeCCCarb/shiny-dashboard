server <- function(input, output){
    
# Generate workforce development map tool ----
output$county_map_output <- renderLeaflet({
        
        counties_input <- reactive({
            counties |>
                filter(County == input$county_input)
        })
        
        # sample California Central Coast map using leaflet ----
        leaflet() |>
            addProviderTiles(providers$OpenStreetMap) |>
            setView(lng = -119.698189,
                    lat = 34.420830,
                    zoom = 7) |>
            # addMiniMap(toggleDisplay = TRUE,
            #             minimized = FALSE) |>
            addMarkers(data = counties_input(),
                       lng = counties_input()$Longitude,
                       lat = counties_input()$Latitude,
                       popup = paste0('County: ', counties_input()$County, '<br>',
                                      '% current fossil fuel workers ____', '<br>',
                                      'Projected Job Loss___', '<br',
                                      'Projected Job Gain ____'))
        
    })
}