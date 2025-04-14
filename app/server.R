server <- function(input, output, session){
    
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
            # addMarkers(data = counties_input(),
            #            lng = counties_input()$Longitude,
            #            lat = counties_input()$Latitude,
            #            popup = paste0('County: ', counties_input()$County, '<br>',
            #                           '% current fossil fuel workers ____', '<br>',
            #                           'Projected Job Loss___', '<br',
            #                           'Projected Job Gain ____')) |> 
            # addTiles() %>% 
            addPolygons(data=ca_counties) |> 
            addAwesomeMarkers(data = port_input(),
                              lng = port_input()$long,
                              lat = port_input()$lat,
                              icon = icons,
                              popup = paste('Port', port_input()$port_name))
        
    })
    
    # County selection
    counties_input <- reactive({
        counties |>
            filter(County == input$county_input) 
    }) 
    
    
    # Choose your technology
    # Generate the plot of jobs based on user selection ---
    output$model_jobs_output <- renderTable({
        # Define inputs
        tech <- input$technology_input
        
        
        if (tech == 'Floating Offshore Wind') {
            # Floating Offshore Wind ------
            # O&M OSW --
            osw_om <- calculate_osw_om_jobs(
                county = "Tri-county",
                start_year = input$start_yr_input,
                end_year = input$end_yr_input,
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
                start_year = input$start_yr_input,
                end_year = input$end_yr_input,
                ambition = "High", 
                initial_capacity = input$initial_capacity_input,
                target_capacity = input$final_capacity_input,
                direct_jobs = 82, 
                indirect_jobs = 2571, 
                induced_jobs = 781
            )
            
            osw_all <- rbind(osw_construction, osw_om) |> 
                filter(type %in% input$job_type_input)
            
            return(osw_all)
            
        }else if (tech == 'Rooftop PV' && counties_input()$County == 'Santa Barbara') { 
            # O&M Rooftop PV
            sb_roof_pv_om <- calculate_pv_om_jobs(
                county = "SB", 
                start_year = input$start_yr_input,
                end_year = input$end_yr_input,
                technology = "Rooftop PV", 
                ambition = "High",
                initial_capacity = 242.0159119, 
                final_capacity = 1293.941196, 
                direct_jobs = ((0.3 * 0.4) + (0.2 * 0.6)), 
                indirect_jobs = 0, 
                induced_jobs = 0
            )
            
            # Construction Rooftop PV
            sb_roof_pv_const <- calculate_pv_construction_jobs(
                county = "SB",
                start_year = input$start_yr_input,
                end_year = input$end_yr_input,
                technology = "Rooftop PV",
                ambition = "High",
                initial_capacity = 242.0159119,
                final_capacity = 1293.941196,
                direct_jobs = ((5.9 * 0.4) + (3.1 * 0.6)),
                indirect_jobs = ((4.7 * 0.4) + (2.9 * 0.6)),
                induced_jobs = ((2.5 * 0.4) + (1.5 * 0.6))
            )
            
            roof_sb <- rbind(sb_roof_pv_const, sb_roof_pv_om) |> 
                filter(type %in% input$job_type_input) |> 
                select(-ambition)
            
            return(roof_sb)
            
        }else if (tech == 'Rooftop PV' && counties_input()$County == 'San Luis Obispo') { 
            # O&M Rooftop PV
            slo_roof_pv_om <- calculate_pv_om_jobs(
                county = "SLO", 
                start_year = input$start_yr_input,
                end_year = input$end_yr_input,
                technology = "Rooftop PV", 
                ambition = "High",
                initial_capacity = 344.8405982, 
                final_capacity = 1843.694708, 
                direct_jobs = ((0.3 * 0.4) + (0.2 * 0.6)), 
                indirect_jobs = 0, 
                induced_jobs = 0
            )
            
            # Construction Rooftop PV
            slo_roof_pv_const <- calculate_pv_construction_jobs(
                county = "SLO",
                start_year = input$start_yr_input,
                end_year = input$end_yr_input,
                technology = "Rooftop PV",
                ambition = "High",
                initial_capacity = 344.8405982,
                final_capacity = 1843.694708,
                direct_jobs = ((6.2 * 0.4) + (3.3 * 0.6)),
                indirect_jobs = ((5.4 * 0.4) + (3.3 * 0.6)),
                induced_jobs = ((2.3 * 0.4) + (1.3 * 0.6))
            )
            roof_slo <- rbind(slo_roof_pv_const, slo_roof_pv_om) |> 
                select(-ambition) |> 
                filter(type %in% input$job_type_input)
            
            return(roof_slo)
            
        } else if (tech == 'Rooftop PV' && counties_input()$County == 'Ventura') { 
            # O&M Rooftop PV
            ventura_roof_pv_om <- calculate_pv_om_jobs(
                county = "V", 
                start_year = input$start_yr_input,
                end_year = input$end_yr_input,
                technology = "Rooftop PV", 
                ambition = "High",
                initial_capacity = 424.1984954, 
                final_capacity = 3026.377541, 
                direct_jobs = ((0.3 * 0.4) + (0.2 * 0.6)), 
                indirect_jobs = 0, 
                induced_jobs = 0
            )
            
            # Construction Rooftop PV
            ventura_roof_pv_const <- calculate_pv_construction_jobs(
                county = "V",
                start_year = input$start_yr_input,
                end_year = input$end_yr_input,
                technology = "Rooftop PV",
                ambition = "High",
                initial_capacity = 424.1984954,
                final_capacity = 3026.377541,
                direct_jobs = ((6.2 * 0.4) + (3.3 * 0.6)),
                indirect_jobs = ((4.7 * 0.4) + (2.9 * 0.6)),
                induced_jobs = ((2.5 * 0.4) + (1.4 * 0.6))
            )
            
            roof_ventura <- rbind(ventura_roof_pv_const, ventura_roof_pv_om) |> 
                select(-ambition) |> 
                filter(type %in% input$job_type_input)
            
            return(roof_ventura)
        }else {
            return(data.frame(Message = "No matching county or technology"))
        }
        
    })
    
    
    # Make the default values of capacity in the UI react to user input using renderUI------
    
    observeEvent(input$county_input, {
        # Requires a county input
        req(input$county_input)
        
        # Assign selected county
        selected_county <- as.character(input$county_input)[1]  # make sure it's a string
        
        # Placeholder for default initial capacity that changes based on county selection
        initial_val <- utility_targets %>%
            filter(values == "initial") %>%
            pull(!!sym(selected_county)) # pull the inital value form the selected county dataframe so that its one value
        
        # Placeholder for default final capacity that changes based on county selection
        final_val <- utility_targets |> 
            filter(values == 'final') |> 
            pull(!!sym(selected_county))
        
        # Update the UI defaults based on county
        updateNumericInput(
            session,
            inputId = "initial_mw_utility_input",
            value = initial_val
        )
        
        # Update the UI defaults based on county
        updateNumericInput(
            session,
            inputId = 'final_mw_utility_input',
            value = final_val
        )
    })
    
    output$utility_jobs_output <- renderTable({
        county_utility_pv_om <- calculate_pv_om_jobs(
            county = input$county_input,
            technology = "Utility PV",
            ambition = "High",
            start_year = input$start_yr_utility_input,
            end_year = input$end_yr_utility_input,
            initial_capacity = input$initial_mw_utility_input,
            final_capacity = input$final_mw_utility_input,
            direct_jobs = 0.2,
            indirect_jobs = 0,
            induced_jobs = 0
        )

        # Construction Utility PV
        county_utility_pv_const <- calculate_pv_construction_jobs(
            county = input$county_input,
            start_year = input$start_yr_utility_input,
            end_year = input$end_yr_utility_input,
            technology = "Utility PV",
            ambition = "High",
            initial_capacity = input$initial_mw_utility_input,
            final_capacity = input$final_mw_utility_input,
            direct_jobs = 1.6,
            indirect_jobs = 0.6,
            induced_jobs = 0.4
        )

        # Join utility jobs by selected counties and job type
        county_utility <- rbind(county_utility_pv_const, county_utility_pv_om) |>
            filter(type %in% input$utility_job_type_input) |>
            select(-ambition)

        return(county_utility)
    })
}