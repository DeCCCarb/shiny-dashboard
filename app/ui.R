# Dashboard header ----
header <- dashboardHeader(title = 'Labor Impacts of Decarbonization', # Tentative title
                          titleWidth = 800,
                          
                          # Add tutorial button to the header
                          tags$li(
                              class = "dropdown",
                              style = "margin-top: 10px; margin-right: 10px;",
                              actionButton("show_osw_tutorial", label = NULL, icon = icon("question-circle"),
                                           class = "btn btn-default", style = "color: #007BFF;")
                          ))
# Dashboard sidebar ----
sidebar <- dashboardSidebar(
    collapsed = FALSE,
###### initialize tab names ######
    sidebarMenu(
        id = "tabs",
        menuItem(
            text = 'Project Overview',
            tabName = 'overview',
            icon = icon('star')
        ),
        menuItem(
            text = 'Floating Offshore Wind',
            tabName = 'f_osw',
            icon = icon('docker')
        ),
        menuItem(
            text = 'Utility Solar',
            tabName = 'utility',
            icon = icon('solar-panel')
        ),
        # change icons for all
        menuItem(
            text = 'Rooftop Solar',
            tabName = 'rooftop',
            icon = icon('house')
        ),
        menuItem(
            text = 'Land Based Wind',
            tabName = 'lb_wind',
            icon = icon('gauge')
        ),
        menuItem(
            text = 'Oil Well Capping',
            tabName = 'well_cap',
            icon = icon('oil-well')
        ),
        menuItem(
            text = 'Fossil Fuel Phaseout',
            tabName = 'phaseout',
            icon = icon('wrench')
        ),
        menuItem(
            text = 'Tool Documentation',
            tabName = 'documentation',
            icon = icon('cog')
        )
        
        
    ) #  END sidebar Menu
    
)

# Dashboard body ----
body <- dashboardBody( introjsUI(),
                       #### set theme ####
                      use_theme('dashboard-fresh-theme.css'), 
                      tags$head(
                          tags$script(HTML("
      $(document).on('shiny:connected', function() {
        $('[title]').tooltip({ placement: 'right' });
      });
      
      // Update Sidebar Width
   //   $(document).ready(function() {
//        var newWidth = '200px';
//        $('.main-sidebar').css('width', newWidth);
//        $('.content-wrapper').css('margin-left', newWidth);
//        $('.main-footer').css('margin-left', newWidth);
//      });
    "))
                      ), # HTML Hover tip
                      tabItems(
# PROJECT OVERVIEW TAB ITEM ----
                          tabItem(tabName = 'overview', ##### left hand column  #####
                                  column(
                                      width = 6,
                                      ###### background info box  ######
                                      box(
                                          width = NULL,
                                          title = tagList(icon('solar-panel')),
                                          
                                          # use columns to create white space on sides
                                          #column(1),
                                          column(12, includeMarkdown("text/intro.md")),
                                          
                                      ) # END background info box)
                                  ), # END left hand column),
                                  ##### right hand column  #####
                                  column(width = 6, ###### First fluidRow (citation box) ######
                                         fluidRow(
                                             box(
                                                 width = NULL,
                                                 
                                                 title = tagList(icon('sourcetree'), tags$strong('Economic Modeling Tools')),
                                                 column(1),
                                                 column(10, includeMarkdown('text/citation.md')),
                                                 column(1)
                                                 
                                             ) # END citation box
                                         ), # END first fluidRow
                                         
                                         # Create another fluidRow
                                         fluidRow( ###### Second fluidRow (disclaimer box) ######
                                             box(
                                                 width = NULL, 
                                                 title = tagList(icon('user'), tags$strong('Our Partners')),
                                                 column(1),
                                                 column(10, includeMarkdown('text/disclaimer.md')),
                                                 column(1)
                                                 
                                             ) # END disclaimer box
                                         ), # END 2nd fluidRow
                                        # Begin third fluidRow with counties map
                                         fluidRow(
                                           #  Add Box for TMap
                                             box(
                                                 width = NULL,
                                                 tags$img(
                                                     src = "california_counties_map1.png",
                                                     alt = 'Map of California with SLO, Santa Barbara, and Ventura Counties highlighted',
                                                     style = 'max-width: 100%',
                                                     height = '500px',
                                                     width = '500px',
                                                     tags$h6('Made using TMap', tags$a(href = 'Made using TMap and USData.'))
                                                 ) # End tags$img
                                             ) # End CCC TMap box)
                                         )# End FluidRow
                                  )
                          ),
                          
                          # END right hand column)),
                          # END Project Overview tabItem
                          
                          
                          
# FLOATING OFFSHORE WIND TAB ----
                          
                          tabItem(
                              
                              tabName = 'f_osw',

                              fluidRow( ##### First fluidRow (picker inputs) #####
                                  
                                   box(
                                      width = 4,
                                      
                                      title = tags$strong('Floating Offshore Wind Development'),
                                      
                                      
                                      shinyjs::useShinyjs(),
                                      
                                      # Enable shinyjs
                                      ###### year range slider input ######
                                      sliderInput(
                                          inputId = 'year_range_input',
                                          label = tags$span(
                                              "Year Construction Starts - Year to Meet Target", 
                                              tags$i(
                                                  class = "glyphicon glyphicon-info-sign", 
                                                  style = "color:#0072B2;",
                                                  title = "Note: OSW construction requires on average 5 years. Time to reach capacity goals must be greater than 5 years."
                                              )
                                          ), 
                                          min = 2025, 
                                          max = 2045, 
                                          value = c(2025, 2045),
                                          step = 1, 
                                          ticks = F,
                                          sep = ""
                                          
                                      ),
                                      
                                      tags$script(
                                          HTML("
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
                                                                   "
                                          )
                                      ),  ###### job type input  ######
                                      pickerInput(
                                          inputId = 'job_type_input',
                                          label =
                                              tags$span(
                                                  'Direct, Indirect, or Induced Job Impacts', 
                                                  tags$i(
                                                      class = "glyphicon glyphicon-info-sign", 
                                                      style = "color:#0072B2;",
                                                      title = "Direct: Jobs on-site (e.g. welders, technicians). Indirect: Supply chain jobs (e.g. steel makers). Induced: Local jobs from worker spending (e.g. retail, healthcare).")), 
                                          choices = c('direct', # Change to capital
                                                      'indirect', 'induced'),
                                          multiple = FALSE,
                                          options = pickerOptions(actionsBox = TRUE)
                                      ), 
                                      ###### initial capacity input  ######
                                      numericInput(
                                          inputId = 'initial_capacity_input',
                                          label =
                                              tags$span(
                                                  'Capacity (GW) of Initial Construction Project', 
                                                  tags$i(
                                                      class = "glyphicon glyphicon-info-sign", 
                                                      style = "color:#0072B2;",
                                                      title = "Capacity (GW) for initial construction project, to go online 5 years following start year.")
                                              ),
                                          value = 0.1,
                                          min = 0
                                      ), 
                                      ###### final capacity input  ######
                                      numericInput(
                                          inputId = 'final_capacity_input',
                                          label =
                                              tags$span(
                                                  'Target Capacity (GW)', 
                                                  tags$i(
                                                      class = "glyphicon glyphicon-info-sign", 
                                                      style = "color:#0072B2;",
                                                      title = "Default values are based on the California Energy Commission’s 25 GW statewide target by 2045, with 60% assumed in the Tri-Counties, setting a regional goal of 15 GW.")
                                              ),
                                          value = 15,
                                          min = 0
                                      ), 
                                      ###### port input  ######
                                      pickerInput(
                                          inputId = 'osw_port_input',
                                          label =
                                              tags$span(
                                                  'Offshore Wind Port Location:', 
                                                  tags$i(
                                                      class = "glyphicon glyphicon-info-sign", 
                                                      style = "color:#0072B2;",
                                                      title = "Majority of jobs will occur near the specialized wind port. Due to a lack of county specific targets and assuming transferable labor impacts among counties, the three counties are treated as a single region in this analysis. ")
                                              ),
                                          choices = c('Hueneme', 'San Luis Obispo', 'No Central Coast Port'),
                                          selected = NULL,
                                          multiple = FALSE,
                                          options = pickerOptions(actionsBox = TRUE)
                                      ), downloadButton('export_osw', label = 'Export as PDF'),
                                      
                                      id = "osw_inputs_box"  # for tutorial
                                  ), # END input box
                                  
                                  ###### map output  ######
                                  box(
                                     # actionButton("show_osw_tutorial", "Show Tutorial", icon = icon("question-circle")),
                                      
                                      width = 8,
                                      
                                      leafletOutput(outputId = 'osw_map_output') |>
                                          withSpinner(type = 1, color = '#09847A'),
                                      id = "osw_map_box"  # for tutorial
                                  ), # END leaflet box
                                  
                              ), # END  1st fluidRow
                              
                              
                              fluidRow( ##### Second fluidRow (plotly outputs) #####
                                  
                                  box( ###### jobs projections plot ######
                                      width = 7,
                                      # Create a plot based on input
                                      #  title = tags$strong('Labor Impact'),
                                      plotly::plotlyOutput(outputId = 'model_jobs_output') |> # Changed to table output to show data
                                          withSpinner(type = 1, color = '#09847A'),
                                      id = "osw_jobs_plot_box" # for tutorial
                                  ), 
                                  
                                  box( ###### capacity projections plot ######
                                      width = 5,
                                      plotly::plotlyOutput(outputId = 'osw_cap_projections_output') |>
                                          withSpinner(type = 1, color = '#09847A'),
                                      id = "osw_capacity_plot_box" # for tutorial
                                  )
                                  
                                  
                              ) # END 2nd fluidRow),
                              
                          ), # END floating offshore wind tabITEM
                          
# UTILITY SOLAR TAB ----
                          tabItem(
                              
                              tabName = 'utility',
                              
                              fluidRow( ##### First fluidRow (picker inputs) #####
                                  
                                  box( ###### county input ######
                                      width = 4, title = tags$strong('Pick a County'), 
                                      
                                      sliderInput( ###### year range slider input ######
                                          inputId = 'year_range_input_utility',
                                          label = 'Year Range (CHOOSE BETTER LABEL)',
                                          min = 2025,
                                          max = 2045,
                                          value = c(2025, 2045),
                                          step = 1,
                                          ticks = TRUE,
                                          sep = ""
                                      ), 
                                      pickerInput( ###### county input ######
                                          inputId = 'county_input',
                                          label = 'Select a County:',
                                          choices = unique(counties$County),
                                          selected = c('Ventura'),
                                          multiple = FALSE,
                                          options = pickerOptions(actionsBox = TRUE)
                                      ), 

                                      pickerInput( ###### job type input ######
                                          inputId = 'utility_job_type_input',
                                          label = 'Select Direct, Induced, or Indirect',
                                          choices = c('direct', 'induced', 'indirect'),
                                          multiple = FALSE,
                                          options = pickerOptions(actionsBox = TRUE)
                                      ), 

                                      numericInput( ###### initial capacity input  ######
                                          inputId = 'initial_mw_utility_input',
                                          label = 'Please input your initial capacity (MW).',
                                          value = 0,
                                          # placeholder — will be updated
                                          min = 0
                                      ), 
                                      
                                      numericInput( ###### final capacity input  ######
                                          inputId = 'final_mw_utility_input',
                                          label = 'Please input your final capacity (MW).',
                                          value = 0,
                                          min = 0
                                      ),
                                      
                                      id = "util_inputs_box"
                                  ), # END input box
                                  
                                  box( ###### map output  ######
                                      width = 6,
                                      
                                      # title
                                      title = tags$strong('California Central Coast Counties'),
                                      
                                      leafletOutput(outputId = 'utility_map_output') |>
                                          withSpinner(type = 1, color = '#09847A'),
                                      
                                      id = "util_map_box"  # for tutorial
                                      
                                  ), 
                                  
                                  # END leaflet box
                                  
                              ),
                              
                              fluidRow( ##### Second fluidRow (plotly outputs) #####
                                  
                                  box( ###### Utility Job Plot ######
                                      width = 7,
                                      title = tags$strong('Utility Solar Job Impacts'),
                                      plotly::plotlyOutput(outputId = 'utility_jobs_output') |> 
                                          withSpinner(type = 1, color = '#09847A'),
                                      id = "util_jobs_plot_box"  # for tutorial
                                  ), # End util job Box
                                  
                                  box(###### utility capacity plot ######
                                       width = 5,
                                       plotly::plotlyOutput(outputId = 'utility_cap_projections_output') |>
                                           withSpinner(type = 1, color = '#09847A'),
                                      id = "util_capacity_plot_box"  # for tutorial
                                  )
                                  
                                  
                              ) # END  2nd fluidRow
                              
                          ),    # End Utility Solar tabItem
                          
# ROOFTOP SOLAR TAB ----                          
                          tabItem(
                              tabName = 'rooftop',
                              
                              fluidRow( ##### First fluidRow (picker inputs) #####

                                  box(
                                      width = 4,
                                      title = tags$strong('Rooftop Solar Job Impacts'),
                                      
                                      sliderInput( ###### year range slider input ######
                                          inputId = 'year_range_input_roof',
                                          label = 'Year Construction Starts - Year to Meet Target',
                                          min = 2025,
                                          max = 2045,
                                          value = c(2025, 2045),
                                          step = 1,
                                          ticks = TRUE,
                                          sep = ""
                                      ),
                                      pickerInput( ###### county input ######
                                          inputId = 'roof_counties_input',
                                          label = 'Select Your County:',
                                          choices = unique(counties$County),
                                          selected = c('Ventura'),
                                          multiple = FALSE,
                                          options = pickerOptions(actionsBox = TRUE)
                                      ),

                                      pickerInput( ###### job type input ######
                                          inputId = 'roof_job_type_input',
                                          label = 'Select Direct, Induced, or Indirect',
                                          choices = c('direct', 'induced', 'indirect'),
                                          multiple = FALSE,
                                          options = pickerOptions(actionsBox = TRUE)
                                      ),
                                      
                                      numericInput( ###### initial capacity input ######
                                          inputId = 'initial_mw_roof_input',
                                          label = 'Please input your initial capacity (MW).',
                                          value = 0,
                                          # placeholder — will be updated
                                          min = 0
                                      ),

                                      numericInput( ###### final capacity input ######
                                          inputId = 'final_mw_roof_input',
                                          label = 'Please input your final capacity (MW).',
                                          value = 0,
                                          min = 0
                                      ),
                                      downloadButton('export_roof'),
                                      
                                      id = "roof_inputs_box"  # for tutorial
                                  ), 
                                  
                                  # END input box
                                  
                                  
                                 box( ###### map output ######
                                      
                                      width = 7,
                                      
                                      # title
                                      title = tags$strong('California Central Coast Counties'), # Leaflet rendering from server
                                      leafletOutput(outputId = 'roof_map_output') |>
                                          withSpinner(type = 1, color = '#09847A'),
                                      
                                      id = "roof_map_box"  # for tutorial
                                      
                                  ) # END leaflet box
                                  
                              ), # End first fluidRow  
                              
                              fluidRow( ##### Second fluidRow (outputs) #####
                                   
                                  box( ###### Rooftop plotly output #####
                                      width = 7,
                                      # Create a table based on input
                                      title = tags$strong('Rooftop Solar Job Impacts'),
                                      plotlyOutput(outputId = 'roof_jobs_output') |> # Changed to table output to show data
                                          withSpinner(type = 1, color = '#09847A'),
                                      id = "roof_job_plot_box"  # for tutorial
                                  ), 
                                      box( ###### capacity projections plot ######
                                           width = 5,
                                           plotly::plotlyOutput(outputId = 'roof_cap_projections_output') |>
                                               withSpinner(type = 1, color = '#09847A'),
                                           id = "roof_capacity_plot_box"  # for tutorial
                                      )
                                 # )
                              ) # END  2nd fluidRow)
                              
                          ),  # End Rooftop Solar tabItem
                          
# LAND WIND TAB ----
                          tabItem(
                              
                              tabName = 'lb_wind',
                              
                              
                              fluidRow( ##### First fluidRow (picker inputs) #####
                                  
                                  box(
                                      
                                      width = 4,
                                      
                                      title = tags$strong('Land Based Wind Development'),
                                      
                                      
                                      sliderInput( ###### year range slider input ######
                                          inputId = 'input_lw_years',
                                          label = tags$span('Start Year - Year to Meet Target',
                                                            tags$i(
                                                                class = "glyphicon glyphicon-info-sign", 
                                                                style = "color:#0072B2;",
                                                                title = "Input the range of years for analysis, starting with the year associated with inital capacity and ending with the year to meet capacity targets."
                                                            )),
                                          min = 2025,
                                          max = 2045,
                                          value = c(2025, 2045),
                                          step = 1,
                                          ticks = FALSE,
                                          dragRange = TRUE,
                                          sep = ''
                                      ), 

                                      verbatimTextOutput("input_lw_years"), 
                                      
                                      pickerInput( ###### county input ######
                                          inputId = 'lw_counties_input',
                                          label = tags$span('County',
                                                            tags$i(
                                                                class = "glyphicon glyphicon-info-sign", 
                                                                style = "color:#0072B2;",
                                                                title = "County that land wind project will be based. Currently, Santa Barbara County is the only Tri-county with land wind (Strauss Wind Project)."
                                                            )),
                                          choices = unique(counties$County),
                                          selected = c('Santa Barbara'),
                                          multiple = FALSE,
                                          options = pickerOptions(actionsBox = TRUE)
                                      ), 
                                      pickerInput( ###### job type input ######
                                          inputId = 'lw_job_type_input',
                                          label = tags$span('Direct, Indirect, or Induced Job Impacts',
                                                            tags$i(
                                                                class = "glyphicon glyphicon-info-sign",
                                                                style = "color:#0072B2;",
                                                                title = "Direct: Jobs on-site (e.g. welders, technicians). Indirect: Supply chain jobs (e.g. steel makers). Induced: Local jobs from worker spending (e.g. retail, healthcare)."
                                                            )),
                                          choices = c('direct', 'indirect', 'induced'),
                                          multiple = FALSE,
                                          options = pickerOptions(actionsBox = TRUE)
                                      ),
                                      
                                      numericInput( ###### initial capacity input ######
                                          inputId = 'initial_gw_lw_input',
                                          label = tags$span('Initial Capacity (GW)',
                                                            tags$i(
                                                                class = "glyphicon glyphicon-info-sign",
                                                                style = "color:#0072B2;",
                                                                title = "Existing land wind capacity (GW) in selected county. If no existing wind farms, enter size (capacity) of initial construction project. Default 0.95 GW is 2025 nameplate capacity of Strauss Wind Farm in Santa Barbara County."
                                                            )),
                                          value = 0.95,  # Nameplate capacity (GW) of Strauss Wind Farm
                                          min = 0
                                      ), 
                                      
                                      numericInput( ###### final capacity input ######
                                          inputId = 'final_gw_land_input',
                                          label = tags$span('Target Capacity (GW)',
                                                            tags$i(
                                                                class = "glyphicon glyphicon-info-sign",
                                                                style = "color:#0072B2;",
                                                                title = "Capacity (GW) to come online in year specified to meet targets above. Default matches current capacity in Santa Barbara County, as no county goals for land wind expansion are currently defined."
                                                            )),
                                          value = 0.95,
                                          min = 0
                                      ),
                                      
                                      id = "lw_inputs_box"  # for tutorial
                                  ),  # End input box
                                  
                                  box( ###### map output ######
                                      width = 8,
                                      
                                      leafletOutput(outputId = 'land_wind_map_output') |>
                                          withSpinner(type = 1, color = '#09847A'),
                                     
                                       id = "lw_map_box"  # for tutorial
                                      
                                      
                                  ),  # END leaflet box
                                  
                              ), # End fluid Row
                              
                              fluidRow( ##### Second fluid row (plotly outputs) #####

                                  box( ###### job projections plot ######
                                      width = 7,
                                      # Create a plot based on input
                                      #  title = tags$strong('Labor Impact'),
                                      plotly::plotlyOutput(outputId = 'land_wind_jobs_plot_output') |> # Changed to table output to show data
                                          withSpinner(type = 1, color = '#09847A'),
                                      
                                      id = "lw_jobs_plot_box"  # for tutorial
                                  ), 
                                  
                                  box( ###### capacity projections plot ######
                                      width = 5,
                                      plotly::plotlyOutput(outputId = 'lw_cap_projections_output') |>
                                          withSpinner(type = 1, color = '#09847A'),
                                      id = "lw_capacity_plot_box"  # for tutorial
                                  )
                                  
                                  
                                  
                              ) # End 2nd fluidRow
                          ), # End Land Based Wind tabItem
                          
# OIL WELL CAPPING TAB ----
                          tabItem(tabName = 'well_cap', 
                                  
                                  ##### left hand column #####
                                  column(width = 4,
                                        # fluidRow( ##### top left fluid row #####
                                                   
                                                   box(width = 12,

                                                       title = 'Capping Existing Onshore Oil Wells', 

                                                       
                                                       pickerInput( ###### county input ######
                                                                    
                                                                    inputId = 'county_wells_input',
                                                                    label = "County",
                                                                    choices = c('San Luis Obispo', 'Ventura', 'Santa Barbara'), 
                                                                    multiple = FALSE
                                                       ) # End county picker
                                                       
                                                   ) # End box for inputs?) 
                                      #   ) # End top left fluidRow
                                         ), # END left hand column
                                  
                                  ##### right hand column #####
                                  column(width = 8,
                                     #    fluidRow( ##### top right fluid row #####
                                                   
                                                   box( ###### map output ######
                                                        width = 12,
                                                        leafletOutput(outputId = 'capping_map_output',
                                                                      height = "800px") |>
                                                            withSpinner(type = 1, color = '#09847A')
                                                        
                                                        
                                                   ),  # END leaflet box
                                      #   ) # End top right fluidRow
                                         ) # END right hand column
                                  
                                  
                          ), # end well capping tab item
                          
# FOSSIL FUEL PHASEOUT TAB ----
                          tabItem(tabName = 'phaseout', 
                                  
                                  fluidRow(  ##### First fluid row (picker inputs) #####
                                      
                                      box( 
                                          width = 6, title = tags$strong('Pick a County'), 
                                          
                                           pickerInput( ###### county input ######
                                              inputId = 'phaseout_counties_input',
                                              label = 'Select a County',
                                              choices = c('Santa Barbara', 'San Luis Obispo', 'Ventura'),
                                              selected = c('Ventura'),
                                              multiple = FALSE,
                                              options = pickerOptions(actionsBox = TRUE
                                              )
                                              
                                          ),
                                          
                                          pickerInput( ###### setback distance input ######
                                              inputId = 'phaseout_setback_input',
                                              label = tags$span(
                                                  'Select Setback Policy Distance', 
                                                  tags$i(
                                                      class = "glyphicon glyphicon-info-sign", 
                                                      style = "color:#0072B2;",
                                                      title = "The current California state setback policy is 3200 feet.")
                                              ),
                                              choices = c(
                                                  '1000 ft' = 'setback_1000ft',
                                                  '2500 ft' = 'setback_2500ft',
                                                  '3200 ft' = 'setback_3200ft',
                                                  '5280 ft' = 'setback_5280ft',
                                                  'No setback' = 'no_setback'
                                              ),
                                              selected = c('setback_3200ft'),
                                              multiple = FALSE,
                                              options = pickerOptions(actionsBox = TRUE
                                              )
                                              
                                          ),
                                          
                                          pickerInput( ###### setback existing input ######
                                              inputId = 'phaseout_setback_existing_input',
                                              label = tags$span(
                                                  'Should the setback policy apply to existing wells?', 
                                                  tags$i(
                                                      class = "glyphicon glyphicon-info-sign", 
                                                      style = "color:#0072B2;",
                                                      title = "If the setback policy only applies to new wells, it is unlikely that progress will be made at the rate that we need.")
                                              ),
                                              choices = c(
                                                  'Setback policy applies to new and existing wells' = 0,
                                                  'Setback policy applies only to new wells' = 1
                                              ),
                                              selected = 0,
                                              multiple = FALSE,
                                              options = pickerOptions(actionsBox = TRUE)
                                          )
                                      ), # END input box
                                      
                                       box( ###### map output ######
                                          
                                          width = 6, # title
                                          title = tags$strong('California Central Coast Counties'), # Leaflet rendering from server
                                          leafletOutput(outputId = 'phaseout_county_map_output') |>
                                              withSpinner(type = 1, color = '#09847A')
                                          
                                      ) # END leaflet box
                                      
                                  ), # END  1st fluidRow
                                  
                                  
                                  fluidRow( ##### Second fluid row (plotly outputs) #####
                                           box( ###### Phaseout plot ######
                                               width = 12,
                                               # Create a table based on input
                                               title = tags$strong('Labor Impact'),
                                               plotly::plotlyOutput(outputId = 'phaseout_plot') |> # Changed to table output to show data
                                                   withSpinner(type = 1, color = '#09847A')
                                           ) # END plot box
                                           
                                  ) # END 2nd fluid row)    
                                  
                          ) # End Fossil Fuel Phaseout tabItem
                      ) # End all tab items ----
                      
) # End dashboard body


# combine all into dashboardPage ----

dashboardPage(header, sidebar, body)
