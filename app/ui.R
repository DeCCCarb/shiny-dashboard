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
        menuItem(text = 'Workforce Tool', tabName = 'dashboard', icon = icon('gauge')),
        menuItem(text = 'Ensuring A Just Transition', tabName = 'equity', icon = icon('gauge')),
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
        
        
        # Tool/Dashboard tabItem
        tabItem(tabName = 'dashboard',
                
                # Create a fluidRow ---
                fluidRow(
                    
                    # input box ----
                    box(width = 4,
                        title = tags$strong('Pick a County'),
                        
                        # pickerInputs ----
                        pickerInput(inputId = 'county_input',
                                    label = 'Select your County',
                                    choices = unique(counties$County),
                                    selected = c('Ventura'),
                                    multiple = TRUE,
                                    options = pickerOptions(actionsBox = TRUE)),
                        # Select technology input ----
                        pickerInput(inputId = 'technology_input',
                                    label = 'Select Technology',
                                    choices = c('Floating Offshore Wind', 
                                                'Onshore Wind',
                                                'PV Solar - Residential',
                                                'PV Solar - Commercial',
                                                'Utility PV',
                                                'Oil Wells - Capping',
                                                'Oil Wells - Phase Out'),
                                    multiple = TRUE,
                                    options = pickerOptions(actionsBox = TRUE)),
                        # Select Ambition Scenario ---
                        checkboxGroupButtons(inputId = 'ambition_input',
                                        label = 'Select Ambition Scenario',
                                        choices = c('Low', 'High'),
                                        selected = c('High'),
                                        justified = TRUE)

                        
                    ), # END input box
                    
                    #leaflet box ----
                    box(width = 6,
                        
                        # title 
                        title = tags$strong('California Central Coast Counties'),
                        
                        leafletOutput(outputId = 'county_map_output') |> 
                            withSpinner(type = 1, color = 'forestgreen')
                        
                        
                        
                    ), # END leaflet box
                    
                    # model jobs box ----
                    box(width = 8,
                        # Plot outputs based on selection
                        title = tags$strong('Labor Impact'),
                        plotOutput(outputId = 'model_jobs_output') |>
                            withSpinner(type = 1, color = 'forestgreen')
                    ) # model jobs box end 
                    
                )# END  1st fluidRow 
                
        ) # END dashboard tabITEM
        
    ) # End tabItems
    
)

# combine all into dashboardPage ----
dashboardPage(header, sidebar, body)