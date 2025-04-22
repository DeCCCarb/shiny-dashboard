server <- function(input, output, session) {
    # Create reactive port
    port_input <- reactive({
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
    
    # output$osw_county_map_output <- renderLeaflet({
    #     icons <- awesomeIcons(
    #         icon = 'helmet-safety',
    #         iconColor = 'black',
    #         library = 'fa',
    #         markerColor = "orange"
    #     )
    #
    #     leaflet() |>
    #         addProviderTiles(providers$Stadia.StamenTerrain) |>
    #         setView(lng = -119.698189, lat = 34.420830, zoom = 7) |>
    #         addPolygons(data = ca_counties) |>
    #         addAwesomeMarkers(data = port_input(),
    #                           lng = port_input()$long,
    #                           lat = port_input()$lat,
    #                           icon = icons,
    #                           popup = paste('Port', port_input()$port_name))
    # })
    # #
    output$osw_map_output <- renderLeaflet({
        icons <- awesomeIcons(
            icon = 'helmet-safety',
            iconColor = 'black',
            library = 'fa',
            markerColor = "orange"
        )
        
        # Base map
        leaflet_map <- leaflet() |>
            addProviderTiles(providers$Stadia.StamenTerrain) |>
            setView(lng = -119.698189,
                    lat = 34.420830,
                    zoom = 7) |>
            addPolygons(data = ca_counties)
        
        # Only add markers if ports are selected
        if (!is.null(input$osw_port_input) &&
            length(input$osw_port_input) > 0) {
            ports_df <- data.frame(
                port_name = c("Hueneme", "Morro Bay"),
                address = c(
                    "Port of Hueneme, Port Hueneme, CA 93041",
                    "699 Embarcadero, Morro Bay, CA 93442"
                )
            ) |>
                filter(port_name %in% input$osw_port_input) |>
                tidygeocoder::geocode(address = address, method = "osm")
            
            leaflet_map <- leaflet_map |>
                addAwesomeMarkers(
                    data = ports_df,
                    lng = ports_df$long,
                    lat = ports_df$lat,
                    icon = icons,
                    popup = paste('Port:', ports_df$port_name)
                )
        }
        
        leaflet_map
    })
    
    # # Generate workforce development map tool ----
    output$utility_county_map_output <- renderLeaflet({
        counties_input <- reactive({
            if (!is.null(input$county_input)) {
                ca_counties |> filter(name %in% input$county_input)
            } else {
                ca_counties
            }
        })
        
        icons <- awesomeIcons(
            icon = 'helmet-safety',
            iconColor = 'black',
            library = 'fa',
            markerColor = "orange"
        )
        
        leaflet_map <- leaflet() |>
            addProviderTiles(providers$Stadia.StamenTerrain) |>
            setView(lng = -119.698189,
                    lat = 34.420830,
                    zoom = 7) |>
            addPolygons(data = counties_input())
        
        # Only add ports if selected
        if (!is.null(input$port_input) &&
            length(input$port_input) > 0) {
            ports <- data.frame(
                port_name = c("Hueneme", "Morro Bay"),
                address = c(
                    "Port of Hueneme, Port Hueneme, CA 93041",
                    "699 Embarcadero, Morro Bay, CA 93442"
                )
            ) |>
                filter(port_name %in% input$port_input) |>
                tidygeocoder::geocode(address = address, method = "osm")
            
            leaflet_map <- leaflet_map |>
                addAwesomeMarkers(
                    data = ports,
                    lng = ports$long,
                    lat = ports$lat,
                    icon = icons,
                    popup = paste('Port', ports$port_name)
                )
        }
        
        leaflet_map
    })
    
    # Make the default values of capacity in the UI react to user input using renderUI------
    observeEvent(input$county_input, {
        # Requires a county input
        req(input$county_input)
        
        # Assign selected county
        selected_county <- as.character(input$county_input)[1]  # make sure it's a string
        
        # Placeholder for default initial capacity that changes based on county selection
        initial_val <- utility_targets %>% # Find targets in global.R
            filter(values == "initial") %>%
            pull(!!sym(selected_county)) # pull the inital value form the selected county dataframe so that its one value
        
        # Placeholder for default final capacity that changes based on county selection
        final_val <- utility_targets |>
            filter(values == 'final') |>
            pull(!!sym(selected_county))
        
        # Update the UI defaults based on county
        updateNumericInput(session, inputId = "initial_mw_utility_input", value = initial_val)
        
        # Update the UI defaults based on county
        updateNumericInput(session, inputId = 'final_mw_utility_input', value = final_val)
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
        
        # Join roof jobs by selected counties and job type
        county_utility <- rbind(county_utility_pv_const, county_utility_pv_om) |>
            filter(type %in% input$utility_job_type_input) |>
            select(-ambition)
        
        return(county_utility)
    })
    
    
    #
    #         counties_input <- reactive({
    #             if (!is.null(input$county_input)) {
    #                 ca_counties |> filter(name %in% input$county_input)
    #             } else {
    #                 ca_counties
    #             }
    #         })
    #
    #
    #         icons <- awesomeIcons(
    #             icon = 'helmet-safety',
    #             iconColor = 'black',
    #             library = 'fa',
    #             markerColor = "orange"
    #         )
    #
    #         # sample California Central Coast map using leaflet ----
    #         leaflet() |>
    #             addProviderTiles(providers$Stadia.StamenTerrain) |>
    #             setView(lng = -119.698189,
    #                     lat = 34.420830,
    #                     zoom = 7) |>
    #             # addMiniMap(toggleDisplay = TRUE,
    #             #             minimized = FALSE) |>
    #             # addMarkers(data = counties_input(),
    #             #            lng = counties_input()$Longitude,
    #             #            lat = counties_input()$Latitude,
    #             #            popup = paste0('County: ', counties_input()$County, '<br>',
    #             #                           '% current fossil fuel workers ____', '<br>',
    #             #                           'Projected Job Loss___', '<br',
    #             #                           'Projected Job Gain ____')) |>
    #             # addTiles() %>%
    #             addPolygons(data=ca_counties) |>
    #             addAwesomeMarkers(data = port_input(),
    #                               lng = port_input()$long,
    #                               lat = port_input()$lat,
    #                               icon = icons,
    #                               popup = paste('Port', port_input()$port_name))
    #
    #     })
    
    # County selection
    counties_input <- reactive({
        counties |>
            filter(County == input$county_input)
    })
    
    
    # Choose your technology
    # Generate the plot of jobs based on user selection ---
    output$model_jobs_output <- renderPlotly({
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
            
            osw_plot <- ggplot(osw_all, aes(x = year, y = n_jobs, group = occupation)) +
                geom_col(aes(fill = occupation)) +
                scale_fill_manual(labels = c("Construction Jobs", "Operations & Maintenance Jobs"),
                                  values = c("#4a4e69", "#9a8c98")) +
                scale_y_continuous(limits = c(0, 2000)) +
                labs(title = "Projected direct jobs in CA \nCentral Coast from \nFloating OSW development",
                     y = "FTE Jobs") +
                theme_minimal()
            
            
        }
        plotly::ggplotly(osw_plot)
    })
    
    
    
    # Make the default values of capacity in the UI react to user input using renderUI------
    observeEvent(input$county_input, {
        # Requires a county input
        req(input$county_input)
        
        # Assign selected county
        selected_county <- as.character(input$county_input)[1]  # make sure it's a string
        
        # Placeholder for default initial capacity that changes based on county selection
        initial_val <- rooftop_targets %>% # Find targets in global.R
            filter(values == "initial") %>%
            pull(!!sym(selected_county)) # pull the inital value form the selected county dataframe so that its one value
        
        # Placeholder for default final capacity that changes based on county selection
        final_val <- rooftop_targets |>
            filter(values == 'final') |>
            pull(!!sym(selected_county))
        
        # Update the UI defaults based on county
        updateNumericInput(session, inputId = "initial_mw_roof_input", value = initial_val)
        
        # Update the UI defaults based on county
        updateNumericInput(session, inputId = 'final_mw_roof_input', value = final_val)
    })
    
    
    #rooftop leaflet map output ----
    output$roof_county_map_output <- renderLeaflet({
        counties_input <- reactive({
            if (!is.null(input$roof_counties_input)) {
                ca_counties |> filter(name %in% input$roof_counties_input)
            } else {
                ca_counties
            }
        })
        
        icons <- awesomeIcons(
            icon = 'helmet-safety',
            iconColor = 'black',
            library = 'fa',
            markerColor = "orange"
        )
        
        leaflet_map <- leaflet() |>
            addProviderTiles(providers$Stadia.StamenTerrain) |>
            setView(lng = -119.698189,
                    lat = 34.420830,
                    zoom = 7) |>
            addPolygons(data = counties_input())
        
        # Only add ports if selected
        if (!is.null(input$port_input) &&
            length(input$port_input) > 0) {
            ports <- data.frame(
                port_name = c("Hueneme", "Morro Bay"),
                address = c(
                    "Port of Hueneme, Port Hueneme, CA 93041",
                    "699 Embarcadero, Morro Bay, CA 93442"
                )
            ) |>
                filter(port_name %in% input$port_input) |>
                tidygeocoder::geocode(address = address, method = "osm")
            
            leaflet_map <- leaflet_map |>
                addAwesomeMarkers(
                    data = ports,
                    lng = ports$long,
                    lat = ports$lat,
                    icon = icons,
                    popup = paste('Port', ports$port_name)
                )
        }
        
        leaflet_map
    })
    # Make table with rooftop solar values ----
    output$roof_jobs_output <- renderTable({
        county_roof_pv_om <- calculate_pv_om_jobs(
            county = input$roof_counties_input,
            technology = "Rooftop PV",
            ambition = "High",
            start_year = input$start_yr_roof_input,
            end_year = input$end_yr_roof_input,
            initial_capacity = input$initial_mw_roof_input,
            final_capacity = input$final_mw_roof_input,
            direct_jobs = 0.2,
            indirect_jobs = 0,
            induced_jobs = 0
        )
        
        # Construction Utility PV
        county_roof_pv_const <- calculate_pv_construction_jobs(
            county = input$roof_counties_input,
            start_year = input$start_yr_roof_input,
            end_year = input$end_yr_roof_input,
            technology = "Rooftop PV",
            ambition = "High",
            initial_capacity = input$initial_mw_roof_input,
            final_capacity = input$final_mw_roof_input,
            direct_jobs = 1.6,
            indirect_jobs = 0.6,
            induced_jobs = 0.4
        )
        
        # Join roof jobs by selected counties and job type
        county_roof <- rbind(county_roof_pv_const, county_roof_pv_om) |>
            filter(type %in% input$roof_job_type_input) |>
            select(-ambition)
        
        return(county_roof)
    })
    
    # Change UI Rooftop ambition targets --
    observeEvent(input$roof_counties_input, {
        # Requires a county input
        req(input$roof_counties_input)
        
        # Assign selected county
        selected_county <- as.character(input$roof_counties_input)[1]  # make sure it's a string
        
        # Placeholder for default initial capacity that changes based on county selection
        initial_val <- rooftop_targets %>%
            filter(values == "initial") %>%
            pull(!!sym(selected_county)) # pull the inital value form the selected county dataframe so that its one value
        
        # Placeholder for default final capacity that changes based on county selection
        final_val <- rooftop_targets |>
            filter(values == 'final') |>
            pull(!!sym(selected_county))
        
        # Update the UI defaults based on county
        updateNumericInput(session, inputId = "initial_mw_roof_input", value = initial_val)
        
        # Update the UI defaults based on county
        updateNumericInput(session, inputId = 'final_mw_roof_input', value = final_val)
    })
    ########### Slider Input Range of Years for Land Based WIND ########
    
    output$value <- renderPrint({
        input$input_lw_years
    })
    
    ####### Land Based Wind Output Render Jobs ################
    output$lw_jobs_output <- renderTable({
        land_wind_construction_test <- calculate_land_wind_construction_jobs(
            county = input$lw_counties_input,
            start_year = input$input_lw_years[1],
            end_year = input$input_lw_years[2],
            initial_capacity = 0.98,
            final_capacity = 5,
            direct_jobs = 1,
            indirect_jobs = 1,
            induced_jobs = 1
        )
        
        land_wind_om_test <- calculate_land_wind_om_jobs(
            county = input$lw_counties_input,
            start_year = input$input_lw_years[1],
            end_year = input$input_lw_years[2],
            initial_capacity = 0.98,
            final_capacity = 5,
            direct_jobs = 1,
            indirect_jobs = 1,
            induced_jobs = 1
        )
        
        # Join roof jobs by selected counties and job type
        county_lw <- rbind(land_wind_construction_test, land_wind_om_test) |>
            filter(type %in% input$lw_job_type_input) |>
            select(-ambition)
        
        return(county_lw)
    })
}