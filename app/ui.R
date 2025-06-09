# Dashboard header ----
header <- dashboardHeader(title = htmlOutput("dynamic_header_title"),
                          titleWidth = 400,
                          
                          # Community Labor logo
                          tags$li(
                              class = "dropdown",
                              tags$a(
                                  href = "https://laborcenter.ucsb.edu", target = "_blank",
                                  tags$img(src = "communitylabor-logo.png", height = "30px")),
                              style = "padding: 0 px; display: flex; align-items: center;"
                          ),
                          
                          # 2035 logo
                          tags$li(
                              class = "dropdown",
                              tags$a(
                                  href = "https://www.2035initiative.com", target = "_blank",
                                  tags$img(src = "the2035initiative-logo.png", height = "30px")),
                              style = "padding: 0 px; margin: 0; display: flex; align-items: center;"
                          ),
                          
                          # Add tutorial button to the header
                          tags$li(
                              class = "dropdown",
                              style = "margin-top: 10px; margin-right: 10px;",
                              actionButton("show_tutorial", label = NULL, icon = icon("question-circle"),
                                           class = "btn btn-default",
                                           #style = "color: #007BFF;"
                              ),
                              id = "tutorial_button"
                          ),
                          
                          # PDF Export Button (UI placeholder; real one comes from renderUI)
                          tags$li(
                              class = "dropdown",
                              style = "margin-top: 10px; margin-right: 10px;",
                              uiOutput("export_pdf_button"),
                              
                              id = "pdf_button"
                          ))

# Dashboard sidebar ----
sidebar <- dashboardSidebar(
    collapsed = FALSE,
    ###### initialize tab names ######
    sidebarMenu(
        id = "tabs",
        menuItem(
            text = 'Welcome',
            tabName = 'welcome',
            icon = icon('star')
        ),
        menuItem(
            text = 'Project Overview',
            tabName = 'overview',
            icon = icon('diagram-project')
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
        # menuItem(
        #     text = 'Land Based Wind',
        #     tabName = 'lb_wind',
        #     icon = icon('gauge')
        # ),
        menuItem(
            text = 'Oil Well Capping',
            tabName = 'well_cap',
            icon = icon('oil-well')
        ),
        menuItem(
            text = 'Crude Oil Phaseout',
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
                           tags$link(
                               href = "https://fonts.googleapis.com/css2?family=Commissioner:wght@400;500;600;700&display=swap",
                               rel = "stylesheet"
                           ),
                           tags$style(HTML("
  /* Global font settings */
  body, .content-wrapper, .main-sidebar, .main-header {
    font-family: 'Commissioner', sans-serif;
  }

  h1, h2, h3, h4, h5, h6, .box-title, .sidebar-menu li a {
    font-family: 'Commissioner', sans-serif;
  }

  /* Header title & navbar styling */
  .main-header .logo, 
  .main-header .navbar {
    font-family: 'Commissioner', sans-serif !important;
    font-weight: 400;
    font-size: 18px;
    background-color: #DDE1E5 !important;
  }

  /* Ensure text and buttons in header are white */
  .main-header .navbar .navbar-brand,
  .main-header .navbar .dropdown a,
  .main-header .logo {
  }
")),
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
                       
                       # Make a larger popup box style
                       tags$style(HTML("
      .introjs-large {
        max-width: none !important;
      width: 500px !important;
        font-size: 16px;
        line-height: 1.6;
        text-align: center;
      }
      
            .introjs-wider {
        max-width: none !important;
      width: 400px !important;
      }
      
    ")), # END larger popup box styling
                       
                       
                       tabItems(
                           # WELCOME TAB ----
                           tabItem(tabName = 'welcome', 
                                   tags$head(
                                       tags$style(HTML("
      .slick-slide img {
        max-width: 100%;
        max-height: 100%;
        width: auto;
        height: auto;
        display: block;
        margin: auto;
        object-fit: contain;
      }
    "))
                                   ),
                                   # PAGE TITLE
                                   fluidRow(
                                       column(
                                           width = 12,
                                           tags$h1("Welcome to California's Central Coast Energy Jobs Explorer", style = "text-align: center; padding-top: 10px;")
                                       )
                                   ),
                                   
                                   # IMAGE CAROUSEL (full width)
                                   fluidRow(
                                       column(
                                           width = 12,
                                           box(
                                               width = NULL,
                                               title = NULL,
                                               solidHeader = TRUE,
                                               div(
                                                   style = "height: 600px; display: flex; justify-content: center; align-items: center;",
                                                   withSpinner(slickROutput("image_carousel", width = "600px", height = "600px"),
                                                               type = 1, color = '#09847A'
                                                   ))
                                           )
                                       )
                                   ),
                                   # ECONOMIC MODELING TOOLS BOX
                                   fluidRow(
                                       column(
                                           width = 6,
                                           box(
                                               width = NULL,
                                               title = tagList(icon('sourcetree'), tags$strong('Economic Modeling Tools Used')),
                                               column(1),
                                               column(10, includeMarkdown('text/citation.md')),
                                               column(1)
                                           )
                                       ),
                                       column(
                                           width = 6,
                                           box(
                                               width = NULL,
                                               title = tagList(icon('user'), tags$strong('Our Partners')),
                                               column(1),
                                               column(10, includeMarkdown('text/disclaimer.md')),
                                               column(1)
                                           )
                                       )
                                   )
                                   
                           ),
                           
                           # PROJECT OVERVIEW TAB ITEM ----
                           tabItem(
                               tabName = 'overview',
                               
                               
                               # CAPACITY DEFAULT INFO BOX
                               fluidRow(column(
                                   width = 12,
                                   box(
                                       width = NULL,
                                       column(1),
                                       column(10, includeMarkdown('text/capacity-default-info.md')),
                                       column(1)
                                   )
                               ))
                               
                           ),
                           
                           
                           
                           # FLOATING OFFSHORE WIND TAB ----
                           tabItem(
                               tabName = 'f_osw',
                               
                               fluidRow( ##### First fluidRow (buttons, inputs, and map) #####
                                         
                                         # Left column
                                         column(
                                             width = 4,
                                             
                                             # Scenario buttons          
                                             box(
                                                 width = 12,
                                                 title = "Choose a predefined scenario",
                                                 div(style = "display: flex; flex-direction: column; gap: 10px;",
                                                     actionButton("load_scenario1", "Scenario 1 - 15GW by 2045", icon = icon("bolt"), class = "scenario-btn"),
                                                     actionButton("load_scenario2", "Scenario 2 - 6GW by 2045", icon = icon("bolt"), class = "scenario-btn")
                                                 ),
                                                 id = "scenario_buttons_box"
                                             ),
                                             
                                             # Inputs
                                             box(
                                                 width = 12,
                                                 title = "Enter a custom scenario",
                                                 
                                                 shinyjs::useShinyjs(),
                                                 
                                                 sliderInput(
                                                     inputId = 'year_range_input',
                                                     label = tags$span(
                                                         "Year Construction Starts - Year to Meet Target",
                                                         tags$i(
                                                             class = "glyphicon glyphicon-info-sign",
                                                             style = "color:#0072B2;",
                                                             title = "Construction requires, on average, 5 years. Time to reach capacity goals must be greater than 5 years."
                                                         )
                                                     ),
                                                     min = 2025,
                                                     max = 2045,
                                                     value = c(2030, 2045),
                                                     step = 1,
                                                     ticks = FALSE,
                                                     sep = ""
                                                 ),
                                                 
                                                 tags$script(
                                                     HTML("
                        $(document).on('shiny:connected', function() {
                            var minRange = 6;
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
                    ")
                                                 ),
                                                 
                                                 numericInput(
                                                     inputId = 'initial_capacity_input',
                                                     label = tags$span(
                                                         'Capacity (GW) of Initial Construction Project',
                                                         tags$i(
                                                             class = "glyphicon glyphicon-info-sign",
                                                             style = "color:#0072B2;",
                                                             title = "Capacity (GW) for initial construction project, to go online 5 years following start year. Value must not be 0."
                                                         )
                                                     ),
                                                     value = 0.5,
                                                     min = 0
                                                 ),
                                                 
                                                 numericInput(
                                                     inputId = 'final_capacity_input',
                                                     label = tags$span(
                                                         'Target Capacity (GW)',
                                                         tags$i(
                                                             class = "glyphicon glyphicon-info-sign",
                                                             style = "color:#0072B2;",
                                                             title = "Enter total capacity to be up-and-running in the final year."
                                                         )
                                                     ),
                                                     value = 15,
                                                     min = 0
                                                 ),
                                                 
                                                 pickerInput(
                                                     inputId = 'job_type_input',
                                                     label = tags$span(
                                                         'Direct, Indirect, or Induced Jobs',
                                                         tags$i(
                                                             class = "glyphicon glyphicon-info-sign",
                                                             style = "color:#0072B2;",
                                                             title = "Direct: Jobs on-site (e.g. welders, technicians). Indirect: Supply chain jobs (e.g. steel makers). Induced: Local jobs from worker spending (e.g. retail, healthcare). Total: Sum of Direct, Indirect, and Induced jobs."
                                                         )
                                                     ),
                                                     choices = c('Direct', 'Indirect', 'Induced', 'Total'),
                                                     multiple = FALSE,
                                                     options = pickerOptions(actionsBox = TRUE)
                                                 ),
                                                 
                                                 id = "osw_inputs_box"
                                             )
                                         ), # END left column
                                         
                                         # Right column
                                         column(
                                             width = 8,
                                             div(
                                                 style = "height: 100%; min-height: 500px;",
                                                 box(
                                                     width = 12,
                                                     leafletOutput(outputId = 'osw_map_output',
                                                                   height = "500px") |>
                                                         withSpinner(type = 1, color = '#09847A'),
                                                     id = "osw_map_box"
                                                 )
                                             )
                                         ) # END right column
                               ), # END first fluidRow
                               
                               fluidRow( ##### Second fluidRow (plotly outputs) #####
                                         box(
                                             width = 7,
                                             plotly::plotlyOutput(outputId = 'model_jobs_output') |>
                                                 withSpinner(type = 1, color = '#09847A'),
                                             id = "osw_jobs_plot_box"
                                         ),
                                         box(
                                             width = 5,
                                             plotly::plotlyOutput(outputId = 'osw_cap_projections_output') |>
                                                 withSpinner(type = 1, color = '#09847A'),
                                             id = "osw_capacity_plot_box"
                                         )
                               ) # END second fluidRow
                           ), # END tabItem
                           
                           
                           # UTILITY SOLAR TAB ----
                           tabItem(
                               
                               tabName = 'utility',
                               
                               fluidRow( ##### First fluidRow (picker inputs and map) #####
                                         column( # left hand column
                                             width = 4,
                                             box( # county input box
                                                 width = 12,
                                                 title = "Select a County",
                                                 pickerInput( ###### county input ######
                                                              inputId = 'county_input',
                                                              # label = tags$span(
                                                              #     'County',
                                                              #     tags$i(
                                                              #         class = "glyphicon glyphicon-info-sign", 
                                                              #         style = "color:#0072B2;",
                                                              #         title = "Choose a county to analyze."
                                                              #     )),
                                                              choices = c(unique(counties$County)),
                                                              selected = c('Ventura'),
                                                              multiple = FALSE,
                                                              options = pickerOptions(actionsBox = TRUE)
                                                 ),
                                                 id = "util_county_box"
                                             ), # end county input box
                                             
                                             box( # scenario buttons box ----
                                                 width = 12,
                                                 title = tags$span(
                                                                   'Choose a Predefined Scenario',
                                                                   tags$i(
                                                                       class = "glyphicon glyphicon-info-sign", 
                                                                       style = "color:#0072B2; font-size: 14px;",
                                                              title = "Select a scenario. Scenario 1 sets full solar build-out by county to meet 2045 goals; Scenario 2 sets 50%. Values vary by each county’s current capacity."
                                                          )),
                                                 uiOutput("scenario_buttons_ui"),
                                                 id = "util_scenario_buttons_box"
                                             ), # end scenario buttons box
                                             
                                             box( # other inputs box
                                                 width = 12,
                                                 title = "Enter a Custom Scenario",
                                                 sliderInput( ###### year range slider input ######
                                                              inputId = 'year_range_input_utility',
                                                              label = tags$span(
                                                                  'Year Construction Starts - Year To Meet Target',
                                                                  tags$i(
                                                                      class = "glyphicon glyphicon-info-sign", 
                                                                      style = "color:#0072B2;",
                                                                      title = "Input the range of years to project job growth over, starting with the first year of construction and ending with the year to meet target capacity."
                                                                  )),
                                                              min = 2025,
                                                              max = 2045,
                                                              value = c(2025, 2045),
                                                              step = 1,
                                                              ticks = F,
                                                              sep = ""
                                                 ), 
                                                 
                                                 numericInput( ###### initial capacity input  ######
                                                               inputId = 'initial_mw_utility_input',
                                                               label = tags$span(
                                                                   'Current Capacity (MW)',
                                                                   tags$i(
                                                                       class = "glyphicon glyphicon-info-sign", 
                                                                       style = "color:#0072B2;",
                                                                       title = "Currently installed capacity in your county in megawatts. Value must not be 0."
                                                                   )),
                                                               value = 0,
                                                               min = 0
                                                 ), 
                                                 
                                                 numericInput( ###### final capacity input  ######
                                                               inputId = 'final_mw_utility_input',
                                                               label = tags$span(
                                                                   'Target Capacity (MW)',
                                                                   tags$i(
                                                                       class = "glyphicon glyphicon-info-sign", 
                                                                       style = "color:#0072B2;",
                                                                       title = "Target capacity to reach by final input year in megawatts."
                                                                   )),
                                                               value = 0,
                                                               min = 0
                                                 ),
                                                 
                                                 pickerInput( ###### job type input ######
                                                              inputId = 'utility_job_type_input',
                                                              label =
                                                                  tags$span(
                                                                      'Direct, Indirect, or Induced Jobs', 
                                                                      tags$i(
                                                                          class = "glyphicon glyphicon-info-sign", 
                                                                          style = "color:#0072B2;",
                                                                          title = "Direct: Jobs on-site (e.g. welders, technicians). Indirect: Supply chain jobs (e.g. steel makers). Induced: Local jobs from worker spending (e.g. retail, healthcare). Total: Sum of Direct, Indirect, and Induced jobs.")), 
                                                              choices = c('Direct', 'Indirect', 'Induced', 'Total'),
                                                              multiple = FALSE,
                                                              options = pickerOptions(actionsBox = TRUE)
                                                 ), 
                                                 
                                                 id = "util_inputs_box" # for tutorial
                                                 
                                             ) # END input box
                                         ), # end left column
                                         
                                         column(
                                             width = 8,
                                             
                                             box( ###### map output  ######
                                                  width = 12,
                                                  
                                                  leafletOutput(outputId = 'utility_map_output',
                                                                height = "635px") |>
                                                      withSpinner(type = 1, color = '#09847A'),
                                                  
                                                  id = "util_map_box"  # for tutorial
                                                  
                                             )  # END leaflet box
                                         ) # end right column
                                         
                                         
                                         
                                         
                               ),
                               
                               fluidRow( ##### Second fluidRow (plotly outputs) #####
                                         
                                         box( ###### Utility Job Plot ######
                                              width = 7,
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
                               
                               fluidRow( ##### First fluidRow (picker inputs and map) #####
                                         column( # left hand column
                                             width = 4,
                                             
                                             box( # county input box
                                                 width = 12,
                                                 title = "Select a County",
                                                 pickerInput( ###### county input ######
                                                              inputId = 'roof_counties_input',
                                                              choices = unique(counties$County),
                                                              selected = c('Ventura'),
                                                              multiple = FALSE,
                                                              options = pickerOptions(actionsBox = TRUE)
                                                 ),
                                                 id = "roof_county_box"
                                             ), # end county input box
                                             
                                             box( # scenario buttons box ----
                                                  width = 12,
                                                  title = tags$span(
                                                      'Choose a Predefined Scenario',
                                                      tags$i(
                                                          class = "glyphicon glyphicon-info-sign", 
                                                          style = "color:#0072B2; font-size: 14px;",
                                                          title = "Select a scenario. Scenario 1 assumes full solar build-out by county to meet 2045 goals; Scenario 2 assumes 50%. Values vary by each county’s current capacity."
                                                      )),
                                                  uiOutput("roof_scenario_buttons_ui"),
                                                  id = "roof_scenario_buttons_box"
                                             ), # end scenario buttons box
                                             
                                             box( # other inputs box
                                                 width = 12,
                                                 title = "Enter a Custom Scenario",
                                                 
                                                 sliderInput( ###### year range slider input ######
                                                              inputId = 'year_range_input_roof',
                                                              label = tags$span(
                                                                  'Year Construction Starts - Year to Meet Target',
                                                                  tags$i(
                                                                      class = "glyphicon glyphicon-info-sign", 
                                                                      style = "color:#0072B2;",
                                                                      title = "Input the range of years to project job growth over, starting with the first year of construction and ending with the year to meet target capacity."
                                                                  )),
                                                              min = 2025,
                                                              max = 2045,
                                                              value = c(2025, 2045),
                                                              step = 1,
                                                              ticks = F,
                                                              sep = ""
                                                 ),
                                                 
                                                 numericInput( ###### initial capacity input ######
                                                               inputId = 'initial_mw_roof_input',
                                                               label = tags$span('Current Capacity (MW)',
                                                                                 tags$i(
                                                                                     class = "glyphicon glyphicon-info-sign", 
                                                                                     style = "color:#0072B2;",
                                                                                     title = "Currently installed capacity in your county in megawatts. Value must not be 0."
                                                                                 )),
                                                               value = 0,
                                                               min = 0
                                                 ),
                                                 
                                                 numericInput( ###### final capacity input ######
                                                               inputId = 'final_mw_roof_input',
                                                               label = tags$span('Target Capacity (MW)',
                                                                                 tags$i(
                                                                                     class = "glyphicon glyphicon-info-sign", 
                                                                                     style = "color:#0072B2;",
                                                                                     title = "Target capacity to reach by final input year in megawatts."
                                                                                 )),
                                                               value = 0,
                                                               min = 0
                                                 ),
                                                 
                                                 pickerInput( ###### job type input ######
                                                              inputId = 'roof_job_type_input',
                                                              label = tags$span('Direct, Indirect, or Induced Jobs',
                                                                                tags$i(
                                                                                    class = "glyphicon glyphicon-info-sign", 
                                                                                    style = "color:#0072B2;",
                                                                                    title = "Direct: Jobs on-site (e.g. welders, technicians). Indirect: Supply chain jobs (e.g. steel makers). Induced: Local jobs from worker spending (e.g. retail, healthcare). Total: Sum of Direct, Indirect, and Induced jobs."
                                                                                )),
                                                              choices = c('Direct', 'Indirect', 'Induced', 'Total'),
                                                              multiple = FALSE,
                                                              options = pickerOptions(actionsBox = TRUE)
                                                 ),
                                                 
                                                 id = "roof_inputs_box"  # for tutorial
                                             ) # end input box
                                         ), # end left column
                                         
                                         column(
                                             width = 8,
                                             
                                             box( ###### map output ######
                                                  width = 12,
                                                  
                                                  leafletOutput(outputId = 'roof_map_output',
                                                                height = "635px") |>
                                                      withSpinner(type = 1, color = '#09847A'),
                                                  
                                                  id = "roof_map_box"  # for tutorial
                                             ) # END leaflet box
                                         ) # end right column
                               ), # End first fluidRow
                               
                               fluidRow( ##### Second fluidRow (plotly outputs) #####
                                         
                                         box( ###### Rooftop Job Plot ######
                                              width = 7,
                                              plotlyOutput(outputId = 'roof_jobs_output') |> 
                                                  withSpinner(type = 1, color = '#09847A'),
                                              id = "roof_jobs_plot_box"  # for tutorial
                                         ), 
                                         
                                         box( ###### Rooftop capacity plot ######
                                              width = 5,
                                              plotly::plotlyOutput(outputId = 'roof_cap_projections_output') |>
                                                  withSpinner(type = 1, color = '#09847A'),
                                              id = "roof_capacity_plot_box"  # for tutorial
                                         )
                               ) # END 2nd fluidRow
                           ), # End Rooftop Solar tabItem
                           
                           # LAND WIND TAB (REMOVED) ----
                           # tabItem(
                           #     
                           #     tabName = 'lb_wind',
                           #     
                           #     
                           #     fluidRow( ##### First fluidRow (picker inputs) #####
                           #               
                           #               box(
                           #                   
                           #                   width = 4,
                           #                   
                           #                   pickerInput( ###### county input ######
                           #                                inputId = 'lw_counties_input',
                           #                                label = tags$span('County',
                           #                                                  tags$i(
                           #                                                      class = "glyphicon glyphicon-info-sign", 
                           #                                                      style = "color:#0072B2;",
                           #                                                      title = "County that land wind project will be based. Currently, Santa Barbara County is the only Tri-county with land wind (Strauss Wind Project)."
                           #                                                  )),
                           #                                choices = unique(counties$County),
                           #                                selected = c('Santa Barbara'),
                           #                                multiple = FALSE,
                           #                                options = pickerOptions(actionsBox = TRUE)
                           #                   ), 
                           #                   
                           #                   sliderInput( ###### year range slider input ######
                           #                                inputId = 'input_lw_years',
                           #                                label = tags$span('Year Construction Starts - Year to Meet Target',
                           #                                                  tags$i(
                           #                                                      class = "glyphicon glyphicon-info-sign", 
                           #                                                      style = "color:#0072B2;",
                           #                                                      title = "Input the range of years for analysis, starting with the year associated with inital capacity and ending with the year to meet capacity targets."
                           #                                                  )),
                           #                                min = 2025,
                           #                                max = 2045,
                           #                                value = c(2025, 2045),
                           #                                step = 1,
                           #                                ticks = FALSE,
                           #                                dragRange = TRUE,
                           #                                sep = ''
                           #                   ), 
                           #                   
                           #                   verbatimTextOutput("input_lw_years"), 
                           #                   
                           #                   
                           #                   numericInput( ###### initial capacity input ######
                           #                                 inputId = 'initial_gw_lw_input',
                           #                                 label = tags$span('Initial Capacity (GW)',
                           #                                                   tags$i(
                           #                                                       class = "glyphicon glyphicon-info-sign",
                           #                                                       style = "color:#0072B2;",
                           #                                                       title = "Existing land wind capacity (GW) in selected county. If no existing wind farms, enter size (capacity) of initial construction project. Default 0.95 GW is 2025 nameplate capacity of Strauss Wind Farm in Santa Barbara County."
                           #                                                   )),
                           #                                 value = 0.95,  # Nameplate capacity (GW) of Strauss Wind Farm
                           #                                 min = 0
                           #                   ), 
                           #                   
                           #                   numericInput( ###### final capacity input ######
                           #                                 inputId = 'final_gw_land_input',
                           #                                 label = tags$span('Target Capacity (GW)',
                           #                                                   tags$i(
                           #                                                       class = "glyphicon glyphicon-info-sign",
                           #                                                       style = "color:#0072B2;",
                           #                                                       title = "Capacity (GW) to come online in year specified to meet targets above. Default matches current capacity in Santa Barbara County, as no county goals for land wind expansion are currently defined."
                           #                                                   )),
                           #                                 value = 0.95,
                           #                                 min = 0
                           #                   ),
                           #                   
                           #                   pickerInput( ###### job type input ######
                           #                                inputId = 'lw_job_type_input',
                           #                                label = tags$span('Direct, Indirect, or Induced Jobs',
                           #                                                  tags$i(
                           #                                                      class = "glyphicon glyphicon-info-sign",
                           #                                                      style = "color:#0072B2;",
                           #                                                      title = "Direct: Jobs on-site (e.g. welders, technicians). Indirect: Supply chain jobs (e.g. steel makers). Induced: Local jobs from worker spending (e.g. retail, healthcare). Total: Sum of Direct, Indirect, and Induced jobs."
                           #                                                  )),
                           #                                choices = c('Direct', 'Indirect', 'Induced', 'Total'),
                           #                                multiple = FALSE,
                           #                                options = pickerOptions(actionsBox = TRUE)
                           #                   ),
                           #                   
                           #                   id = "lw_inputs_box"  # for tutorial
                           #               ), # End input box
                           #               
                           #               box( ###### map output ######
                           #                    width = 8,
                           #                    
                           #                    leafletOutput(outputId = 'land_wind_map_output') |>
                           #                        withSpinner(type = 1, color = '#09847A'),
                           #                    
                           #                    id = "lw_map_box"  # for tutorial
                           #                    
                           #                    
                           #               )  # END leaflet box
                           #               
                           #     ), # End fluid Row
                           #     
                           #     fluidRow( ##### Second fluid row (plotly outputs) #####
                           #               
                           #               box( ###### job projections plot ######
                           #                    width = 7,
                           #                    # Create a plot based on input
                           #                    #  title = tags$strong('Labor Impact'),
                           #                    plotly::plotlyOutput(outputId = 'land_wind_jobs_plot_output') |> # Changed to table output to show data
                           #                        withSpinner(type = 1, color = '#09847A'),
                           #                    
                           #                    id = "lw_jobs_plot_box"  # for tutorial
                           #               ), 
                           #               
                           #               box( ###### capacity projections plot ######
                           #                    width = 5,
                           #                    plotly::plotlyOutput(outputId = 'lw_cap_projections_output') |>
                           #                        withSpinner(type = 1, color = '#09847A'),
                           #                    id = "lw_capacity_plot_box"  # for tutorial
                           #               )
                           #               
                           #               
                           #               
                           #     ) # End 2nd fluidRow
                           # ), # End Land Based Wind tabItem
                           # 
                           # OIL WELL CAPPING TAB ----
                           tabItem(tabName = 'well_cap', 
                                   
                                   # FIRST fluid row (top row with text + input on left, map on right)
                                   fluidRow(
                                       
                                       # LEFT column: text + county picker stacked
                                       column(width = 6,
                                              
                                              # Box for background text before user picks county
                                              box(
                                                  width = 12,
                                                  includeMarkdown('text/oil-capping.md'),
                                                  id = "cap_text_box" # For tutorial
                                              ),
                                              
                                              # County picker input
                                              box(
                                                  width = 12,
                                                  pickerInput(
                                                      inputId = 'county_wells_input',
                                                      label = tags$span("County",
                                                                        tags$i(
                                                                            class = "glyphicon glyphicon-info-sign", 
                                                                            style = "color:#0072B2;",
                                                                            title = "Choose a county"
                                                                        )),
                                                      choices = c('San Luis Obispo', 'Ventura', 'Santa Barbara'), 
                                                      multiple = FALSE
                                                  ), # End pickerInput
                                                  id = "cap_inputs_box" # For tutorial
                                              ) # End input box
                                              
                                       ), # End LEFT column
                                       
                                       # RIGHT column: map
                                       column(width = 6,
                                              box(
                                                  width = 12,
                                                  leafletOutput(outputId = 'capping_map_output', height = "590px") |>
                                                      withSpinner(type = 1, color = '#09847A'),
                                                  id = "cap_map_box" # For tutorial
                                              )
                                       ) # End RIGHT column
                                   ), # END first fluidRow
                                   
                                   # SECOND fluid row (bottom row with two side-by-side plots)
                                   fluidRow(
                                       box(
                                           width = 6,
                                           plotlyOutput(outputId = "oil_capping_jobs_plot", height = "400px") |>
                                               withSpinner(type = 1, color = '#09847A'),
                                           id = "cap_jobs_plot_box" # For tutorial
                                       ), # END jobs plot box
                                       
                                       box(
                                           width = 6,
                                           plotlyOutput(outputId = "oil_capping_plot", height = "400px") |>
                                               withSpinner(type = 1, color = '#09847A'),
                                           id = "cap_plot_box" # For tutorial
                                       ) # END total wells capped box
                                   ) # END second fluidRow
                           ), # END tabItem
                           
                           # FOSSIL FUEL PHASEOUT TAB ----
                           tabItem(tabName = 'phaseout', 
                                   
                                   fluidRow(  ##### First fluid row (picker inputs) #####
                                              # Box for background text before user picks county
                                              # box(
                                              #     width = 12,
                                              #     includeMarkdown('text/phaseout.md'),
                                              # ),
                                              
                                              box( 
                                                   width = 4,
                                              #     includeMarkdown('text/phaseout.md'),
                                                  pickerInput( ###### county input ######
                                                               inputId = 'phaseout_counties_input',
                                                               label = tags$span('County',
                                                                                 tags$i(
                                                                                     class = "glyphicon glyphicon-info-sign", 
                                                                                     style = "color:#0072B2;",
                                                                                     title = "Choose a county"
                                                                                 )),
                                                               choices = c('Santa Barbara', 'San Luis Obispo', 'Ventura'),
                                                               selected = c('Ventura'),
                                                               multiple = FALSE,
                                                               options = pickerOptions(actionsBox = TRUE
                                                               )
                                                               
                                                  ),
                                                  
                                                  pickerInput( ###### setback distance input ######
                                                               inputId = 'phaseout_setback_input',
                                                               label = tags$span(
                                                                   'Setback Policy Distance', 
                                                                   tags$i(
                                                                       class = "glyphicon glyphicon-info-sign", 
                                                                       style = "color:#0072B2;",
                                                                       title = "The current California state setback policy is 3,200 feet.")
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
                                                                       title = "Currently in California, setback is only applied to new wells.")
                                                               ),
                                                               choices = c(
                                                                   'Setback policy applies to new and existing wells' = 0,
                                                                   'Setback policy applies only to new wells' = 1
                                                               ),
                                                               selected = 1,
                                                               multiple = FALSE,
                                                               options = pickerOptions(actionsBox = TRUE)
                                                  ),
                                                  
                                                  id = "phaseout_inputs_box" # for tutorial
                                                  
                                              ), # END input box
                                              
                                              box( ###### map output ######
                                                   
                                                   width = 8, 
                                                   leafletOutput(outputId = 'phaseout_county_map_output') |>
                                                       withSpinner(type = 1, color = '#09847A'),
                                                   
                                                   id = "phaseout_map_box" # for tutorial
                                                   
                                              ) # END leaflet box
                                              
                                   ), # END  1st fluidRow
                                   
                                   
                                   fluidRow( ##### Second fluid row (plotly outputs) #####
                                             box( ###### Phaseout plot ######
                                                  width = 12,
                                                  # Create a table based on input
                                                  plotly::plotlyOutput(outputId = 'phaseout_plot') |> # Changed to table output to show data
                                                      withSpinner(type = 1, color = '#09847A'),
                                                  
                                                  id = "phaseout_jobs_plot_box" # for tutorial
                                             ) # END plot box
                                             
                                   ) # END 2nd fluid row)    
                                   
                           ), # End Fossil Fuel Phaseout tabItem
                           ########## Tool Documentation/User Manual Tab #######
                           tabItem(tabName = 'documentation',
                                   fluidRow(column(
                                       width = 12,
                                       box(
                                           width = NULL,
                                           #title = tagList(icon('sourcetree'), tags$strong('Economic Modeling Tools')),
                                           column(1),
                                           column(10, includeMarkdown('text/tool-doc2.md')),
                                           column(1)
                                       )
                                   )),
                                   # fluidRow(
                                   #     column(width = 12, align = "center",
                                   # #            p("For a detailed look at the technical documentation please visit here.")
                                   # #     )
                                   # # ), # End documentation fluidRow
                                   
                                   div(style = "text-align: center; margin-bottom: 30px;",
                                       h3("The Team")
                                   ),
                                   
                                   fluidRow(
                                       column(width = 4, align = "center",
                                              p("Elizabeth Peterson"),
                                              div(
                                                  a(href = "mailto:elizabethpeterson@bren.ucsb.edu", 
                                                    icon("envelope", style = "font-size: 1.5em; color: black;"), target = "_blank"),
                                                  HTML("&nbsp;&nbsp;"),
                                                  a(href = "https://github.com/egp4aq", 
                                                    icon("github", style = "font-size: 1.5em; color: black;"), target = "_blank"),
                                                  HTML("&nbsp;&nbsp;"),
                                                  a(href = "https://egp4aq.github.io", 
                                                    icon("globe", style = "font-size: 1.5em; color: black;"), target = "_blank")
                                              )
                                       ),
                                       column(width = 4, align = "center",
                                              p("Marina Kochuten"),
                                              div(
                                                  a(href = "mailto:marinakochuten@bren.ucsb.edu", 
                                                    icon("envelope", style = "font-size: 1.5em; color: black;"), target = "_blank"),
                                                  HTML("&nbsp;&nbsp;"),
                                                  a(href = "https://github.com/marinakochuten", 
                                                    icon("github", style = "font-size: 1.5em; color: black;"), target = "_blank"),
                                                  HTML("&nbsp;&nbsp;"),
                                                  a(href = "https://marinakochuten.github.io", 
                                                    icon("globe", style = "font-size: 1.5em; color: black;"), target = "_blank")
                                              )
                                       ),
                                       column(width = 4, align = "center",
                                              p("Brooke Grazda"),
                                              div(
                                                  a(href = "mailto:bgrazda@bren.ucsb.edu", 
                                                    icon("envelope", style = "font-size: 1.5em; color: black;"), target = "_blank"),
                                                  HTML("&nbsp;&nbsp;"),
                                                  a(href = "https://github.com/bgrazda", 
                                                    icon("github", style = "font-size: 1.5em; color: black;"), target = "_blank"),
                                                  HTML("&nbsp;&nbsp;"),
                                                  a(href = "https://bgrazda.github.io", 
                                                    icon("globe", style = "font-size: 1.5em; color: black;"), target = "_blank")
                                              )
                                       )
                                   )
                                   
                           ) # End Tool documentation tabItem
                       ) # End all tab items ----
                       
) # End dashboard body


# combine all into dashboardPage ----

dashboardPage(header, sidebar, body)