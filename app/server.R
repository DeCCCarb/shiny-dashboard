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
output$model_jobs_output <- if(input$technology_input == 'Floating Offshore Wind'){
    # Floating Offshore Wind ------
    # O&M OSW --
    osw_om <- reactive({calculate_osw_om_jobs(county = "Tri-county",
                                                   start_year = 2025,
                                                   end_year = 2045,
                                                   ambition = "High",
                                                   initial_capacity = input$initial_capacity_input,
                                                   target_capacity = input$final_capacity_input,
                                                   direct_jobs = 127,
                                                   indirect_jobs = 126,
                                                   induced_jobs = 131)}) 
    # Construction OSW -- 
    osw_construction <- reactive({calculate_osw_construction_jobs(county = "Tri-County",
                                                                       start_year = 2025, 
                                                                       end_year = 2045, 
                                                                       ambition = "High", 
                                                                       initial_capacity = input$initial_capacity_input,
                                                                       target_capacity = input$final_capacity_input,
                                                                       direct_jobs = 82, 
                                                                       indirect_jobs = 2571, 
                                                                       induced_jobs = 781)})
    osw_all <- reactive(rbind(osw_construction(), osw_om()))
    
        #filter(type == "indirect") |>
        ggplot(osw_all()) +
        geom_col(aes(x = year, y = n_jobs)) #+
    labs(title = "Projected direct jobs in CA Central Coast from floating OSW development",
         y = "FTE Jobs") +
        scale_y_continuous(labels = scales::label_comma(),
                           limits = c(0,2000)) +
        scale_fill_manual(labels = c("Construction Jobs", "Operations & Maintenance Jobs"),
                          values = c("#4a4e69", "#9a8c98")) +    
        theme_minimal() +
        theme(
            axis.title.x = element_blank(),
            axis.title.y = element_text(size = 24, margin = margin(5,20,0,10)),
            axis.text = element_text(size = 20), 
            legend.title = element_blank(),
            legend.text = element_text(size = 20),
            legend.position = "bottom",
            plot.background = element_rect(fill = "#EFEFEF"),
            plot.title = element_blank(),
            panel.grid = element_line(color = "grey85")
        )
        
}
    
        
}