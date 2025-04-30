
server <- function(input, output, session) {
    # Create reactive port for OSW map
    
    port_input <- reactive({
        data.frame(
            port_name = c("Hueneme", "San Luis Obispo"),
            address = c(
                "Port of Hueneme, Port Hueneme, CA 93041",
                "699 Embarcadero, Morro Bay, CA 93442"
            )
        ) %>%
            tidygeocoder::geocode(address = address, method = "osm") |>
            filter(port_name == input$osw_port_input)
        
        
        
    })
    
    # Interactive OSW Map ----
    observeEvent(
        c(
            input$year_range_input,
            input$job_type_input,
            input$initial_capacity_input,
            input$final_capacity_input,
            input$osw_port_input
        ),
        {
            # OSW total jobs map label ----
            # Calculate annual jobs when port is in CC
            if (!("No Central Coast Port" %in% input$osw_port_input)) {
                # OSW O&M jobs
                osw_om <- calculate_osw_om_jobs(
                    county = "Tri-county",
                    start_year = input$year_range_input[1],
                    end_year = input$year_range_input[2],
                    ambition = "High",
                    initial_capacity = input$initial_capacity_input,
                    target_capacity = input$final_capacity_input,
                    direct_jobs = 127,
                    indirect_jobs = 126,
                    induced_jobs = 131
                )
                
                # OSW Construction
                osw_construction <- calculate_osw_construction_jobs(
                    county = "Tri-County",
                    start_year = input$year_range_input[1],
                    end_year = input$year_range_input[2],
                    ambition = "High",
                    initial_capacity = input$initial_capacity_input,
                    target_capacity = input$final_capacity_input,
                    direct_jobs = 82,
                    indirect_jobs = 2571,
                    induced_jobs = 781
                )
                
                # Bind together
                osw_all <- rbind(osw_om, osw_construction) |>
                    filter(type == input$job_type_input)
                
                # Calculate annual jobs when port is NOT in CC
                
            } else {
                # Return 0 jobs
                osw_all <- data.frame(
                    year = integer(),
                    n_jobs = numeric(),
                    occupation = character(),
                    type = character(),
                    stringsAsFactors = FALSE
                )
            }
            
            # Calculate total construction jobs
            const_njobs_label <- osw_all |>
                filter(occupation == "Construction")
            
            const_njobs_label <- round(sum(const_njobs_label$n_jobs, na.rm = TRUE), 0)
            
            # Calculate total O&M jobs
            om_njobs_label <- osw_all |>
                filter(occupation == "O&M")
            
            om_njobs_label <- round(sum(om_njobs_label$n_jobs, na.rm = TRUE), 0)
            
            # Generate and format label
            osw_map_label <- HTML(
                paste(
                    "<b>Total Jobs in Central Coast</b>",
                    "<br>",
                    "- Construction:",
                    scales::comma(const_njobs_label),
                    "<br>",
                    "- O&M:",
                    scales::comma(om_njobs_label)
                )
            )
            
            
            # OSW map ----
            output$osw_map_output <- renderLeaflet({
                port_icon <- awesomeIcons(
                    icon = 'helmet-safety',
                    iconColor = 'black',
                    library = 'fa',
                    markerColor = "orange"
                )
                
                # Total jobs label location
                label_coords <- sf::st_coordinates(st_centroid(osw_all_counties)) + c(-0.75, -0.2)
                
                label_points <- st_as_sf(
                    data.frame(lng = label_coords[, 1], lat = label_coords[, 2]),
                    coords = c("lng", "lat"),
                    crs = st_crs(osw_all_counties)
                )
                
                # Base map
                leaflet_map <- leaflet() |>
                    addProviderTiles(providers$Stadia.StamenTerrain) |>
                    setView(lng = -120.698189,
                            lat = 34.420830,
                            zoom = 7) |>
                    addPolygons(
                        data = osw_all_counties,
                        color = 'forestgreen',
                        opacity = 0.7,
                    ) |>
                    # Label each county with total jobs
                    addLabelOnlyMarkers(
                        data = label_points,
                        label = osw_map_label,
                        labelOptions = labelOptions(
                            noHide = TRUE,
                            direction = 'left',
                            textsize = "12px",
                            opacity = 1
                        )
                    )
                
                
                # Only add markers if ports are selected
                if (!("No Central Coast Port" %in% input$osw_port_input)) {
                    ports_df <- data.frame(
                        port_name = c("Hueneme", "San Luis Obispo"),
                        address = c(
                            "Port of Hueneme, Port Hueneme, CA 93041",
                            "699 Embarcadero, Morro Bay, CA 93442"
                        )
                    ) |>
                        filter(port_name %in% input$osw_port_input) |>
                        tidygeocoder::geocode(address = 'address', method = "osm")
                    
                    leaflet_map <- leaflet_map |>
                        addAwesomeMarkers(
                            data = ports_df,
                            lng = ports_df$long,
                            lat = ports_df$lat,
                            icon = port_icon,
                            popup = paste('Port:', ports_df$port_name)
                        )
                }
                
                leaflet_map
            })
        }
    )
    
    
    # # Generate workforce development map tool ----
    # output$utility_county_map_output <- renderLeaflet({
    #
    #         counties_input <- reactive({
    #             if (!is.null(input$county_input)) {
    #                 ca_counties |> filter(name %in% input$county_input)
    #             } else {
    #                 ca_counties
    #             }
    #         })
    #
    #         icons <- awesomeIcons(
    #             icon = 'helmet-safety',
    #             iconColor = 'black',
    #             library = 'fa',
    #             markerColor = "orange"
    #         )
    #
    #         leaflet_map <- leaflet() |>
    #             addProviderTiles(providers$Stadia.StamenTerrain) |>
    #             setView(lng = -119.698189, lat = 34.420830, zoom = 7) |>
    #             addPolygons(data = counties_input())
    
    # Utility PV map ----
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
                port_name = c("Hueneme", "San Luis Obispo"),
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
    
    # Make the default values of UTILITY capacity in the UI react to user input using renderUI------
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
    ##### Utility Jobs Output #######
    output$utility_jobs_output <- renderTable({
        county_utility_pv_om <- calculate_pv_om_jobs(
            county = input$county_input,
            technology = "Utility PV",
            ambition = "High",
            start_year = input$year_range_input_utility[1],
            end_year = input$year_range_input_utility[2],
            initial_capacity = input$initial_mw_utility_input,
            final_capacity = input$final_mw_utility_input,
            direct_jobs = 0.2,
            indirect_jobs = 0,
            induced_jobs = 0
        )
        
        # Construction Utility PV
        county_utility_pv_const <- calculate_pv_construction_jobs(
            county = input$county_input,
            start_year = input$year_range_input_utility[1],
            end_year = input$year_range_input_utility[2],
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
    
    
    # County selection
    counties_input <- reactive({
        counties |>
            filter(County == input$county_input)
    })
    
    # Render Plotly graph based on user input
    # output$model_jobs_output <- renderPlotly({
    #     # Simulate some data based on user input
    #     n_jobs <- sample(50:1000, 5)
    #     year <- seq(input$year_range_input[1], input$year_range_input[2], length.out = 5)
    #
    #     df <- data.frame(year, n_jobs)
    #
    #     # Basic plot
    #     p <- ggplot(df, aes(x = year, y = n_jobs)) +
    #         geom_bar(stat = 'identity', fill = 'blue') +
    #         labs(title = paste('Projected Jobs in Offshore Wind (', input$year_range_input[1], ' to ', input$year_range_input[2], ')', sep = ''),
    #              x = 'Year', y = 'Number of Jobs')
    #
    #     # Convert ggplot to Plotly
    #     plotly::ggplotly(p)
    # })
    
    
    
    # Generate the plot of jobs based on user selection ---
    # output$model_jobs_output <- renderPlotly({
    #     # Define inputs
    #     # Floating Offshore Wind ------
    #     if ("No Central Coast Port" %in% input$osw_port_input){
    #         # Generate a dummy df to preserve x and y axis
    #         years <- input$year_range_input[1]:input$year_range_input[2]
    #         dummy_df <- data.frame(
    #             year = years,
    #             n_jobs = rep(0, length(years)),
    #             occupation = factor(rep(NA, length(years))),
    #             type = rep(NA, length(years))
    #         )
    #         # #         # Plot showing no jobs
    #         empty_plot <- ggplot(dummy_df, aes(x = as.factor(year), y = n_jobs)) +
    #             geom_col(fill = "#cccccc") +
    #             scale_y_continuous(limits = c(0, 2000), labels = scales::comma) +
    #             scale_x_discrete(breaks = scales::breaks_pretty(n = 5)) +
    #             labs(title = "Projected jobs in CA Central Coast from Floating OSW development",
    #                  y = "FTE Jobs") +
    #             annotate("text",
    #                      x = as.factor(median(years)),
    #                      y = 1000,
    #                      label = "No Port in Central Coast — job projections are 0",
    #                      size = 5,
    #                      color = "gray30") +
    #             theme_minimal() +
    #             theme(
    #                 axis.title.x = element_blank(),
    #                 axis.title.y = element_text(margin = margin(10, 10, 10, 10)),
    #                 legend.position = "none"
    #             )
    # 
    #         plotly::ggplotly(empty_plot) }
    # 
    #             osw_om <- calculate_osw_om_jobs(
    #                 county = "Tri-county",
    #                 start_year = input$year_range_input[1],
    #                 end_year = input$year_range_input[2],
    #                 ambition = "High",
    #                 initial_capacity = input$initial_capacity_input,
    #                 target_capacity = input$final_capacity_input,
    #                 direct_jobs = 127,
    #                 indirect_jobs = 126,
    #                 induced_jobs = 131
    #             )
    # 
    # 
    #         # Construction OSW --
    #         osw_construction <- calculate_osw_construction_jobs(
    #             county = "Tri-County",
    # 
    #             start_year = input$year_range_input[1],
    #             end_year = input$year_range_input[2],
    #             ambition = "High",
    #             initial_capacity = input$initial_capacity_input,
    #             target_capacity = input$final_capacity_input,
    #             direct_jobs = 82,
    #             indirect_jobs = 2571,
    #             induced_jobs = 781
    #         )
    # 
    #         osw_all <- rbind(osw_construction, osw_om) |>
    #             filter(type %in% input$job_type_input)
    # 
    #         ######## Generate Plot for OSW ##############
    #         osw_plot <- ggplot(osw_all, aes(x = year, y = n_jobs, group = occupation)) +
    #             geom_col(aes(fill = occupation)) +
    #             scale_fill_manual(labels = c("Construction Jobs", "Operations & Maintenance Jobs"),
    #                               values = c("#4a4e69", "#9a8c98")) +
    #             scale_y_continuous(limits = c(0, 2000)) +
    #             labs(title = glue::glue("Projected {input$job_type_input} jobs in CA Central Coast from Floating OSW development"),
    #                  y = "FTE Jobs") +
    #             theme_minimal()
    # 
    # 
    #         plotly::ggplotly(osw_plot)
    # 
    #  })
    
    # Generate capacity plot based on user selection ---
    # output$osw_cap_projections_output <- renderPlotly({
    #
    #
    
    #
    #     # O&M OSW --
    
    #
    #
    #     ######## Generate Plot for OSW ##############
    #     # total_cap_line <- osw |>
    #     #     filter(year %in% c(2030:2045))
    #     # annual_cap_line <- osw |>
    #     #     filter(year %in% c(2026:2041))
    #
    #     osw_cap_plot <- ggplot() +
    #         geom_point(data = osw,
    #                    aes(x = as.factor(year), y = total_capacity_gw),
    #                    color = "#A3BDBE") +
    #         geom_point(data = osw,
    #                    aes(x = as.factor(year), y = new_capacity_gw),
    #                    color = "#3A8398") +
    #         scale_x_discrete(breaks = scales::breaks_pretty(n=4)) +
    #         labs(y = "Capacity (GW)",
    #              title = "Capacity Growth Rate to Meet Target ") +
    #         theme_minimal() +
    #         theme(
    #             axis.title.x = element_blank(),
    #         )
    #
    #
    #     plotly::ggplotly(osw_cap_plot)
    #
    #
    #
    # })
    
    
    ####### EXPORT OSW AS PDF #############
    output$export_osw <- downloadHandler(
        filename = "osw-jobs.pdf",
        
        content = function(file) {
            src <- normalizePath(here::here('app', 'files', 'osw-jobs.Rmd'))
            
            # Switch to a temp directory
            owd <- setwd(tempdir())
            on.exit(setwd(owd), add = TRUE)
            
            file.copy(src, 'osw-jobs.Rmd', overwrite = TRUE)
            
            # Render the Rmd to PDF, output file will be named 'rooftop-jobs.pdf'
            output_file <- rmarkdown::render(
                input = 'osw-jobs.Rmd',
                output_format = "pdf_document",
                output_file = "osw-jobs.pdf"
            )
            
            # Copy the rendered PDF to the target location
            file.copy(output_file, file, overwrite = TRUE)
        }
        
    )
    
    output$model_jobs_output <- renderPlotly({
        # Define inputs
        # Floating Offshore Wind ------
        if ("No Central Coast Port" %in% input$osw_port_input) {
            # Generate a dummy df to preserve x and y axis
            years <- input$year_range_input[1]:input$year_range_input[2]
            dummy_df <- data.frame(
                year = years,
                n_jobs = rep(0, length(years)),
                occupation = factor(rep(NA, length(years))),
                type = rep(NA, length(years))
            )
            # Plot showing no jobs
            empty_plot <- ggplot(dummy_df, aes(x = as.factor(year), y = n_jobs)) +
                geom_col(fill = "#cccccc") +
                scale_y_continuous(limits = c(0, 2000),
                                   labels = scales::comma) +
                scale_x_discrete(breaks = scales::breaks_pretty(n = 5)) +
                labs(title = "Projected jobs in CA Central Coast from Floating OSW development", y = "FTE Jobs") +
                annotate(
                    "text",
                    x = as.factor(median(years)),
                    y = 1000,
                    label = "No Port in Central Coast — job projections are 0",
                    size = 5,
                    color = "gray30"
                ) +
                theme_minimal() +
                theme(
                    axis.title.x = element_blank(),
                    axis.title.y = element_text(margin = margin(10, 10, 10, 10)),
                    legend.position = "none"
                )
            
            plotly::ggplotly(empty_plot)
            
        } else {
        osw_om <- calculate_osw_om_jobs(
            county = "Tri-county",
            start_year = input$year_range_input[1],
            end_year = input$year_range_input[2],
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
            start_year = input$year_range_input[1],
            end_year = input$year_range_input[2],
            ambition = "High",
            initial_capacity = input$initial_capacity_input,
            target_capacity = input$final_capacity_input,
            direct_jobs = 82,
            indirect_jobs = 2571,
            induced_jobs = 781
        )
        
        
        # Create joined dataframe
        osw_all <- rbind(osw_construction, osw_om) |>
            filter(type %in% input$job_type_input) # Filter to inputted job type
        
        ######## Generate Plot for OSW ##############
        osw_plot <- ggplot(osw_all,
                           aes(
                               x = as.factor(year),
                               y = round(n_jobs, 0),
                               group = occupation
                           )) +
            geom_col(aes(fill = occupation, text = purrr::map(
                paste0(occupation, " jobs: ", scales::comma(round(n_jobs, 0))), HTML
            ))) +
            scale_fill_manual(
                labels = c("Construction Jobs", "Operations & Maintenance Jobs"),
                values = c("#3A8398", "#A3BDBE")
            ) +
            scale_y_continuous(labels = scales::comma) +
            scale_x_discrete(breaks = scales::breaks_pretty(n = 5)) +
            labs(
                title = glue::glue(
                    "Projected {input$job_type_input} jobs in CA Central Coast from Floating OSW development"
                ),
                y = "FTE Jobs"
            ) +
            theme_minimal() +
            theme(
                # Axes
                axis.title.x = element_blank(),
                axis.title.y = element_text(margin = margin(10, 10, 10, 10)),
                
                # Legend
                legend.title = element_blank(),
                legend.position = "bottom"
                
            )
        
        plotly::ggplotly(osw_plot, tooltip = c("text"))  |>
            layout(hovermode = "x unified",
                   legend = list(x = 0.7, 
                               xanchor = 'left',
                               yanchor = 'top',
                               orientation = 'h',
                               title = "Occupation"))
    }
        
    })
    
    
    # Generate capacity plot based on user selection ---
    output$osw_cap_projections_output <- renderPlotly({
        # O&M OSW ---
        osw <- calculate_osw_om_jobs(
            county = "Tri-county",
            start_year = input$year_range_input[1],
            end_year = input$year_range_input[2],
            ambition = "High",
            initial_capacity = input$initial_capacity_input,
            target_capacity = input$final_capacity_input,
            direct_jobs = 127,
            indirect_jobs = 126,
            induced_jobs = 131
        )
        
        ######## Generate Plot for OSW ##############
        # total_cap_line <- osw |>
        #     filter(year %in% c(2030:2045))
        # annual_cap_line <- osw |>
        #     filter(year %in% c(2026:2041))
        
        osw_cap_plot <- ggplot() +
            geom_point(
                data = osw,
                aes(x = as.factor(year), 
                    y = total_capacity_gw,
                    text = purrr::map(
                        paste0("Capacity: ", round(total_capacity_gw, 2), " GW"), HTML
                    )),
                color = "#3A8398"
            ) +
            # geom_point(
            #     data = osw,
            #     aes(x = as.factor(year), y = new_capacity_gw),
            #     color = "#3A8398"
            # ) +
            scale_x_discrete(breaks = scales::breaks_pretty(n = 4)) +
            labs(y = "Capacity (GW)", title = "Annual Online Capacity (GW)") +
            theme_minimal() +
            theme(axis.title.x = element_blank())
                  #     axis.title.y = element_text(size = 24, margin = margin(5,20,0,10)),
                  #     axis.text = element_text(size = 20),
                  #     legend.title = element_blank(),
                  #     legend.text = element_text(size = 20),
                  #     legend.position = "bottom",
                  #     plot.background = element_rect(fill = "#EFEFEF"),
                  #     plot.title = element_blank(),
                  #     panel.grid = element_line(color = "grey85"))
                  
                  
        
        plotly::ggplotly(osw_cap_plot, tooltip = "text") |>
            layout(hovermode = "x unified")
                  
                  
                  
        
    })
        
        
        # Make the default values of capacity in the UI react to user input using renderUI------
        observeEvent(input$roof_counties_input, {
            # Requires a county input
            req(input$roof_counties_input)
            
            # Assign selected county
            selected_county <- as.character(input$roof_counties_input)[1]  # make sure it's a string
            
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


        # Rooftop leaflet map output ----
        # output$roof_county_map_output <- renderLeaflet({
        #     
        #     # Filter counties based on input
        #     counties_input <- if (!is.null(input$roof_counties_input)) {
        #         ca_counties |> filter(name %in% input$roof_counties_input)
        #     } else {
        #         ca_counties
        #     }
        #     
        #     # Create leaflet icons ----
        #     icons <- awesomeIcons(
        #         icon = 'helmet-safety',
        #         iconColor = 'black',
        #         library = 'fa',
        #         markerColor = "orange"
        #     )
        #     
        #     # Base map
        #     leaflet_map <- leaflet() |>
        #         addProviderTiles(providers$Stadia.StamenTerrain) |>
        #         setView(lng = -119.698189, lat = 34.420830, zoom = 7) |>
        #         addPolygons(data = counties_input)
        #     
        #     # Add port markers if selected
        #     if (!is.null(input$port_input) && length(input$port_input) > 0) {
        #         ports <- data.frame(
        #             port_name = c("Hueneme", "San Luis Obispo"),
        #             address = c(
        #                 "Port of Hueneme, Port Hueneme, CA 93041",
        #                 "699 Embarcadero, Morro Bay, CA 93442"
        #             )
        #         ) |>
        #             filter(port_name %in% input$port_input) |>
        #             tidygeocoder::geocode(address = address, method = "osm")
        #         
        #         leaflet_map <- leaflet_map |>
        #             addAwesomeMarkers(
        #                 data = ports,
        #                 lng = ports$long,
        #                 lat = ports$lat,
        #                 icon = icons,
        #                 popup = paste('Port', ports$port_name)
        #             )
        #     }
        #     
        #     leaflet_map
        # })
        
     
        
        
        # leaflet_map <- leaflet() |>
        #     addProviderTiles(providers$Stadia.StamenTerrain) |>
        #     setView(lng = -119.698189, lat = 34.420830, zoom = 7) |>
        #     addPolygons(data = counties_input())
        
        # # Add port markers if selected
        # if (!is.null(input$port_input) && length(input$port_input) > 0) {
        #     ports <- data.frame(
        #         port_name = c("Hueneme", "San Luis Obispo"),
        #         address = c(
        #             "Port of Hueneme, Port Hueneme, CA 93041",
        #             "699 Embarcadero, Morro Bay, CA 93442"
        #         )
        #     ) |>
        #         filter(port_name %in% input$port_input) |>
        #         tidygeocoder::geocode(address = address, method = "osm")
        
        # leaflet_map <- leaflet_map |>
        #     addAwesomeMarkers(
        #         data = ports,
        #         lng = ports$long,
        #         lat = ports$lat,
        #         icon = icons,
        #         popup = paste('Port', ports$port_name)
        #     )
        

        
        
        # Render the table with rooftop solar values
        output$roof_jobs_output <- renderPlotly({
            # Calculation of rooftop solar jobs (construction and operations)
            county_roof_pv_om <- calculate_pv_om_jobs(
                county = input$roof_counties_input,
                technology = "Rooftop PV",
                ambition = "High",
                start_year = input$year_range_input_roof[1],
                end_year = input$year_range_input_roof[2],
                initial_capacity = input$initial_mw_roof_input,
                final_capacity = input$final_mw_roof_input,
                direct_jobs = 0.2,
                indirect_jobs = 0,
                induced_jobs = 0
            )
            
            county_roof_pv_const <- calculate_pv_construction_jobs(
                county = input$roof_counties_input,
                start_year = input$year_range_input_roof[1],
                end_year = input$year_range_input_roof[2],
                technology = "Rooftop PV",
                ambition = "High",
                initial_capacity = input$initial_mw_roof_input,
                final_capacity = input$final_mw_roof_input,
                direct_jobs = 1.6,
                indirect_jobs = 0.6,
                induced_jobs = 0.4
            )
            
            county_roof <- rbind(county_roof_pv_const, county_roof_pv_om) |>
                filter(type %in% input$roof_job_type_input) |>
                select(-ambition)
            
            roof_plot <- ggplot(county_roof, aes(
                x = year,
                y = n_jobs,
                group = occupation
            )) +
                geom_col(aes(fill = occupation)) +
                scale_fill_manual(
                    labels = c("Construction Jobs", "Operations & Maintenance Jobs"),
                    values = c("#4a4e69", "#9a8c98")
                ) +
                scale_y_continuous(limits = c(0, 2000)) +
                labs(
                    title = glue::glue(
                        "Projected {input$job_type_input} jobs in CA Central Coast from Rooftop Solar development"
                    ),
                    y = "FTE Jobs"
                ) +
                theme_minimal()
            
            
            # Store the table into vals_roof for export later
            #vals_roof$roof_jobs_output <- county_roof
            
            return(ggplotly(roof_plot))
        })
        
        
        # EXPORT ROOFTOP JOBS AS PDF #############
        
        output$export_roof <- downloadHandler(
            filename = "rooftop-jobs.pdf",
            
            content = function(file) {
                src <- normalizePath(here::here('app', 'files', 'rooftop-jobs.Rmd'))
                
                # Switch to a temp directory
                owd <- setwd(tempdir())
                on.exit(setwd(owd), add = TRUE)
                
                file.copy(src, 'rooftop-jobs.Rmd', overwrite = TRUE)
                
                # Render the Rmd to PDF, output file will be named 'rooftop-jobs.pdf'
                output_file <- rmarkdown::render(
                    input = 'rooftop-jobs.Rmd',
                    output_format = "pdf_document",
                    output_file = "rooftop-jobs.pdf"
                )
                
                # Copy the rendered PDF to the target location
                file.copy(output_file, file, overwrite = TRUE)
            }
            
        )
        
        
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
                    port_name = c("Hueneme", "San Luis Obispo"),
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
     
        #
        # ## Export as PDF
        #
        # output$export = downloadHandler(
        #     filename = function() {"plots.pdf"},
        #     content = function(file) {
        #       #  pdf(file, onefile = TRUE)
        #
        #         tmpfile <- tempfile(fileext = ".png")
        #         mapshot(leafletProxy("roof_county_map_output"), file = tmpfile, selfcontained = FALSE)
        #
        #         # 2. Read snapshot
        #         map_image <- magick::image_read(tmpfile)
        #
        #         # 3. Convert map image and table to grobs
        #         map_grob <- grid::rasterGrob(map_image, interpolate = TRUE)
        #
        #         # Convert the table to a grob
        #         table_grob <- gridExtra::tableGrob(vals_roof$roof_jobs_output)
        #
        #         # Create the PDF
        #         pdf(file, onefile = TRUE)
        #         # Now arrange them into a single PDF
        #         gridExtra::grid.arrange(
        #             top = "Rooftop Solar Job Impacts",
        #             grobs = list(map_grob, table_grob),
        #             ncol = 1, heights = c(2, 1)
        #         )
        #
        #         dev.off()
        #     }
        # )
        
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
        
        
        
        
        # output$phaseout_output_table <- renderTable({
        #     filtered_data() %>%
        #         filter(county == input$phaseout_counties_input) %>%
        #         select(year, excise_tax_scenario, setback_scenario, prod_quota_scenario, oil_price_scenario, county, total_emp)
        #
        # }) # END phaseout output table
        
        # Define reactive data frame for filtered_data
        filtered_data <- reactive({
            phaseout_employment_projection(
                county = input$phaseout_counties_input,
                excise_tax = 'no tax',
                setback = input$phaseout_setback_input,
                setback_existing = as.numeric(input$phaseout_setback_existing_input),
                oil_price = 'reference case',
                prod_quota = 'no quota',
                carbon_price = 'price floor'
            )
        })
        
        
        output$phaseout_plot <- renderPlotly({
            phaseout_plot <- filtered_data() %>%
                ggplot(aes(
                    x = as.factor(year),
                    y = total_emp,
                    text = paste("Year:", year, "<br>Jobs:", total_emp)
                )) +
                geom_col(position = "dodge", fill = "#A3BDBE") +
                #scale_x_discrete(breaks = scales::breaks_pretty(n=5)) +
                labs(
                    title = paste(
                        'Direct fossil fuel employment phaseout 2025–2045:',
                        gsub("_", " ", input$phaseout_setback_input),
                        'policy',
                        input$phaseout_setback_existing_input
                    ),
                    y = 'Total direct employment'
                ) +
                theme_minimal() +
                theme(axis.title.x = element_blank())
            
            plotly::ggplotly(phaseout_plot, tooltip = "text")
            
        })
        
        #phaseout leaflet map output ----
        output$phaseout_county_map_output <- renderLeaflet({
            counties_input <- reactive({
                if (!is.null(input$phaseout_counties_input)) {
                    ca_counties |> filter(name %in% input$phaseout_counties_input)
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
            
            leaflet_map
        })
        }
