
# Dashboard header ----
header <- dashboardHeader(
    
    # title ----
    title = 'Labor Impacts of Decarbonization', # Tentative title
    titleWidth = 800
    
    
)

# dashboard sidebar ---
sidebar <- dashboardSidebar(
    
    ##### sidebarMenu: tabNames  #######
    sidebarMenu(
        menuItem(text = 'Project Overview', tabName = 'overview', icon = icon('star')),
        menuItem(text = 'Floating Offshore Wind', tabName = 'f_osw', icon = icon('gauge')),
        menuItem(text = 'Utility Solar', tabName = 'utility', icon = icon('gauge')), # change icons for all
        menuItem(text = 'Rooftop Solar', tabName = 'rooftop', icon = icon('gauge')),
        menuItem(text = 'Land Based Wind', tabName = 'lb_wind', icon = icon('gauge')),
        menuItem(text = 'Oil Well Capping', tabName = 'well_cap', icon = icon('gauge')),
        menuItem(text = 'Fossil Fuel Phaseout', tabName = 'phaseout', icon = icon('gauge')),
        menuItem(text = 'Tool Documentation', tabName = 'documentation', icon = icon('cog'))
        
        
    ) #  END sidebar Menu
    
)

# dashboard body ----
body <- dashboardBody(
    
    # set theme ----
    use_theme('dashboard-fresh-theme.css'),
    
    # tabItems ----
    tabItems(
       
        # Project overview tab item ---
        tabItem(
            tabName = 'overview',
            
            # left hand column ----
            column(width = 6,
                   
                   # background info box ----
                   box(width = NULL,
                       title = tagList(icon('solar-panel')),
                       
                       # use columns to create white space on sides
                       #column(1),
                       column(12, includeMarkdown("text/intro.md")),
                       #column(1),
                       tags$img(src = "teamwork-engineer-wearing-safety-uniform.jpg",
                                alt = 'Photo of people working in front of a wind turbine',
                                style = 'max-width: 100%',
                                tags$h6('Image Source:',
                                        tags$a(href = 'https://bren.ucsb.edu/projects/modeling-impact-decarbonization-labor-californias-central-coast', 'Bren MEDS Capstone Projects')))
                       
                   ) # END background info box
                   
                   
            ), # END left hand column
            # right hand column ----
            column(width = 6,
                   
                   # first fluidRow ----
                   fluidRow(
                       
                       # citation box ----
                       box(width = NULL,
                           
                           title= tagList(icon('sourcetree'),
                                          tags$strong('Data Source')),
                           column(1),
                           column(10, includeMarkdown('text/citation.md')),
                           column(1)
                           
                       ) # END citation box
                       
                   ), # END first fluidRow
                   # Create another fluidRow
                   fluidRow(
                       
                       # # # disclaimer box ----
                       box(width = NULL,
                           title = tagList(icon('user'),
                                           tags$strong('Hosted By')),
                           column(1),
                           column(10, includeMarkdown('text/disclaimer.md')),
                           column(1)
                           
                       ) # END disclaimer box
                       
                       
                   ), # END 2nd fluidRow
                   # Begin third fluidRow with counties map
                   fluidRow( 
                       # Add Box for TMap
                       box( 
                           width = NULL,
                           tags$img(src = "california_counties_map1.png",
                                    alt = 'Map of California with SLO, Santa Barbara, and Ventura Counties highlighted',
                                    style = 'max-width: 100%',
                                    height = '500px',
                                    width = '500px',
                                    tags$h6('Made using TMap',
                                            tags$a(href = 'Made using TMap and USData.')))
                       ) # End CCC TMap box
                       
                       
                   ) # End third fluidRow ---
                   
                   
            ) # END right hand column
            
            
        ), # END Project Overview tabItem
        
        
        ########## Tool/Dashboard tabItem for floating offshore wind ###########
        tabItem(tabName = 'f_osw',
                
                # Create a fluidRow ---
                fluidRow(
                    
                    # input box ----
                    box(width = 4,
                        title = tags$strong('Floating Offshore Wind Project Inputs'),
                        
                        # pickerInputs ----
                        shinyjs::useShinyjs(),  # Enable shinyjs
                        # year range slider input ----
                        sliderInput(inputId = 'year_range_input',
                                    label = 'Year Construction Starts - Year to Meet Target',
                                    min = 2025,
                                    max = 2045,
                                    value = c(2025, 2045),
                                    step = 1,
                                    ticks = F,
                                    sep = ""),
                        tags$script(HTML("
                                        // Wait until the document is ready
                                        $(document).on('shiny:connected', function() {
                                          // Custom minimum range
                                          var minRange = 6; // Construction year boundary, minimum to reach target
                                    
                                          // Target the slider
                                          var slider = $('#year_range_input').data('ionRangeSlider');
                                          if (slider) {
                                            slider.update({
                                              onChange: function(data) {
                                                var from = data.from;
                                                var to = data.to;
                                                if ((to - from) < minRange) {
                                                  var newTo = from + minRange;
                                                  if (newTo > data.max) {
                                                    newTo = data.max;
                                                    from = newTo - minRange;
                                                  }
                                                  slider.update({ from: from, to: newTo });
                                                }
                                              }
                                            });
                                          }
                                        });
                                      ")),
                        
                        # Select job type input ----
                        pickerInput(inputId = 'job_type_input',
                                    label = 'Direct, Induced, or Indirect Job Impacts',
                                    choices = c(
                                        'direct', # Change to capital 
                                        'indirect', 
                                        'induced'
                                    ),
                                    multiple = FALSE,
                                    options = pickerOptions(actionsBox = TRUE)),
                        # Enter Numeric Input for initial capacity -----
                        numericInput(inputId = 'initial_capacity_input',
                                     label = 'Capacity (GW) of Initial Construction Project',
                                     value = 0.1,
                                     min = 0),
                        # Enter Numeric Input for final capacity -----
                        numericInput(inputId = 'final_capacity_input',
                                     label = 'Target Capacity (GW)',
                                     value = 15,
                                     min = 0), 
                        # Select Port/No Port
                        pickerInput(inputId = 'osw_port_input',
                                    label = 'Offshore Wind Port Location:',
                                    choices = c('Hueneme', 'San Luis Obispo'),
                                    selected = NULL,
                                    multiple = FALSE,
                                    options = pickerOptions(actionsBox = TRUE))
                        
                    ), # END input box
                    
                    #leaflet box ----
                    box(width = 6,
                        
                        leafletOutput(outputId = 'osw_map_output') |> 
                            withSpinner(type = 1, color = '#09847A')
                   
                    ), # END leaflet box
                    
                    ######### Interactive Plotly Output for OSW ##########-----
                    box(width = 12,
                        # Create a table based on input
                        title = tags$strong('Labor Impact'),
                        plotly::plotlyOutput(outputId = 'model_jobs_output') |> # Changed to table output to show data
                            withSpinner(type = 1, color = '#09847A'))
                    
                )# END  1st fluidRow 
                
        ), # END floating offshore wind tabITEM
        tabItem(tabName = 'utility',
                # Create a fluidRow ---
                # fluidRow(
                #     
                #     # input box ----
                #     box(width = 4,
                #         title = tags$strong('Pick a County'),
                #         
                #         # pickerInputs ----
                #         
                #         # Enter Numeric Input for start year
                #         numericInput(inputId = 'start_yr_utility_input',
                #                      label = 'Year that construction starts:',
                #                      value = 2025,
                #                      min = 2025),
                #         # Enter Numeric Input for start year
                #         numericInput(inputId = 'end_yr_utility_input',
                #                      label = 'End year to meet targets:',
                #                      value = 2045,
                #                      min = 2025),
                #         pickerInput(inputId = 'county_input',
                #                     label = 'Select a County:',
                #                     choices = unique(counties$County),
                #                     selected = c('Ventura'),
                #                     multiple = FALSE,
                #                     options = pickerOptions(actionsBox = TRUE)),
                #         # Select job type input ----
                #         pickerInput(inputId = 'utility_job_type_input',
                #                     label = 'Select Direct, Induced, or Indirect',
                #                     choices = c('direct', 
                #                                 'induced',
                #                                 'indirect'),
                #                     multiple = FALSE,
                #                     options = pickerOptions(actionsBox = TRUE)),
                #         # Enter Numeric Input for initial capacity -----
                #         numericInput(inputId = 'initial_mw_utility_input',
                #                      label = 'Please input your initial MW capacity.',
                #                      value = 0,  # placeholder — will be updated
                #                      min = 0),
                #         # Enter Numeric Input for final capacity -----
                #         numericInput(inputId = 'final_mw_utility_input',
                #                      label = 'Please input your final MW capacity.',
                #                      value = 0,
                #                      min = 0), 
                #         # Select Port/No Port
                #         pickerInput(inputId = 'port_input',
                #                     label = 'Offshore Wind Port Location:',
                #                     choices = c('Hueneme', 'Morro Bay'),
                #                     selected = c('Hueneme', 'Morro Bay'),
                #                     multiple = TRUE,
                #                     options = pickerOptions(actionBox = TRUE))
                #         
                #     ), # END input box
                #     
                #     #leaflet box ----
                #     box(width = 6,
                #         
                #         # title 
                #         title = tags$strong('California Central Coast Counties'),
                #         
                #         leafletOutput(outputId = 'utility_county_map_output') |> 
                #             withSpinner(type = 1, color = 'forestgreen')
                #         
                #         
                #         
                #     ), # END leaflet box
                #     
                #     # Projections table box -----
                #     box(width = 12,
                #         # Create a table based on input
                #         title = tags$strong('Utility Solar Job Impacts'),
                #         tableOutput(outputId = 'utility_jobs_output') |> # Changed to table output to show data
                #             withSpinner(type = 1, color = 'forestgreen'))
                #     
                # ),# END  2nd fluidRow)
                fluidRow(
                # input box ----
                box(width = 4,
                    title = tags$strong('Pick a County'),
                    
                    # pickerInputs ----
                    
                    # Enter Slider Input for year range
                    sliderInput(inputId = 'year_range_input_utility',
                                label = 'Year Range (CHOOSE BETTER LABEL)',
                                min = 2025,
                                max = 2045,
                                value = c(2025, 2045),
                                step = 1,
                                ticks = TRUE,
                                sep = ""),
                    pickerInput(inputId = 'county_input',
                                label = 'Select a County:',
                                choices = unique(counties$County),
                                selected = c('Ventura'),
                                multiple = FALSE,
                                options = pickerOptions(actionsBox = TRUE)),
                    # Select job type input ----
                    pickerInput(inputId = 'utility_job_type_input',
                                label = 'Select Direct, Induced, or Indirect',
                                choices = c('direct', 
                                            'induced',
                                            'indirect'),
                                multiple = FALSE,
                                options = pickerOptions(actionsBox = TRUE)),
                    # Enter Numeric Input for initial capacity -----
                    numericInput(inputId = 'initial_mw_utility_input',
                                 label = 'Please input your initial capacity (MW).',
                                 value = 0,  # placeholder — will be updated
                                 min = 0),
                    # Enter Numeric Input for final capacity -----
                    numericInput(inputId = 'final_mw_utility_input',
                                 label = 'Please input your final capacity (MW).',
                                 value = 0,
                                  min = 0) 
                    # # Select Port/No Port
                    # pickerInput(inputId = 'port_input',
                    #             label = 'Offshore Wind Port Location:',
                    #             choices = c('Hueneme', 'Morro Bay'),
                    #             selected = c('Hueneme', 'Morro Bay'),
                    #             multiple = TRUE,
                    #             options = pickerOptions(actionBox = TRUE))
                    
                ), # END input box
                
                #leaflet box ----
                box(width = 6,
                    
                    # title 
                    title = tags$strong('California Central Coast Counties'),
                    
                    leafletOutput(outputId = 'utility_county_map_output') |> 
                        withSpinner(type = 1, color = '#09847A')
                    
                    
                    
                ), # END leaflet box

                # Projections table box -----
                box(width = 12,
                    # Create a table based on input
                    title = tags$strong('Utility Solar Job Impacts'),
                    tableOutput(outputId = 'utility_jobs_output') |> # Changed to table output to show data
                        withSpinner(type = 1, color = '#09847A'))
                
            )# END  2nd fluidRow)
    ), # End Utility Solar tabItem
    
    tabItem(tabName = 'rooftop',
            # Create a fluid row
            # Create a fluidRow ---
            fluidRow(

                # input box ----
                box(width = 4,
                    title = tags$strong('Pick a County'),

                    # pickerInputs ----

                    # Enter slider Input for start year
                    sliderInput(inputId = 'year_range_input_roof',
                                label = 'Year Range (CHOOSE BETTER LABEL)',
                                min = 2025,
                                max = 2045,
                                value = c(2025, 2045),
                                step = 1,
                                ticks = TRUE,
                                sep = ""),
                    pickerInput(inputId = 'roof_counties_input',
                                label = 'Select a County:',
                                choices = unique(counties$County),
                                selected = c('Ventura'),
                                multiple = FALSE,
                                options = pickerOptions(actionsBox = TRUE)),
                    # Select job type input ----
                    pickerInput(inputId = 'roof_job_type_input',
                                label = 'Select Direct, Induced, or Indirect',
                                choices = c('direct',
                                            'induced',
                                            'indirect'),
                                multiple = FALSE,
                                options = pickerOptions(actionsBox = TRUE)),
                    # Enter Numeric Input for initial capacity -----
                    numericInput(inputId = 'initial_mw_roof_input',
                                 label = 'Please input your initial capacity (MW).',
                                 value = 0,  # placeholder — will be updated
                                 min = 0),
                    # Enter Numeric Input for final capacity -----
                    numericInput(inputId = 'final_mw_roof_input',
                                 label = 'Please input your final capacity (MW).',
                                 value = 0,
                                 min = 0)

                ), # END input box

                #leaflet box ----
                box(width = 6,

                    # title
                    title = tags$strong('California Central Coast Counties'),

                    # Leaflet rendering from server
                    leafletOutput(outputId = 'roof_county_map_output') |>
                        withSpinner(type = 1, color = '#09847A')

                ), # END leaflet box

                # Projections table box -----
                box(width = 12,
                    # Create a table based on input
                    title = tags$strong('Rooftop Solar Job Impacts'),
                    tableOutput(outputId = 'roof_jobs_output') |> # Changed to table output to show data
                        withSpinner(type = 1, color = '#09847A'))

            )# END  2nd fluidRow)


 
                
        ), # End Rooftop Solar tabItem
        tabItem(tabName = 'lb_wind',
                # Create a fluid row
                # Create a fluidRow ---
                fluidRow(
                    
                    # input box ----
                    box(width = 4,
                        title = tags$strong('Land Based Wind Development'),
                        
                        # pickerInputs ----
                        sliderInput(inputId = 'input_lw_years',
                                    label = 'Select a range of years',
                                    min = 2026,
                                    max = 2050,
                                    value = c(2026, 2045),
                                    dragRange = TRUE,
                                    sep = ''),
                        # Slider Range output for land wind ---- 
                        verbatimTextOutput("input_lw_years"),
                        pickerInput(inputId = 'lw_counties_input',
                                    label = 'Select a County:',
                                    choices = unique(counties$County),
                                    selected = c('Ventura'),
                                    multiple = FALSE,
                                    options = pickerOptions(actionsBox = TRUE)),
                        # Select job type input ----
                        pickerInput(inputId = 'lw_job_type_input',
                                    label = 'Select Direct, Induced, or Indirect',
                                    choices = c('direct',
                                                'induced',
                                                'indirect'),
                                    multiple = FALSE,
                                    options = pickerOptions(actionsBox = TRUE)),
                        # Enter Numeric Input for initial capacity -----
                        numericInput(inputId = 'initial_gw_lw_input',
                                     label = 'Please input your initial capacity (GW).',
                                     value = 0,  # placeholder — will be updated
                                     min = 0),
                        # Enter Numeric Input for final capacity -----
                        numericInput(inputId = 'final_gw_land_input',
                                     label = 'Please input your final capacity (GW).',
                                     value = 0,
                                     min = 0)
                        
                    ), # End input box
                    # Projections table box -----
                    box(width = 12,
                        # Create a table based on input
                        title = tags$strong('Land Based Wind Job Impacts'),
                        tableOutput(outputId = 'lw_jobs_output') |> # Changed to table output to show data
                            withSpinner(type = 1, color = '#09847A'))
                    
                    
                ) # End 1st fluidRow
        ), # End Land Based Wind tabItem
    tabItem(tabName = 'well_cap',
            fluidRow(
                box(
                    width = 4,
                    title = 'Oil Well Capping',
                    pickerInput(
                        inputId = 'county_wells_input',
                        choices = c('San Luis Obispo',
                                    'Ventura',
                                    'Santa Barbara'),
                        multiple = FALSE
                    ) # End county picker
                    
                )# End box for inputs?
                
            )# End fluidRow for well capping
            ), # end well capping tab item 
    tabItem(tabName = 'phaseout',
            # Create a fluidRow ---
            fluidRow(

                # input box ----
                box(width = 6,
                    title = tags$strong('Pick a County'),

                    #pickerInputs ----
                    # Enter county
                    pickerInput(inputId = 'phaseout_counties_input',
                                label = 'Select a County:',
                                choices = c('Santa Barbara',
                                            'San Luis Obispo',
                                            'Ventura'),
                                selected = c('Ventura'),
                                multiple = FALSE,
                                options = pickerOptions(actionsBox = TRUE)),

                    # Select setback input ----
                    pickerInput(inputId = 'phaseout_setback_input',
                                label = 'Select Setback Policy',
                                choices = c('setback_1000ft',
                                            'setback_2500ft',
                                            'setback_5280ft',
                                            'no_setback'),
                                selected = c('setback_2500ft'),
                                multiple = FALSE,
                                options = pickerOptions(actionsBox = TRUE)),
                    
                    # Select setback existing input ----
                    pickerInput(
                        inputId = 'phaseout_setback_existing_input',
                        label = 'Should the setback policy apply to existing wells?',
                        choices = c(
                            'Setback policy applies to new and existing wells' = 0,
                            'Setback policy applies only to new wells' = 1
                        ),
                        selected = 1,
                        multiple = FALSE,
                        options = pickerOptions(actionsBox = TRUE)
                        )
                ), # END input box
                
                #leaflet box ----
                box(width = 6,
                    
                    # title
                    title = tags$strong('California Central Coast Counties'),
                    
                    # Leaflet rendering from server
                    leafletOutput(outputId = 'phaseout_county_map_output') |>
                        withSpinner(type = 1, color = '#09847A')
                ) # END leaflet box


            ), # END  1st fluidRow
            
            fluidRow(
                
                    
                    ######### Interactive Plotly Output for FF Phaseout ##########-----
                    box(width = 12,
                        # Create a table based on input
                        title = tags$strong('Labor Impact'),
                        plotly::plotlyOutput(outputId = 'phaseout_plot') |> # Changed to table output to show data
                            withSpinner(type = 1, color = '#09847A')), # END plot box
                    
                
            ) # END 2nd fluid row
            
            
            
            
    ) # End Fossil Fuel Phaseout tabItem
    ) 
    ) # End Dashboard Body

# combine all into dashboardPage ----
dashboardPage(header, sidebar, body)

