server <- function(input, output){
    
    # Generate workforce development map tool ----
    output$county_map_output <- renderLeaflet({
        
        counties_input <- reactive({
            counties |>
                filter(County == input$county_input) 
        })
        
        port_input <- reactive({
            #     port_name = c("Hueneme", "Morro Bay"),
            #     address = c(
            #         "Port of Hueneme, Port Hueneme, CA 93041",
            #         "699 Embarcadero #11, Morro Bay, CA 93442"
            #     )
            # ) %>%
            #     tidygeocoder::geocode(address = address,
            #                           method = "osm") %>%
            #     sf::st_as_sf(coords = c("long", "lat"), crs = 4326) |> 
            data.frame(
                port_name = c("Hueneme", "Morro Bay"),
                address = c(
                    "Port of Hueneme, Port Hueneme, CA 93041",
                    "699 Embarcadero, Morro Bay, CA 93442"
                )
            ) %>%
                tidygeocoder::geocode(address = address, method = "osm") |> 
                # tidyr::drop_na(lat, long) %>%
                # sf::st_as_sf(coords = c("long", "lat"), crs = 4326) |> 
                filter(port_name == input$port_input)
            
        })
        
        icons <- awesomeIcons(
            icon = 'helmet-safety',
            iconColor = 'black',
            library = 'fa',
            markerColor = "orange"
        )
        
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
            addPolygons(data=ca_counties) |> 
            addAwesomeMarkers(data = port_input(),
                              lng = port_input()$long,
                              lat = port_input()$lat,
                              icon = icons)
        
    })
    
    # Generate the plot of jobs based on user selection ---
    # output$model_jobs_output <- renderPlot({
    #     # Match this up with the leaflet plot ----
    #     job_tech_input <- reactive({
    #         osw 
    #            # filter(county == input$county_input) |> 
    #            # filter(technology == input$technology_input) 
    #     })
    #     
    #     ggplot(job_tech_input()) +
    #         geom_col(aes(x = year, y = total_jobs, fill = occupation),
    #                  position = "stack") +
    #         labs(title = "Projected Direct Jobs in SLO, Ventura, and SB Counties",
    #              y = "FTE Jobs") +
    #         scale_y_continuous(labels = scales::label_comma()) +
    #         scale_fill_manual(values = c("#9CBEBE", "#DAE6E6")) +
    #         theme_minimal() +
    #         theme(
    #             axis.title.x = element_blank()
    #         )
    # }) 
    
    # Choose your technology
    # Generate the plot of jobs based on user selection ---
    output$model_jobs_output <- renderTable({
        tech <- input$technology_input
        
        if (tech == 'Floating Offshore Wind') {
            # Floating Offshore Wind ------
            # O&M OSW --
            osw_om <- calculate_osw_om_jobs(
                county = "Tri-county",
                start_year = 2025,
                end_year = 2045,
                ambition = "High",
                initial_capacity = input$initial_capacity_input,
                target_capacity = input$final_capacity_input,
                direct_jobs = 127,
                indirect_jobs = 126,
                induced_jobs = 131
            )
            
            # Construction OSW -- 
            osw_construction <- calculate_osw_construction_jobs(
                county = "Tri-County",
                start_year = 2025, 
                end_year = 2045, 
                ambition = "High", 
                initial_capacity = input$initial_capacity_input,
                target_capacity = input$final_capacity_input,
                direct_jobs = 82, 
                indirect_jobs = 2571, 
                induced_jobs = 781
            )
            
            osw_all <- rbind(osw_construction, osw_om)
            return(osw_all)
        }
    })
    
}

# Create dataframe that has each of the counties initial capacity and final capacity goals
utility_targets=data.frame(expand.grid(counties=c('San Luis Obispo', 'Santa Barbara', 'Ventura'),
                                    initial=c(1615.82, 110.86, 6.72),
                                    final = c(10524.86, 722.08, 43.76))) |> 
    group_by(counties)

# rooftop_targets = data.frame(expand.grid(counties=c('San Luis Obispo', 'Santa Barbara', 'Ventura'),
#                                          initial=c(344.84, 242.02, 424.20),
#                                          final = c(1843.69, 1293.94, 3026.38)))


# Create the original long-format data frame
rooftop_targets <- expand.grid(
    counties = c('San Luis Obispo', 'Santa Barbara', 'Ventura'),
    values = c("initial", "final")
)

# Add capacity values
rooftop_targets$capacity <- c(344.84, 242.02, 424.20, 1843.69, 1293.94, 3026.38)

# Pivot to wide format
rooftop_targets <- df_long %>%
    pivot_wider(names_from = counties, values_from = capacity)

# View the result
print(rooftop_targets)



# Create the long-format dataframe
utility_targets_long <- expand.grid(
    counties = c('San Luis Obispo', 'Santa Barbara', 'Ventura'),
    values = c("initial", "final")
)

# Add capacity values
utility_targets_long$capacity <- c(1615.82, 110.86, 6.72, 10524.86, 722.08, 43.76)

# Pivot to wide format
utility_targets <- utility_targets_long %>%
    pivot_wider(names_from = counties, values_from = capacity)

# View result
print(utility_targets)
