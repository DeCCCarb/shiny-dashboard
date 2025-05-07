
server <- function(input, output, session) {
##### Tutorials #####
    
    # Automatically start tutorial on first session load
    once <- reactiveVal(TRUE)
    observeEvent(input$tabs, {
        if (input$tabs == "f_osw" && once()) {
            introjs(session, options = list(steps = list(
                list(intro = "👋 Welcome to the Floating Offshore Wind Development tab!"),
                list(element = "#osw_inputs_box", intro = "Start by adjusting assumptions for construction year, job type, and capacity."),
                list(element = "#osw_map_box", intro = "This map shows the offshore wind development location."),
                list(element = "#jobs_plot_box", intro = "Here are the projected job impacts over time."),
                list(element = "#capacity_plot_box", intro = "And this chart shows how capacity is expected to grow."),
                list(
                    element = ".sidebar-toggle",
                    intro = "We recommend collapsing the sidebar using this button to get more space."
                )
            )))
            once(FALSE) # only run the first time a user visits the tab
        } else if (input$tabs == "utility" && once()) {
            introjs(session, options = list(steps = list(
                list(intro = "👋 Welcome to the Utility Solar Development tab!"),
                list(element = "#util_inputs_box", intro = "Start by adjusting assumptions for construction year, job type, and capacity."),
                list(element = "#util_map_box", intro = "This map shows the total jobs created by county."),
                list(element = "#util_jobs_plot_box", intro = "Here are the projected job impacts over time."),
                list(element = "#util_capacity_plot_box", intro = "And this chart shows how capacity is expected to grow."),
                list(
                    element = ".sidebar-toggle",
                    intro = "We recommend collapsing the sidebar using this button to get more space."
                )
            )))
        } else if (input$tabs == "rooftop" && once()) {
            introjs(session, options = list(steps = list(
                list(intro = "👋 Welcome to the Rooftop Solar Development tab!"),
                list(element = "#roof_inputs_box", intro = "Start by adjusting assumptions for construction year, job type, and capacity."),
                list(element = "#roof_map_box", intro = "This map shows the total jobs created by county."),
                list(element = "#roof_jobs_plot_box", intro = "Here are the projected job impacts over time."),
                list(element = "#roof_capacity_plot_box", intro = "And this chart shows how capacity is expected to grow."),
                list(
                    element = ".sidebar-toggle",
                    intro = "We recommend collapsing the sidebar using this button to get more space."
                )
            )))
        } else if (input$tabs == "lb_wind" && once()) {
            introjs(session, options = list(steps = list(
                list(intro = "👋 Welcome to the Land-Based Wind Development tab!"),
                list(element = "#lw_inputs_box", intro = "Start by adjusting assumptions for construction year, job type, and capacity."),
                list(element = "#lw_map_box", intro = "This map shows the total jobs created by county."),
                list(element = "#lw_jobs_plot_box", intro = "Here are the projected job impacts over time."),
                list(element = "#lw_capacity_plot_box", intro = "And this chart shows how capacity is expected to grow."),
                list(
                    element = ".sidebar-toggle",
                    intro = "We recommend collapsing the sidebar using this button to get more space."
                )
            )))
        }
    })
    
    # Play tutorial when "Show Tutorial" button is pressed
    observeEvent(input$show_osw_tutorial, {
        if (input$tabs == "f_osw") {
            introjs(session, options = list(steps = list(
                list(intro = "👋 Welcome to the Floating Offshore Wind Development tab!"),
                list(element = "#osw_inputs_box", intro = "Start by adjusting assumptions."),
                list(element = "#osw_map_box", intro = "This map shows wind development."),
                list(element = "#jobs_plot_box", intro = "Projected job impacts."),
                list(element = "#capacity_plot_box", intro = "Expected capacity growth."),
                list(
                    element = ".sidebar-toggle",
                    intro = "You can collapse or expand the sidebar using this button to get more space."
                )
            )))
        } else if (input$tabs == "utility" && once()) {
            introjs(session, options = list(steps = list(
                list(intro = "👋 Welcome to the Utility Solar Development tab!"),
                list(element = "#util_inputs_box", intro = "Start by adjusting assumptions for construction year, job type, and capacity."),
                list(element = "#util_map_box", intro = "This map shows the total jobs created by county."),
                list(element = "#util_jobs_plot_box", intro = "Here are the projected job impacts over time."),
                list(element = "#util_capacity_plot_box", intro = "And this chart shows how capacity is expected to grow."),
                list(
                    element = ".sidebar-toggle",
                    intro = "We recommend collapsing the sidebar using this button to get more space."
                )
            )))
        } else if (input$tabs == "rooftop" && once()) {
            introjs(session, options = list(steps = list(
                list(intro = "👋 Welcome to the Rooftop Solar Development tab!"),
                list(element = "#roof_inputs_box", intro = "Start by adjusting assumptions for construction year, job type, and capacity."),
                list(element = "#roof_map_box", intro = "This map shows the total jobs created by county."),
                list(element = "#roof_jobs_plot_box", intro = "Here are the projected job impacts over time."),
                list(element = "#roof_capacity_plot_box", intro = "And this chart shows how capacity is expected to grow."),
                list(
                    element = ".sidebar-toggle",
                    intro = "We recommend collapsing the sidebar using this button to get more space."
                )
            )))
        } else if (input$tabs == "lb_wind" && once()) {
            introjs(session, options = list(steps = list(
                list(intro = "👋 Welcome to the Land-Based Wind Development tab!"),
                list(element = "#lw_inputs_box", intro = "Start by adjusting assumptions for construction year, job type, and capacity."),
                list(element = "#lw_map_box", intro = "This map shows the total jobs created by county."),
                list(element = "#lw_jobs_plot_box", intro = "Here are the projected job impacts over time."),
                list(element = "#lw_capacity_plot_box", intro = "And this chart shows how capacity is expected to grow."),
                list(
                    element = ".sidebar-toggle",
                    intro = "We recommend collapsing the sidebar using this button to get more space."
                )
            )))
        }
        })

    
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
    ) # end osw map observe event
    
    
    ###### Utility Solar Leaflet Map #######
    
    
    # Reactive counties input for utility pv Map
    counties_input_utility <- reactive({
        if (!is.null(input$county_input)) {
            ca_counties |> filter(name %in% input$county_input)
        } else {
            ca_counties
        }
    })
    
    # Reactive job calculations for selected counties
    utility_all_jobs <- reactive({
        
        # Calculation of rooftop solar jobs (construction and operations)
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
        
        county_utility <- rbind(county_utility_pv_const, county_utility_pv_om) |>
            filter(type %in% input$utility_job_type_input) |>
            select(-ambition)
    }) # End reactive to get number of jobs
    
    # Reactive county labels with job summaries
    utility_job_labels <- reactive({
        jobs <- utility_all_jobs()
        counties_sf <- counties_input_utility()
        
        job_summaries <- jobs |>
            group_by(county, occupation) |>
            summarise(n_jobs = sum(n_jobs, na.rm = TRUE), .groups = 'drop') |>
            tidyr::pivot_wider(names_from = occupation, values_from = n_jobs, values_fill = 0)
        
        counties_with_labels <- dplyr::left_join(counties_sf, job_summaries, by = c("name" = "county"))
        
        counties_with_labels$label <- paste0("<b> Total FTE jobs in </b>",
                                             "<b> <br>", counties_with_labels$name, " County </b><br>",
                                             "Construction: ", scales::comma(counties_with_labels$Construction), "<br>",
                                             "O&M: ", scales::comma(counties_with_labels$`O&M`)
        )
        
        counties_with_labels
    }) # End reactive county labels 
    
    # Render Utility leaflet map
    output$utility_map_output <- renderLeaflet({
        counties_sf <- utility_job_labels()
        
        # Get the coordinates of the centroids
        label_coords <- sf::st_coordinates(sf::st_centroid(counties_sf))
        
        # Define specific offsets for each county
        county_offsets <- list(
            "Santa Barbara" = c(x = -0.70, y = 0.04),  
            "San Luis Obispo" = c(x = -0.5, y = -0.2), 
            "Ventura" = c(x = -0.4, y = 0) 
        )
        
        # Apply the county-specific offsets for each county
        for (i in 1:nrow(counties_sf)) {
            county_name <- counties_sf$name[i]
            
            # Retrieve the corresponding offset for this county
            offset <- county_offsets[[county_name]]
            
            # Apply the offset to the centroid coordinates
            label_coords[i, 1] <- label_coords[i, 1] + offset["x"]
            label_coords[i, 2] <- label_coords[i, 2] + offset["y"]
        }
        
        # Convert the label coordinates into an sf object for plotting
        label_points <- st_as_sf(
            data.frame(lng = label_coords[, 1], lat = label_coords[, 2]),
            coords = c("lng", "lat"),
            crs = st_crs(counties_sf)
        )
        
        # Generate the leaflet map with labels at the adjusted centroids
        leaflet(counties_sf) |>
            addProviderTiles(providers$Stadia.StamenTerrain) |>
            setView(lng = -119.698189, lat = 34.420830, zoom = 7) |>
            addPolygons(
                color = "darkgreen",
                opacity = 0.7
            ) |>
            addLabelOnlyMarkers(
                data = label_points,
                label = lapply(counties_sf$label, HTML),
                labelOptions = labelOptions(
                    noHide = TRUE,
                    direction = 'left',
                    textsize = "12px",
                    opacity = 0.9
                )
            )
    }) # End render leaflet map
    
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
    output$utility_jobs_output <- renderPlotly({
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
        
        #### Generate plot for Utility ----
        utility_plot <- ggplot(county_utility,
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
                    "Projected {input$utility_job_type_input} jobs in CA Central Coast from Utility Solar development"
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
        
        
        
        plotly::ggplotly(utility_plot, tooltip = c("text"))  |>
            layout(hovermode = "x unified",
                   legend = list(x = 0.7, 
                                 xanchor = 'left',
                                 yanchor = 'top',
                                 orientation = 'h',
                                 title = "Occupation"))
        
    })
    
    # Generate capacity plot based on user selection ---
    output$utility_cap_projections_output <- renderPlotly({
        # O&M Roof ---
        
        utility <- calculate_pv_om_jobs(
            county = input$roof_counties_input,
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
        
        
        
        ######## Generate Capacity Plot for Utility ##############
        
        utility_cap_plot <- ggplot() +
            geom_point(
                data = utility,
                aes(x = as.factor(year), 
                    y = total_capacity_mw,
                    text = purrr::map(
                        paste0("Capacity: ", round(total_capacity_mw, 2), " MW"), HTML
                    )),
                color = "#3A8398"
            ) +
            scale_x_discrete(breaks = scales::breaks_pretty(n = 4)) +
            labs(y = "Capacity (MW)", title = "Annual Online Capacity (MW)") +
            theme_minimal() +
            theme(axis.title.x = element_blank())
        
        
        
        plotly::ggplotly(utility_cap_plot, tooltip = "text") |>
            layout(hovermode = "x unified") 
        
    }) # End Utility capacity plot
    
    
    # County selection
    counties_input <- reactive({
        counties |>
            filter(County == input$county_input)
    })
    
    
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
            
            ######## OSW Job Plot ##############
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
                config(osw_plot, modeBarButtonsToRemove = c('zoom2d','pan2d','autoScale',
                                                            'zoomIn', 'zoomOut','select',
                                                            'resetScale', 'lasso'),
                       displaylogo = FALSE,
                       toImageButtonOptions = list(
                           format = "jpeg",
                           width = 1000,
                           height = 700,
                           scale = 15
                       )) |>
                layout(hovermode = "x unified",
                       legend = list(x = 0.7, 
                                     xanchor = 'left',
                                     yanchor = 'top',
                                     orientation = 'h',
                                     title = "Occupation"))
        }
        
    }) # end osw jobs plot
    
    
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
        
        ######## OSW Capacity Plot ##############
        
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
            scale_x_discrete(breaks = scales::breaks_pretty(n = 4)) +
            labs(y = "Capacity (GW)", title = "Annual Online Capacity (GW)") +
            theme_minimal() +
            theme(axis.title.x = element_blank())
        
        
        
        plotly::ggplotly(osw_cap_plot, tooltip = "text") |>
            config(osw_cap_plot, modeBarButtonsToRemove = c('zoom2d','pan2d','autoScale',
                                                        'zoomIn', 'zoomOut','select',
                                                        'resetScale', 'lasso'),
                   displaylogo = FALSE,
                   toImageButtonOptions = list(
                       format = "jpeg",
                       width = 900,
                       height = 700,
                       scale = 15
                   )) |>
            layout(hovermode = "x unified")
        
    }) # End OSW capacity plot
    
######## Rooftop Solar ##########
    # Make the default values of capacity in the UI react to user input using renderUI-
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
    
    
    ##### Rooftop Solar Job Projections ####### 
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
        #### Generate plot for Roof ----
        roof_plot <- ggplot(county_roof,
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
                    "Projected {input$roof_job_type_input} jobs in CA Central Coast from Rooftop Solar development"
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
        
        
        
        plotly::ggplotly(roof_plot, tooltip = c("text"))  |>
            layout(hovermode = "x unified",
                   legend = list(x = 0.7, 
                                 xanchor = 'left',
                                 yanchor = 'top',
                                 orientation = 'h',
                                 title = "Occupation"))
    })
    
    # Generate capacity plot based on user selection ---
    output$roof_cap_projections_output <- renderPlotly({
        # O&M Roof ---
        
        roof <- calculate_pv_om_jobs(
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
        
        
        
        ######## Generate Capacity Plot for Rooftop ##############
        
        roof_cap_plot <- ggplot() +
            geom_point(
                data = roof,
                aes(x = as.factor(year), 
                    y = total_capacity_mw,
                    text = purrr::map(
                        paste0("Capacity: ", round(total_capacity_mw, 2), " MW"), HTML
                    )),
                color = "#3A8398"
            ) +
            scale_x_discrete(breaks = scales::breaks_pretty(n = 4)) +
            labs(y = "Capacity (MW)", title = "Annual Online Capacity (MW)") +
            theme_minimal() +
            theme(axis.title.x = element_blank())
        
        
        
        plotly::ggplotly(roof_cap_plot, tooltip = "text") |>
            layout(hovermode = "x unified") 
        
    }) # End Rooftop capacity plot
    
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
    
    ###### Rooftop Solar Leaflet Map #######
    
    
    # Reactive counties input for Land Wind Map
    counties_input_roof <- reactive({
        if (!is.null(input$roof_counties_input)) {
            ca_counties |> filter(name %in% input$roof_counties_input)
        } else {
            ca_counties
        }
    })
    
    # Reactive job calculations for selected counties
    roof_all_jobs <- reactive({
        
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
    }) # End reactive to get number of jobs
    
    # Reactive county labels with job summaries
    roof_job_labels <- reactive({
        jobs <- roof_all_jobs()
        counties_sf <- counties_input_roof()
        
        job_summaries <- jobs |>
            group_by(county, occupation) |>
            summarise(n_jobs = sum(n_jobs, na.rm = TRUE), .groups = 'drop') |>
            tidyr::pivot_wider(names_from = occupation, values_from = n_jobs, values_fill = 0)
        
        counties_with_labels <- dplyr::left_join(counties_sf, job_summaries, by = c("name" = "county"))
        
        counties_with_labels$label <- paste0("<b> Total FTE jobs in </b>",
                                             "<b> <br>", counties_with_labels$name, " County </b><br>",
                                             "Construction: ", scales::comma(counties_with_labels$Construction), "<br>",
                                             "O&M: ", scales::comma(counties_with_labels$`O&M`)
        )
        
        counties_with_labels
    }) # End reactive county labels 
    
    # Render rooftop leaflet map
    output$roof_map_output <- renderLeaflet({
        counties_sf <- roof_job_labels()
        
        # Get the coordinates of the centroids
        label_coords <- sf::st_coordinates(sf::st_centroid(counties_sf))
        
        # Define specific offsets for each county
        county_offsets <- list(
            "Santa Barbara" = c(x = -0.70, y = 0.04),  
            "San Luis Obispo" = c(x = -0.5, y = -0.2), 
            "Ventura" = c(x = -0.4, y = 0) 
        )
        
        # Apply the county-specific offsets for each county
        for (i in 1:nrow(counties_sf)) {
            county_name <- counties_sf$name[i]
            
            # Retrieve the corresponding offset for this county
            offset <- county_offsets[[county_name]]
            
            # Apply the offset to the centroid coordinates
            label_coords[i, 1] <- label_coords[i, 1] + offset["x"]
            label_coords[i, 2] <- label_coords[i, 2] + offset["y"]
        }
        
        # Convert the label coordinates into an sf object for plotting
        label_points <- st_as_sf(
            data.frame(lng = label_coords[, 1], lat = label_coords[, 2]),
            coords = c("lng", "lat"),
            crs = st_crs(counties_sf)
        )
        
        # Generate the leaflet map with labels at the adjusted centroids
        leaflet(counties_sf) |>
            addProviderTiles(providers$Stadia.StamenTerrain) |>
            setView(lng = -119.698189, lat = 34.420830, zoom = 7) |>
            addPolygons(
                color = "darkgreen",
                opacity = 0.7
            ) |>
            addLabelOnlyMarkers(
                data = label_points,
                label = lapply(counties_sf$label, HTML),
                labelOptions = labelOptions(
                    noHide = TRUE,
                    direction = 'left',
                    textsize = "12px",
                    opacity = 0.9
                )
            )
    }) # End render leaflet map
    
    
    # output$roof_county_map_output <- renderLeaflet({
    #     counties_input <- reactive({
    #         if (!is.null(input$roof_counties_input)) {
    #             ca_counties |> filter(name %in% input$roof_counties_input)
    #         } else {
    #             ca_counties
    #         }
    #     })
    #     
    #     icons <- awesomeIcons(
    #         icon = 'helmet-safety',
    #         iconColor = 'black',
    #         library = 'fa',
    #         markerColor = "orange"
    #     )
    #     
    #     leaflet_map <- leaflet() |>
    #         addProviderTiles(providers$Stadia.StamenTerrain) |>
    #         setView(lng = -119.698189,
    #                 lat = 34.420830,
    #                 zoom = 7) |>
    #         addPolygons(data = counties_input())
    #     
    #     # Only add ports if selected
    #     if (!is.null(input$port_input) &&
    #         length(input$port_input) > 0) {
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
    #     
    #     
    #     leaflet_map
    # })
    # 
    
    
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
    
    ############### Land Based Wind Leaflet Map ###############
    
    # Reactive counties input for Land Wind Map
    counties_input_lw <- reactive({
        if (!is.null(input$lw_counties_input)) {
            ca_counties |> filter(name %in% input$lw_counties_input)
        } else {
            ca_counties
        }
    })
    
    # Reactive job calculations for selected counties
    lw_all_jobs <- reactive({
        counties <- input$lw_counties_input
        start_year <- input$input_lw_years[1]
        end_year <- input$input_lw_years[2]
        initial_capacity <- input$initial_gw_lw_input
        final_capacity <- input$final_gw_land_input
        
        # Define job multipliers per county
        job_factors <- list(
            "Santa Barbara" = list(const = c(139, 354, 139), om = c(14, 23, 8)),
            "San Luis Obispo" = list(const = c(25, 207, 113), om = c(14, 21, 7)),
            "Ventura" = list(const = c(140, 345, 139), om = c(14, 24, 8))
        )
        
        # Loop through counties and calculate jobs
        purrr::map_dfr(counties, function(cty) {
            factors <- job_factors[[cty]]
            
            const <- calculate_land_wind_construction_jobs(
                county = cty,
                start_year = start_year,
                end_year = end_year,
                initial_capacity = initial_capacity,
                final_capacity = final_capacity,
                direct_jobs = factors$const[1],
                indirect_jobs = factors$const[2],
                induced_jobs = factors$const[3]
            )
            
            om <- calculate_land_wind_om_jobs(
                county = cty,
                start_year = start_year,
                end_year = end_year,
                initial_capacity = initial_capacity,
                final_capacity = final_capacity,
                direct_jobs = factors$om[1],
                indirect_jobs = factors$om[2],
                induced_jobs = factors$om[3]
            )
            
            rbind(const, om)
        }) |> 
            filter(type %in% input$lw_job_type_input)
    }) # End reactive job calculations per county
    
    # Reactive county labels with job summaries
    lw_job_labels <- reactive({
        jobs <- lw_all_jobs()
        counties_sf <- counties_input_lw()
        
        job_summaries <- jobs |>
            group_by(county, occupation) |>
            summarise(n_jobs = sum(n_jobs, na.rm = TRUE), .groups = 'drop') |>
            tidyr::pivot_wider(names_from = occupation, values_from = n_jobs, values_fill = 0)
        
        counties_with_labels <- dplyr::left_join(counties_sf, job_summaries, by = c("name" = "county"))
        
        counties_with_labels$label <- paste0("<b> Total FTE jobs in </b>",
            "<b> <br>", counties_with_labels$name, " County </b><br>",
            "Construction: ", scales::comma(counties_with_labels$Construction), "<br>",
            "O&M: ", scales::comma(counties_with_labels$`O&M`)
        )
        
        counties_with_labels
    }) # End reactive county labels 
    
    # Render LW leaflet map
    output$land_wind_map_output <- renderLeaflet({
        counties_sf <- lw_job_labels()
 
        # Get the coordinates of the centroids
        label_coords <- sf::st_coordinates(sf::st_centroid(counties_sf))
        
        # Define specific offsets for each county
        county_offsets <- list(
            "Santa Barbara" = c(x = -0.70, y = 0.04),  
            "San Luis Obispo" = c(x = -0.5, y = -0.2), 
            "Ventura" = c(x = -0.4, y = 0) 
        )
        
        # Apply the county-specific offsets for each county
        for (i in 1:nrow(counties_sf)) {
            county_name <- counties_sf$name[i]
            
            # Retrieve the corresponding offset for this county
            offset <- county_offsets[[county_name]]
            
            # Apply the offset to the centroid coordinates
            label_coords[i, 1] <- label_coords[i, 1] + offset["x"]
            label_coords[i, 2] <- label_coords[i, 2] + offset["y"]
        }
        
        # Convert the label coordinates into an sf object for plotting
        label_points <- st_as_sf(
            data.frame(lng = label_coords[, 1], lat = label_coords[, 2]),
            coords = c("lng", "lat"),
            crs = st_crs(counties_sf)
        )
        
        # Generate the leaflet map with labels at the adjusted centroids
        leaflet(counties_sf) |>
            addProviderTiles(providers$Stadia.StamenTerrain) |>
            setView(lng = -119.698189, lat = 34.420830, zoom = 7) |>
            addPolygons(
                color = "darkgreen",
                opacity = 0.7
            ) |>
            addLabelOnlyMarkers(
                data = label_points,
                label = lapply(counties_sf$label, HTML),
                labelOptions = labelOptions(
                    noHide = TRUE,
                    direction = 'left',
                    textsize = "12px",
                    opacity = 0.9
                )
            )
    }) # End render leaflet map
    
    
    
    ######## Land wind plot output #######
    output$land_wind_jobs_plot_output <- renderPlotly({
        
        # Calculate jobs by county from user input
        land_wind_om_sb <- calculate_land_wind_om_jobs(
            county = "Santa Barbara",
            start_year = input$input_lw_years[1],
            end_year = input$input_lw_years[2],
            initial_capacity = input$initial_gw_lw_input,
            final_capacity = input$final_gw_land_input,
            direct_jobs = 14,
            indirect_jobs = 23,
            induced_jobs = 8
        )
        
        land_wind_const_sb <- calculate_land_wind_construction_jobs(
            county = "Santa Barbara",
            start_year = input$input_lw_years[1],
            end_year = input$input_lw_years[2],
            initial_capacity = input$initial_gw_lw_input,
            final_capacity = input$final_gw_land_input,
            direct_jobs = 139,
            indirect_jobs = 354,
            induced_jobs = 139
        )
        
        land_wind_om_slo <- calculate_land_wind_om_jobs(
            county = "San Luis Obispo",
            start_year = input$input_lw_years[1],
            end_year = input$input_lw_years[2],
            initial_capacity = input$initial_gw_lw_input,
            final_capacity = input$final_gw_land_input,
            direct_jobs = 14,
            indirect_jobs = 21,
            induced_jobs = 7
        )
        
        land_wind_const_slo <- calculate_land_wind_construction_jobs(
            county = "San Luis Obispo",
            start_year = input$input_lw_years[1],
            end_year = input$input_lw_years[2],
            initial_capacity = input$initial_gw_lw_input,
            final_capacity = input$final_gw_land_input,
            direct_jobs = 25,
            indirect_jobs = 207,
            induced_jobs = 113
        )
        
        land_wind_om_v <- calculate_land_wind_om_jobs(
            county = "Ventura",
            start_year = input$input_lw_years[1],
            end_year = input$input_lw_years[2],
            initial_capacity = input$initial_gw_lw_input,
            final_capacity = input$final_gw_land_input,
            direct_jobs = 14,
            indirect_jobs = 24,
            induced_jobs = 8
        )
        
        land_wind_const_v <- calculate_land_wind_construction_jobs(
            county = "Ventura",
            start_year = input$input_lw_years[1],
            end_year = input$input_lw_years[2],
            initial_capacity = input$initial_gw_lw_input,
            final_capacity = input$final_gw_land_input,
            direct_jobs = 140,
            indirect_jobs = 345,
            induced_jobs = 139
        )
        
        # Create joined dataframe
        lw_all <- rbind(land_wind_const_sb, land_wind_om_sb,
                        land_wind_const_slo, land_wind_om_slo,
                        land_wind_const_v, land_wind_om_v) |>
            filter(type %in% input$lw_job_type_input) |> # Filter to inputted job type
            filter(county %in% input$lw_counties_input)
        
        ######## Generate Plot for LW Jobs ##############
        lw_plot <- ggplot(lw_all,
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
                    "Projected {input$lw_job_type_input} jobs in {input$lw_counties_input} County from Land Wind development"
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
        
        plotly::ggplotly(lw_plot, tooltip = c("text"))  |>
            layout(hovermode = "x unified",
                   legend = list(x = 0.7, 
                                 xanchor = 'left',
                                 yanchor = 'top',
                                 orientation = 'h',
                                 title = "Occupation"))
        
    }) # end lw jobs plot
    
    ######## Generate Plot for LW Capacity ##############
    
    output$lw_cap_projections_output <- renderPlotly({
        lw_cap <- calculate_land_wind_om_jobs(
            county = input$lw_counties_input,
            start_year = input$input_lw_years[1],
            end_year = input$input_lw_years[2],
            initial_capacity = input$initial_gw_lw_input,
            final_capacity = input$final_gw_land_input,
            direct_jobs = 127,
            indirect_jobs = 126,
            induced_jobs = 131
        )
        
        
        # Generate capacity plot based on user selection
        lw_cap_plot <- ggplot() +
            geom_point(
                data = lw_cap,
                aes(x = as.factor(year), 
                    y = total_capacity_gw,
                    text = purrr::map(
                        paste0("Capacity: ", round(total_capacity_gw, 2), " GW"), HTML
                    )),
                color = "#3A8398"
            ) +
            scale_x_discrete(breaks = scales::breaks_pretty(n = 4)) +
            scale_y_continuous(breaks = scales::breaks_pretty(n = 4)) +
            labs(y = "Capacity (GW)", title = "Annual Online Capacity (GW)") +
            theme_minimal() +
            theme(axis.title.x = element_blank())
        
        
        
        plotly::ggplotly(lw_cap_plot, tooltip = "text") |>
            layout(hovermode = "x unified")
        
    }) # End LW capacity plot
    
    
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
            labs(
                title = glue::glue(
                    "Projected fossil fuel jobs in {input$phaseout_counties_input} County"),
                y = 'Total direct employment') +
            theme_minimal() +
            theme(axis.title.x = element_blank())
        
        plotly::ggplotly(phaseout_plot, tooltip = "text") |>
            layout(hovermode = "x unified") 

        
    })
    
    
##### OIL CAPPING #####
    # Oil capping leaflet map output ----
    output$capping_map_output <- renderLeaflet({
        
        # Well counts, number of jobs, and label coordinates
        well_count <- c(1977, 3188, 337)
        n_jobs <- c(494, 797, 84)
        annual_jobs <- c(25, 40, 4)
        label_coords <- data.frame(
            name = c("Santa Barbara", "San Luis Obispo", "Ventura"),
            lng = c(-120.7201, -121.0508, -119.4855),
            lat = c(34.58742, 35.40949, 34.35622)
        )
        
        # Prepare the county data with label text
        ca_counties <- ca_counties |>
            mutate(
                label_text = paste0("<b><u><font size = '2.5'>", name, " County </b></u></font><br>Total Oil & Gas Wells: ", well_count,
                                    "<br> Total FTE Jobs: ", n_jobs,
                                    "<br>",
                                    "<br> Capping all idle & active wells from <br> 2025-2045 will create ", annual_jobs, " jobs/year "
                                    )

            )
        
        # Filter the data to the selected county only for both polygon and label
        label_data <- ca_counties |>
            filter(name == input$county_wells_input) |>
            left_join(label_coords, by = "name") |>
            st_drop_geometry()
        
        # Set up the map
        leaflet_map <- leaflet() |>
            addProviderTiles(providers$Stadia.StamenTerrain) |>
            setView(lng = -120.298189, lat = 34.820830, zoom = 8)
        
        # Add the polygon for the selected county only (hide others)
        leaflet_map <- leaflet_map |>
            addPolygons(
                data = ca_counties |> filter(name == input$county_wells_input),  # Only add selected county's polygon
                color = "forestgreen", 
                opacity = 0.7,
            )
        
        # Add label only for the selected county if a county is selected
        if (!is.null(input$county_wells_input)) {
            leaflet_map <- leaflet_map |>
                addLabelOnlyMarkers(
                    lng = label_data$lng,
                    lat = label_data$lat,
                    label = lapply(label_data$label_text, HTML),
                    labelOptions = labelOptions(
                        noHide = TRUE,
                        direction = 'left',
                        textsize = "12px",
                        opacity = 0.9
                    )
                )
        }
        
        leaflet_map
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
