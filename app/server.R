server <- function(input, output){
    
# Generate workforce development map tool ----
output$county_map_output <- renderLeaflet({
        
        counties_input <- reactive({
            counties |>
                filter(County == input$county_input)
        })
        
        # sample California Central Coast map using leaflet ----
        leaflet() |>
            addProviderTiles(providers$Stadia.StamenTerrain) |>
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
                                      'Projected Job Gain ____')) |> 
           # addTiles() %>% 
            addPolygons(data=ca_counties)
        
    })

# Generate the plot of jobs based on user selection ---
output$model_jobs_output <- renderPlot({
    # Match this up with the leaflet plot ----
    job_tech_input <- reactive({
        osw 
           # filter(county == input$county_input) |> 
           # filter(technology == input$technology_input) 
    })
    
    ggplot(job_tech_input()) +
        geom_col(aes(x = year, y = total_jobs, fill = occupation),
                 position = "stack") +
        labs(title = "Projected Direct Jobs in SLO, Ventura, and SB Counties",
             y = "FTE Jobs") +
        scale_y_continuous(labels = scales::label_comma()) +
        scale_fill_manual(values = c("#9CBEBE", "#DAE6E6")) +
        theme_minimal() +
        theme(
            axis.title.x = element_blank()
        )
}) 
    
        
}