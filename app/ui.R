
# Dashboard header ----
header <- dashboardHeader(
    
    # title ----
    title = 'Labor Impacts of Decarbonization',
    titleWidth = 800
    
    
)

# dashboard sidebar ---
sidebar <- dashboardSidebar(
    
    # sidebarMenu ---
    sidebarMenu(
        menuItem(text = 'Project Overview', tabName = 'overview', icon = icon('star')),
        menuItem(text = 'Floating Offshore Wind', tabName = 'f_osw', icon = icon('gauge')),
        menuItem(text = 'Utility Solar', tabName = 'utility', icon = icon('gauge')),
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
        
        
        # Tool/Dashboard tabItem for floating offshore wind
        tabItem(tabName = 'f_osw',
                
                # Create a fluidRow ---
                fluidRow(
                    
                    # input box ----
                    box(width = 4,
                        title = tags$strong('Pick a County'),
                        
                        # pickerInputs ----
                        
                        # Enter Numeric Input for start year
                        numericInput(inputId = 'start_yr_input',
                                     label = 'Year that construction starts:',
                                     value = 2025,
                                     min = 2025),
                        # Enter Numeric Input for start year
                        numericInput(inputId = 'end_yr_input',
                                     label = 'End year to meet targets:',
                                     value = 2045,
                                     min = 2025),
                        pickerInput(inputId = 'county_input',
                                    label = 'Select a County:',
                                    choices = unique(counties$County),
                                    selected = c('Ventura'),
                                    multiple = FALSE,
                                    options = pickerOptions(actionsBox = TRUE)),
                        # Select technology input ----
                        pickerInput(inputId = 'technology_input',
                                    label = 'Select Technology',
                                    choices = c('Floating Offshore Wind', 
                                                'Rooftop PV',
                                                'Utility PV',
                                                'Onshore Wind',
                                                'Oil Wells - Capping'),
                                    multiple = FALSE,
                                    options = pickerOptions(actionsBox = TRUE)),
                        # Select job type input ----
                        pickerInput(inputId = 'job_type_input',
                                    label = 'Select Direct, Induced, or Indirect',
                                    choices = c('direct', 
                                                'induced',
                                                'indirect'),
                                    multiple = FALSE,
                                    options = pickerOptions(actionsBox = TRUE)),
                        # Enter Numeric Input for initial capacity -----
                        numericInput(inputId = 'initial_capacity_input',
                                  label = 'Please input your initial GW capacity.',
                                  value = 0.1,
                                  min = 0),
                        # Enter Numeric Input for final capacity -----
                        numericInput(inputId = 'final_capacity_input',
                                     label = 'Please input your final GW capacity.',
                                     value = 15,
                                     min = 0), 
                        # Select Port/No Port
                        pickerInput(inputId = 'port_input',
                                    label = 'Offshore Wind Port Location:',
                                    choices = c('Hueneme', 'Morro Bay'),
                                    selected = c('Hueneme', 'Morro Bay'),
                                    multiple = TRUE,
                                    options = pickerOptions(actionBox = TRUE))

                    ), # END input box
                    
                    #leaflet box ----
                    box(width = 6,
                        
                        # title 
                        title = tags$strong('California Central Coast Counties'),
                        
                        leafletOutput(outputId = 'county_map_output') |> 
                            withSpinner(type = 1, color = 'forestgreen')
                        
                        
                        
                    ), # END leaflet box
                    
                    # model jobs box ----
                    # box(width = 8,
                    #     # Plot outputs based on selection
                    #     title = tags$strong('Labor Impact'),
                    #     plotOutput(outputId = 'model_jobs_output') |> # Changed to table output to show data
                    #         withSpinner(type = 1, color = 'forestgreen')
                    # ), # model jobs box end 
                    # Projections table box -----
                    box(width = 12,
                        # Create a table based on input
                        title = tags$strong('Labor Impact'),
                        tableOutput(outputId = 'model_jobs_output') |> # Changed to table output to show data
                            withSpinner(type = 1, color = 'forestgreen'))
                    
                )# END  1st fluidRow 
                
        ), # END floating offshore wind tabITEM
        tabItem(tabName = 'utility',
            # Create a fluidRow ---
            fluidRow(
                
                # input box ----
                box(width = 4,
                    title = tags$strong('Pick a County'),
                    
                    # pickerInputs ----
                    
                    # Enter Numeric Input for start year
                    numericInput(inputId = 'start_yr_utility_input',
                                 label = 'Year that construction starts:',
                                 value = 2025,
                                 min = 2025),
                    # Enter Numeric Input for start year
                     numericInput(inputId = 'end_yr_utility_input',
                                 label = 'End year to meet targets:',
                                 value = 2045,
                                 min = 2025),
                    pickerInput(inputId = 'county_input',
                                label = 'Select a County:',
                                choices = unique(counties$County),
                                selected = c('Ventura'),
                                multiple = FALSE,
                                options = pickerOptions(actionsBox = TRUE)),
                    # Select technology input ----
                    # pickerInput(inputId = 'utility_input',
                    #             label = 'Select Technology',
                    #             choices = c('Floating Offshore Wind', 
                    #                         'Rooftop PV',
                    #                         'Utility PV',
                    #                         'Onshore Wind',
                    #                         'Oil Wells - Capping'),
                    #             multiple = FALSE,
                    #             options = pickerOptions(actionsBox = TRUE)),
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
                                 label = 'Please input your initial MW capacity.',
                                 value = 0,  # placeholder — will be updated
                                 min = 0),
                    # Enter Numeric Input for final capacity -----
                    numericInput(inputId = 'final_mw_utility_input',
                                 label = 'Please input your final MW capacity.',
                                 value = 0,
                                 min = 0), 
                    # Select Port/No Port
                    pickerInput(inputId = 'port_input',
                                label = 'Offshore Wind Port Location:',
                                choices = c('Hueneme', 'Morro Bay'),
                                selected = c('Hueneme', 'Morro Bay'),
                                multiple = TRUE,
                                options = pickerOptions(actionBox = TRUE))
                    
                ), # END input box
                
                #leaflet box ----
                box(width = 6,
                    
                    # title 
                    title = tags$strong('California Central Coast Counties'),
                    
                    leafletOutput(outputId = 'county_map_output') |> 
                        withSpinner(type = 1, color = 'forestgreen')
                    
                    
                    
                ), # END leaflet box
                
                # model jobs box ----
                # box(width = 8,
                #     # Plot outputs based on selection
                #     title = tags$strong('Labor Impact'),
                #     plotOutput(outputId = 'model_jobs_output') |> # Changed to table output to show data
                #         withSpinner(type = 1, color = 'forestgreen')
                # ), # model jobs box end 
                # Projections table box -----
                box(width = 12,
                    # Create a table based on input
                    title = tags$strong('Utility Solar Job Impacts'),
                    tableOutput(outputId = 'utility_jobs_output') |> # Changed to table output to show data
                        withSpinner(type = 1, color = 'forestgreen'))
                
            )# END  2nd fluidRow)
        
    ) # End tabItems
    
))

# combine all into dashboardPage ----
dashboardPage(header, sidebar, body)