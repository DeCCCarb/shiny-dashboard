
server <- function(input, output, session) {

##### Reactive Title #####
    observe({
        title_text <- switch(input$tabs,
                             "f_osw"     = "Floating Offshore Wind",
                             "utility"   = "Utility Solar",
                             "rooftop"   = "Rooftop Solar",
                             "lb_wind"   = "Land-Based Wind",
                             "well_cap"  = "Onshore Oil Well Capping",
                             "phaseout"  = "Fossil Fuel Phaseout",
                             "overview" = "Project Overview"
                             
        )
        
        output$dynamic_header_title <- renderUI({
            tags$span(title_text, style = "color: #3D4952; font-weight: bold;")
        })
    })
##### END Reactive Title #####
    
##### Tutorials #####
    
    # Automatically start tutorial on first session load ----
    shown_tutorials <- reactiveValues(
        # Start with all visits being false
        f_osw = FALSE,
        utility = FALSE,
        rooftop = FALSE,
        lb_wind = FALSE,
        well_cap = FALSE,
        phaseout = FALSE
    )
    observeEvent(input$tabs, {
        
        # OSW ----
        if (input$tabs == "f_osw" && !shown_tutorials$f_osw) {
            introjs(session, options = list(steps = list(
                list(intro = "<div style='text-align:center'><b>
                👋 Welcome to the Floating Offshore Wind Development tab!</b></div><br> 
                
                A new froniter for clean energy in California's Central Coast, 
                floating offshore wind is predicted to power up to 3.5 million homes, 
                marking a significant step towards California’s carbon neutrality goals and catalyzing a new economy
                around clean energy in the region. <br><br>
                
                Use this tool to explore potential job creation under different deployment scenarios of floating 
                     offshore wind development.",
                     
                     tooltipClass = "introjs-large"  # Custom class
                ),
                list(element = "#osw_inputs_box", intro = "Start by adjusting assumptions for construction years 
                and target capacity goals. Then, choose the type of jobs you would like to see. <br><br>
                     Default capacity values are scaled from the statewide goal of 25 GW by 2045 
                     (defined by the California Energy Commission) to a regional goal of 15 GW in the Central Coast. ",
                     position = "right"),
                list(element = "#osw_map_box", 
                     intro = "This map shows the total <i>FTE (full-time equivalent) jobs</i> created from your 
                     scenario for offshore wind development. <br><br> 
                     You can think of each FTE job as one full-time job that lasts for one year.",
                     position = "left"),
                list(element = "#osw_jobs_plot_box", 
                     intro = "This plot is the total projected jobs over time for your scenario. <br><br> 
                     Hover over this plot with your mouse to see the numbers divided into construction and 
                     operations & maintenance jobs. <br><br>
                     Want to share this plot? Hover your mouse in the top-right corner to reveal a download button.",
                     
                     tooltipClass = "introjs-wider"
                     ),
                list(element = "#osw_capacity_plot_box", 
                     intro = "This plot shows annual operating capacity over time. <br><br>
                     Hover over points with your mouse to view capacity estimates. Hover over the upper right corner 
                     of the plot for the download button."),
                list(element = ".sidebar-toggle", intro = "Collapse the sidebar using this button to get more space."),
                list(element = "#pdf_button", intro = "When you are finished setting up your scenario, 
                     you can download all outputs for your scenario as a single PDF."),
                list(element = "#tutorial_button", intro = "Click here to replay this tutorial at any time. 
                     <br><br> <b> Happy exploring! </b>")
            )))
            shown_tutorials$f_osw <- TRUE # only run the first time a user visits the tab
            
            # Utility ----
        } else if (input$tabs == "utility" && !shown_tutorials$utility) {
            introjs(session, options = list(steps = list(
                list(intro = "<b>👋 Welcome to the Utility Solar Development tab!</b><br><br>Use this tool to explore 
                     potential job creation under different deployment scenarios of utility-scale solar development.",
                     tooltipClass = "introjs-large"),  # Custom class
                list(element = "#util_inputs_box", intro = "Start by choosing your county, and then adjust assumptions 
                for construction years and target capacity goals. Then, choose the type of jobs you would like to see. <br><br>
                     Default capacity values are scaled to each county from the statewide goals outlined in 
                     California Air Resources Board's 2022 Scoping Plan.",
                     position = "right"),
                list(element = "#util_map_box", intro = "This map shows the total <i>FTE (full-time equivalent) jobs</i> created
                from your scenario for utility solar development. <br><br> 
                         You can think of each FTE job as one full-time job that lasts for one year.",
                     position = "left"),
                list(element = "#util_jobs_plot_box", intro = "This plot is the total projected jobs over time for your scenario. 
                <br><br> Hover over this plot with your mouse to see the numbers divided into construction and operations & 
                maintenance jobs. <br><br>
                     Want to share this plot? Hover your mouse in the top-right corner to reveal a download button.",
                     
                     tooltipClass = "introjs-wider"),
                list(element = "#util_capacity_plot_box", intro = "This plot shows annual operating capacity over time. <br><br>
                     Hover over points with your mouse to view capacity estimates. Hover over the upper 
                     right corner of the plot for the download button."),
                list(
                    element = ".sidebar-toggle",
                    intro = "Collapse the sidebar using this button to get more space."
                ),
                list(element = "#pdf_button", intro = "When you are finished setting up your scenario, 
                     you can download all outputs for your scenario as a single PDF."),
                list(element = "#tutorial_button", intro = "Click here to replay this tutorial at any time. 
                     <br><br> <b> Happy exploring! </b>")
            )))
            shown_tutorials$utility <- TRUE # only run the first time a user visits the tab
            
            # Rooftop ----
        } else if (input$tabs == "rooftop" && !shown_tutorials$rooftop) {
            introjs(session, options = list(steps = list(
                list(intro = "<b>👋 Welcome to the Rooftop Solar Development tab!</b><br><br>Use this tool to explore 
                     potential job creation under different deployment scenarios of rooftop solar development.",
                     tooltipClass = "introjs-large"),  # Custom class
                list(element = "#roof_inputs_box", intro = "Start by choosing your county, and then adjust assumptions 
                for construction years and target capacity goals. Then, choose the type of jobs you would like to see. <br><br>
                     Default capacity values are scaled to each county from the statewide goals outlined in 
                     California Air Resources Board's 2022 Scoping Plan.",
                     position = "right"),
                list(element = "#roof_map_box", intro = "This map shows the total <i>FTE (full-time equivalent) jobs</i> created
                from your scenario for rooftop solar development. <br><br> 
                         You can think of each FTE job as one full-time job that lasts for one year.",
                     position = "left"),
                list(element = "#roof_jobs_plot_box", intro = "This plot is the total projected jobs over time for your scenario. 
                <br><br> Hover over this plot with your mouse to see the numbers divided into construction and operations & 
                maintenance jobs. <br><br>
                     Want to share this plot? Hover your mouse in the top-right corner to reveal a download button.",
                     
                     tooltipClass = "introjs-wider"),
                list(element = "#roof_capacity_plot_box", intro = "This plot shows annual operating capacity over time. <br><br>
                     Hover over points with your mouse to view capacity estimates. 
                     Hover over the upper right corner of the plot for the download button."),
                list(
                    element = ".sidebar-toggle",
                    intro = "Collapse the sidebar using this button to get more space."
                ),
                list(element = "#pdf_button", intro = "When you are finished setting up your scenario, 
                     you can download all outputs for your scenario as a single PDF."),
                list(element = "#tutorial_button", intro = "Click here to replay this tutorial at any time. 
                     <br><br> <b> Happy exploring! </b>")
            )))
            shown_tutorials$rooftop <- TRUE # only run the first time a user visits the tab
            
            # Land wind ----
        } else if (input$tabs == "lb_wind" && !shown_tutorials$lb_wind) {
            introjs(session, options = list(steps = list(
                list(intro = "<b>👋 Welcome to the Land Based Wind Development tab!</b><br><br>
                Currently, the Strauss Wind Farm in Santa Barbara County is the only land based wind project in the Central Coast. 
                     <br><br>Use this tool to explore potential job creation under different 
                     deployment scenarios of land based wind development.",
                     tooltipClass = "introjs-large"),
                list(element = "#lw_inputs_box", intro = "Start by choosing your county, and then adjust assumptions 
                for construction years and target capacity goals. Then, choose the type of jobs you would like to see. <br><br>
                     There are no publically available capacity goals for land based wind in the Central Coast. 
                     Default values are based on the current capacity of the Strauss Wind Farm.",
                     position = "right"),
                list(element = "#lw_map_box", intro = "This map shows the total <i>FTE (full-time equivalent) jobs</i> created
                from your scenario for land based wind development. <br><br> 
                         You can think of each FTE job as one full-time job that lasts for one year.",
                     position = "left"),
                list(element = "#lw_jobs_plot_box", intro = "This plot is the total projected jobs over time for your scenario. 
                <br><br> Hover over this plot with your mouse to see the numbers divided into construction and operations & 
                maintenance jobs. <br><br>
                     Want to share this plot? Hover your mouse in the top-right corner to reveal a download button.",
                     
                     tooltipClass = "introjs-wider"),
                list(element = "#lw_capacity_plot_box", intro = "This plot shows annual operating capacity over time. <br><br>
                     Hover over points with your mouse to view capacity estimates. 
                     Hover over the upper right corner of the plot for the download button."),
                list(
                    element = ".sidebar-toggle",
                    intro = "Collapse the sidebar using this button to get more space."
                ),
                list(element = "#pdf_button", intro = "When you are finished setting up your scenario, 
                     you can download all outputs for your scenario as a single PDF."),
                list(element = "#tutorial_button", intro = "Click here to replay this tutorial at any time. 
                     <br><br> <b> Happy exploring! </b>")
            )))
            shown_tutorials$lb_wind <- TRUE # only run the first time a user visits the tab
            
            # Well capping ----
        } else if (input$tabs == "well_cap" && !shown_tutorials$well_cap) {
            introjs(session, options = list(steps = list(
                list(intro = "<b>👋 Welcome to the Onshore Oil Well Capping tab! </b><br><br>
                Capping oil wells is a crucial step in effective decarbonization. 
                Idle wells pose health risks and environmental hazards, emitting pollutants long after production ends. <br><br>
                In this tab, we show the number of jobs that could be created from capping all idle and active oil and gas wells 
                in each Central Coast county. While job creation from well capping is more modest compared to other technologies, 
                it remains an essential component of the region’s transition.",
                     tooltipClass = "introjs-large"),
                list(element = "#cap_inputs_box", intro = "Here, choose the county you would like to visualize."),
                list(element = "#cap_map_box", intro = "This map shows the total <i>FTE (full-time equivalent) direct jobs</i> created
                     created by county, as well as the total annual jobs created by capping all wells from 2025-2045.",
                     position = "left"),
                list(element = "#cap_jobs_plot_box", intro = "This plot is the cumulative projected direct jobs over time in your county. That is, the the total number of direct jobs that have been created each year since 2025.
                <br><br> Hover your mouse over the points to see the number of direct jobs each year <br><br> 
                     Want to share this plot? Hover your mouse in the top-right corner to reveal a download button.",
                     
                     tooltipClass = "introjs-wider"),
                list(element = "#cap_plot_box", intro = "This plot shows the total number of wells capped over time. <br><br>
                     Hover over points with your mouse to view number of wells. Hover over the upper right corner of the plot for the download button."),
                list(
                    element = ".sidebar-toggle",
                    intro = "Collapse the sidebar using this button to get more space."
                ),
                list(element = "#pdf_button", intro = "When you are finished setting up your scenario, 
                     you can download all outputs for your scenario as a single PDF."),
                list(element = "#tutorial_button", intro = "Click here to replay this tutorial at any time. <br><br> <b> Happy exploring! </b>")
            )))
            shown_tutorials$well_cap <- TRUE # only run the first time a user visits the tab
            
            # FF phaseout ---- 
        } else if (input$tabs == "phaseout" && !shown_tutorials$phaseout) {
            introjs(session, options = list(steps = list(
                list(intro = "<b>👋 Welcome to the Fossil Fuel Phaseout tab!</b><br><br>
                     In this tab, we report reusults from an emperical model built by Deshmukh et al. 
                     to allow you to compare direct job loss by county under varying setback policies. <br><br>
                     A setback policy is the required minimum distance between oil and gas drilling activities and certain
                     sensitive areas, such as homes, schools, hospitals, and other public spaces.
                     ", tooltipClass = "introjs-large"),
                list(element = "#phaseout_inputs_box", intro = "Start by selecting a county and setback policy. Default values are
                a 3,200 foot setback distance applied to only new wells, which matches the state’s 
                current setback policy distance.",
                     position = "right"),
                list(element = "#phaseout_map_box", intro = "This map shows the percent reduction in direct job loss from 
                     2025-2045 based on your input scenario.", 
                     position = "left"),
                list(element = "#phaseout_jobs_plot_box", intro = "This plot is the total projected direct jobs over time for your 
                scenario. 
                <br><br> Hover over this plot with your mouse to see the total number of direct jobs that year. <br><br>
                     Want to share this plot? Hover your mouse in the top-right corner to reveal a download button.",
                     tooltipClass = "introjs-wider"),
                list(
                    element = ".sidebar-toggle",
                    intro = "Collapse the sidebar using this button to get more space."
                ),
                list(element = "#pdf_button", intro = "When you are finished setting up your scenario, 
                     you can download all outputs for your scenario as a single PDF."),
                list(element = "#tutorial_button", intro = "Click here to replay this tutorial at any time. 
                     <br><br> <b> Happy exploring! </b>")
            )))
            shown_tutorials$phaseout <- TRUE # only run the first time a user visits the tab
        }
    })
    
    # Play tutorial when "Show Tutorial" button is pressed ----
    observeEvent(input$show_tutorial, {
        
        # OSW ----
        if (input$tabs == "f_osw") {
            introjs(session, options = list(steps = list(
                list(intro = "<div style='text-align:center'><b>
                👋 Welcome to the Floating Offshore Wind Development tab!</b></div><br> 
                
                A new froniter for clean energy in California's Central Coast, 
                floating offshore wind is predicted to power up to 3.5 million homes, 
                marking a significant step towards California’s carbon neutrality goals and catalyzing a new economy
                around clean energy in the region. <br><br>
                
                Use this tool to explore potential job creation under different deployment scenarios 
                     of floating offshore wind development.",
                     
                     tooltipClass = "introjs-large"  # Custom class
                ),
                list(element = "#osw_inputs_box", intro = "Start by adjusting assumptions for construction years and target capacity goals. Then, choose the type of jobs you would like to see. <br><br>
                     Default capacity values are scaled from the statewide goal of 25 GW by 2045 (defined by the California Energy Commission) to a regional goal of 15 GW in the Central Coast. ",
                     position = "right"),
                list(element = "#osw_map_box", 
                     intro = "This map shows the total <i>FTE (full-time equivalent) jobs</i> created from your scenario for offshore wind development. <br><br> 
                     You can think of each FTE job as one full-time job that lasts for one year.",
                     position = "left"),
                list(element = "#osw_jobs_plot_box", 
                     intro = "This plot is the total projected jobs over time for your scenario. <br><br> Hover over this plot with your mouse to see the numbers divided into construction and operations & maintenance jobs. <br><br>
                     Want to share this plot? Hover your mouse in the top-right corner to reveal a download button.",
                     
                     tooltipClass = "introjs-wider"
                ),
                list(element = "#osw_capacity_plot_box", 
                     intro = "This plot shows annual operating capacity over time. <br><br>
                     Hover over points with your mouse to view capacity estimates. Hover over the upper right corner of the plot for the download button."),
                list(element = ".sidebar-toggle", intro = "Collapse the sidebar using this button to get more space."),
                list(element = "#pdf_button", intro = "When you are finished setting up your scenario, 
                     you can download all outputs for your scenario as a single PDF."),
                list(element = "#tutorial_button", intro = "Click here to replay this tutorial at any time. <br><br> <b> Happy exploring! </b>")
            )))
             
            # Utility ----
        } else if (input$tabs == "utility") {
            introjs(session, options = list(steps = list(
                list(intro = "<b>👋 Welcome to the Utility Solar Development tab!</b><br><br>Use this tool to explore potential job creation under different deployment scenarios of utility-scale solar development.",
                     tooltipClass = "introjs-large"),  # Custom class
                list(element = "#util_inputs_box", intro = "Start by choosing your county, and then adjust assumptions for construction years and target capacity goals. Then, choose the type of jobs you would like to see. <br><br>
                     Default capacity values are scaled to each county from the statewide goals outlined in 
                     California Air Resources Board's 2022 Scoping Plan.",
                     position = "right"),
                list(element = "#util_map_box", intro = "This map shows the total <i>FTE (full-time equivalent) jobs</i> created
                from your scenario for utility solar development. <br><br> 
                         You can think of each FTE job as one full-time job that lasts for one year.",
                     position = "left"),
                list(element = "#util_jobs_plot_box", intro = "This plot is the total projected jobs over time for your scenario. 
                <br><br> Hover over this plot with your mouse to see the numbers divided into construction and operations & 
                maintenance jobs. <br><br>
                     Want to share this plot? Hover your mouse in the top-right corner to reveal a download button.",
                     
                     tooltipClass = "introjs-wider"),
                list(element = "#util_capacity_plot_box", intro = "This plot shows annual operating capacity over time. <br><br>
                     Hover over points with your mouse to view capacity estimates. Hover over the upper right corner of the plot for the download button."),
                list(
                    element = ".sidebar-toggle",
                    intro = "Collapse the sidebar using this button to get more space."
                ),
                list(element = "#pdf_button", intro = "When you are finished setting up your scenario, 
                     you can download all outputs for your scenario as a single PDF."),
                list(element = "#tutorial_button", intro = "Click here to replay this tutorial at any time. <br><br> <b> Happy exploring! </b>")
            )) )
            
            # Rooftop ----
        } else if (input$tabs == "rooftop") {
            introjs(session, options = list(steps = list(
                list(intro = "<b>👋 Welcome to the Rooftop Solar Development tab!</b><br><br>Use this tool to explore 
                     potential job creation under different deployment scenarios of rooftop solar development.",
                     tooltipClass = "introjs-large"),  # Custom class
                list(element = "#roof_inputs_box", intro = "Start by choosing your county, and then adjust assumptions 
                for construction years and target capacity goals. Then, choose the type of jobs you would like to see. <br><br>
                     Default capacity values are scaled to each county from the statewide goals outlined in 
                     California Air Resources Board's 2022 Scoping Plan.",
                     position = "right"),
                list(element = "#roof_map_box", intro = "This map shows the total <i>FTE (full-time equivalent) jobs</i> created
                from your scenario for rooftop solar development. <br><br> 
                         You can think of each FTE job as one full-time job that lasts for one year.",
                     position = "left"),
                list(element = "#roof_jobs_plot_box", intro = "This plot is the total projected jobs over time for your scenario. 
                <br><br> Hover over this plot with your mouse to see the numbers divided into construction and operations & 
                maintenance jobs. <br><br>
                     Want to share this plot? Hover your mouse in the top-right corner to reveal a download button.",
                     
                     tooltipClass = "introjs-wider"),
                list(element = "#roof_capacity_plot_box", intro = "This plot shows annual operating capacity over time. <br><br>
                     Hover over points with your mouse to view capacity estimates. 
                     Hover over the upper right corner of the plot for the download button."),
                list(
                    element = ".sidebar-toggle",
                    intro = "Collapse the sidebar using this button to get more space."
                ),
                list(element = "#pdf_button", intro = "When you are finished setting up your scenario, 
                     you can download all outputs for your scenario as a single PDF."),
                list(element = "#tutorial_button", intro = "Click here to replay this tutorial at any time. 
                     <br><br> <b> Happy exploring! </b>")
            )))
            
            # Land wind ----
        } else if (input$tabs == "lb_wind") {
            introjs(session, options = list(steps = list(
                list(intro = "<b>👋 Welcome to the Land Based Wind Development tab!</b><br><br>
                Currently, the Strauss Wind Farm in Santa Barbara County is the only land based wind project in the Central Coast. 
                     <br><br>Use this tool to explore potential job creation under different deployment scenarios of land based wind development.",
                     tooltipClass = "introjs-large"),
                list(element = "#lw_inputs_box", intro = "Start by choosing your county, and then adjust assumptions for construction years and target capacity goals. Then, choose the type of jobs you would like to see. <br><br>
                     There are no publically available capacity goals for land based wind in the Central Coast. Default values are based on the current capacity of the Strauss Wind Farm.",
                     position = "right"),
                list(element = "#lw_map_box", intro = "This map shows the total <i>FTE (full-time equivalent) jobs</i> created
                from your scenario for land based wind development. <br><br> 
                         You can think of each FTE job as one full-time job that lasts for one year.",
                     position = "left"),
                list(element = "#lw_jobs_plot_box", intro = "This plot is the total projected jobs over time for your scenario. 
                <br><br> Hover over this plot with your mouse to see the numbers divided into construction and operations & 
                maintenance jobs. <br><br>
                     Want to share this plot? Hover your mouse in the top-right corner to reveal a download button.",
                     
                     tooltipClass = "introjs-wider"),
                list(element = "#lw_capacity_plot_box", intro = "This plot shows annual operating capacity over time. <br><br>
                     Hover over points with your mouse to view capacity estimates. Hover over the upper right corner of the plot for the download button."),
                list(
                    element = ".sidebar-toggle",
                    intro = "Collapse the sidebar using this button to get more space."
                ),
                list(element = "#pdf_button", intro = "When you are finished setting up your scenario, 
                     you can download all outputs for your scenario as a single PDF."),
                list(element = "#tutorial_button", intro = "Click here to replay this tutorial at any time. <br><br> <b> Happy exploring! </b>")
            )))
            
            # Well capping ----
        } else if (input$tabs == "well_cap") {
            introjs(session, options = list(steps = list(
                list(intro = "<b>👋 Welcome to the Onshore Oil Well Capping tab! </b><br><br>
                Capping oil wells is a crucial step in effective decarbonization. 
                Idle wells pose health risks and environmental hazards, emitting pollutants long after production ends. <br><br>
                In this tab, we show the number of jobs that could be created from capping all idle and active oil and gas wells 
                in each Central Coast county. While job creation from well capping is more modest compared to other technologies, 
                it remains an essential component of the region’s transition.",
                     tooltipClass = "introjs-large"),
                list(element = "#cap_inputs_box", intro = "Here, choose the county you would like to visualize."),
                list(element = "#cap_map_box", intro = "This map shows the total <i>FTE (full-time equivalent) direct jobs</i> created
                     created by county, as well as the total annual jobs created by capping all wells from 2025-2045.",
                     position = "left"),
                list(element = "#cap_jobs_plot_box", intro = "This plot is the cumulative projected direct jobs over time in your county. That is, the the total number of direct jobs that have been created each year since 2025.
                <br><br> Hover your mouse over the points to see the number of direct jobs each year <br><br> 
                     Want to share this plot? Hover your mouse in the top-right corner to reveal a download button.",
                     
                     tooltipClass = "introjs-wider"),
                list(element = "#cap_plot_box", intro = "This plot shows the total number of wells capped over time. <br><br>
                     Hover over points with your mouse to view number of wells. Hover over the upper right corner of the plot for the download button."),
                list(
                    element = ".sidebar-toggle",
                    intro = "Collapse the sidebar using this button to get more space."
                ),
                list(element = "#pdf_button", intro = "When you are finished setting up your scenario, 
                     you can download all outputs for your scenario as a single PDF."),
                list(element = "#tutorial_button", intro = "Click here to replay this tutorial at any time. <br><br> <b> Happy exploring! </b>")
            )))
            
            # FF phaseout ----
        } else if (input$tabs == "phaseout") {
            introjs(session, options = list(steps = list(
                list(intro = "<b>👋 Welcome to the Fossil Fuel Phaseout tab!</b><br><br>
                     In this tab, we report reusults from an emperical model built by Deshmukh et al. 
                     to allow you to compare direct job loss by county under varying setback policies. <br><br>
                     What's a setback policy? The required minimum distance between oil and gas drilling activities and certain
                     sensitive areas, such as homes, schools, hospitals, and other public spaces.
                     ", tooltipClass = "introjs-large"),
                list(element = "#phaseout_inputs_box", intro = "Start by selecting a county and setback policy. Default values are
                a 3,200 foot setback distance applied to only new wells, which matches the state’s 
                current setback policy distance.",
                     position = "right"),
                list(element = "#phaseout_map_box", intro = "This map shows the percent reduction in direct job loss from 
                     2025-2045 based on your input scenario.", 
                     position = "left"),
                list(element = "#phaseout_jobs_plot_box", intro = "This plot is the total projected direct jobs over time for your 
                scenario. 
                <br><br> Hover over this plot with your mouse to see the total number of direct jobs that year. <br><br>
                     Want to share this plot? Hover your mouse in the top-right corner to reveal a download button.",
                     tooltipClass = "introjs-wider"),
                list(
                    element = ".sidebar-toggle",
                    intro = "Collapse the sidebar using this button to get more space."
                ),
                list(element = "#pdf_button", intro = "When you are finished setting up your scenario, 
                     you can download all outputs for your scenario as a single PDF."),
                list(element = "#tutorial_button", intro = "Click here to replay this tutorial at any time. 
                     <br><br> <b> Happy exploring! </b>")
            )))
        }
        })
    
##### END Tutorials #####
    
##### Download Button In Header Reactive to Current Tab #####
    output$export_pdf_button <- renderUI({
        current_tab <- input$tabs
        if (current_tab %in% c("f_osw", "utility", "rooftop", "lb_wind", "well_cap", "phaseout")) {
            downloadButton(outputId = paste0("export_", current_tab), label = NULL, icon = icon("file-pdf"))
        }
    })
    
    
    #  # Create reactive port for OSW map
    # 
    # port_input <- reactive({
    #     data.frame(
    #         port_name = c("Hueneme", "San Luis Obispo"),
    #         address = c(
    #             "Port of Hueneme, Port Hueneme, CA 93041",
    #             "699 Embarcadero, Morro Bay, CA 93442"
    #         )
    #     ) %>%
    #         tidygeocoder::geocode(address = address, method = "osm") |>
    #         filter(port_name == input$osw_port_input)
    #     
    #     
    #     
    # })
    
    # Define port coordinates
    ports_df <- data.frame(
        port_name = c("<center><b>Port Hueneme</b><br>Click for more on ports</center>", "<center><b>Port San Luis</b><br>Click for more on ports</center>"),
        address = c(
            "Port of Hueneme, Port Hueneme, CA 93041",
            "699 Embarcadero, Morro Bay, CA 93442"
        ),
        popup = c(
            "<center><b>Port of Hueneme - Proposed wind port location</b><br><br>Construction of specialized wind ports is <i>cruicial</i> to job creation in the Central Coast. <br><br>
            Without specialized port infrastructure, many of these high-skill jobs projected could be lost to other parts of the state. If the Central Coast invests in these facilities, it has the opportunity to become a national hub for floating offshore wind.
",
            "<center><b>Port of San Luis Obispo - Proposed wind port location</b><br><br>Construction of specialized wind ports is <i>cruicial</i> to job creation in the Central Coast. <br><br>
            Without specialized port infrastructure, many of these high-skill jobs projected could be lost to other parts of the state. If the Central Coast invests in these facilities, it has the opportunity to become a national hub for floating offshore wind."
        )) |>
        tidygeocoder::geocode(address = address, method = "osm")
    
    
    
    # Interactive OSW Map ----
    observeEvent(
        c(
            input$year_range_input,
            input$job_type_input,
            input$initial_capacity_input,
            input$final_capacity_input
 #           input$osw_port_input
        ),
        {
            # OSW total jobs map label ----
            # Calculate annual jobs when port is in CC
 #           if (!("No Central Coast Port" %in% input$osw_port_input)) {
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
                
            # } else {
            #     # Return 0 jobs
            #     osw_all <- data.frame(
            #         year = integer(),
            #         n_jobs = numeric(),
            #         occupation = character(),
            #         type = character(),
            #         stringsAsFactors = FALSE
            #     )
            # }
            
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
                    "<b>Total FTE Jobs in Central Coast</b>",
                    "<br>",
                    "Construction:",
                    scales::comma(const_njobs_label),
                    "<br>",
                    "O&M:",
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
                    addAwesomeMarkers(
                        data = ports_df,
                        lng = ~long,
                        lat = ~lat,
                        icon = port_icon,
                        popup = ~popup,
                        label = lapply(ports_df$port_name, HTML)
                    ) |>
                    addProviderTiles("CartoDB.Voyager") |>
                    setView(lng = -120.698189,
                            lat = 34.420830,
                            zoom = 7) |>
                    addPolygons(
                        data = osw_all_counties,
                        color = 'forestgreen',
                        opacity = 0.7
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
                # if (!("No Central Coast Port" %in% input$osw_port_input)) {
                #     ports_df <- data.frame(
                #         port_name = c("Hueneme", "San Luis Obispo"),
                #         address = c(
                #             "Port of Hueneme, Port Hueneme, CA 93041",
                #             "699 Embarcadero, Morro Bay, CA 93442"
                #         )
                #     ) |>
                #         filter(port_name %in% input$osw_port_input) |>
                #         tidygeocoder::geocode(address = 'address', method = "osm")
                #     
                #     leaflet_map <- leaflet_map |>
                #         addAwesomeMarkers(
                #             data = ports_df,
                #             lng = ports_df$long,
                #             lat = ports_df$lat,
                #             icon = port_icon,
                #             popup = paste('Port:', ports_df$port_name)
                #         )
                # }
                
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
        
        sb_utility_pv_om <- calculate_pv_om_jobs(
            county = "Santa Barbara",
            technology = "Utility PV",
            ambition = "High",
            start_year = input$year_range_input_utility[1],
            end_year = input$year_range_input_utility[2],
            initial_capacity = input$initial_mw_utility_input,
            final_capacity = input$final_mw_utility_input,
            direct_jobs = 0.18,
            indirect_jobs = 0.02,
            induced_jobs = 0.01
        )
        
        # SB Utility PV
        sb_utility_pv_const <- calculate_pv_construction_jobs(
            county = "Santa Barbara",
            start_year = input$year_range_input_utility[1],
            end_year = input$year_range_input_utility[2],
            technology = "Utility PV",
            ambition = "High",
            initial_capacity = input$initial_mw_utility_input,
            final_capacity = input$final_mw_utility_input,
            direct_jobs = 2.69,
            indirect_jobs = 0.93,
            induced_jobs = 0.5
        )
        
        # SLO Utility PV
        slo_utility_pv_om <- calculate_pv_om_jobs(
            county = "San Luis Obispo",
            technology = "Utility PV",
            ambition = "High",
            start_year = input$year_range_input_utility[1],
            end_year = input$year_range_input_utility[2],
            initial_capacity = input$initial_mw_utility_input,
            final_capacity = input$final_mw_utility_input,
            direct_jobs = 0.18,
            indirect_jobs = 0.02,
            induced_jobs = 0.01
        )
        
        slo_utility_pv_const <- calculate_pv_construction_jobs(
            county = "San Luis Obispo",
            start_year = input$year_range_input_utility[1],
            end_year = input$year_range_input_utility[2],
            technology = "Utility PV",
            ambition = "High",
            initial_capacity = input$initial_mw_utility_input,
            final_capacity = input$final_mw_utility_input,
            direct_jobs = 2.76,
            indirect_jobs = 1.09,
            induced_jobs = 0.51
        )
        
        # Ventura Utility PV
        ventura_utility_pv_om <- calculate_pv_om_jobs(
            county = "Ventura",
            technology = "Utility PV",
            ambition = "High",
            start_year = input$year_range_input_utility[1],
            end_year = input$year_range_input_utility[2],
            initial_capacity = input$initial_mw_utility_input,
            final_capacity = input$final_mw_utility_input,
            direct_jobs = 0.18,
            indirect_jobs = 0.02,
            induced_jobs = 0.01
        )
        
        # Construction Utility PV
        ventura_utility_pv_const <- calculate_pv_construction_jobs(
            county = "Ventura",
            start_year = input$year_range_input_utility[1],
            end_year = input$year_range_input_utility[2],
            technology = "Utility PV",
            ambition = "High",
            initial_capacity = input$initial_mw_utility_input,
            final_capacity = input$final_mw_utility_input,
            direct_jobs = 2.73,
            indirect_jobs = 0.91,
            induced_jobs = 0.5
        )
        
        # Join roof jobs by selected counties and job type
        county_utility <- rbind(sb_utility_pv_const, sb_utility_pv_om,
                                slo_utility_pv_const, slo_utility_pv_om,
                                ventura_utility_pv_const, ventura_utility_pv_om) |>
            filter(type %in% input$utility_job_type_input) |>
            filter(county %in% input$county_input) |>
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
            addProviderTiles("CartoDB.Voyager") |>
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
        
        # SB Utility PV
        sb_utility_pv_om <- calculate_pv_om_jobs(
            county = "Santa Barbara",
            technology = "Utility PV",
            ambition = "High",
            start_year = input$year_range_input_utility[1],
            end_year = input$year_range_input_utility[2],
            initial_capacity = input$initial_mw_utility_input,
            final_capacity = input$final_mw_utility_input,
            direct_jobs = 0.18,
            indirect_jobs = 0.02,
            induced_jobs = 0.01
        )
    
        sb_utility_pv_const <- calculate_pv_construction_jobs(
            county = "Santa Barbara",
            start_year = input$year_range_input_utility[1],
            end_year = input$year_range_input_utility[2],
            technology = "Utility PV",
            ambition = "High",
            initial_capacity = input$initial_mw_utility_input,
            final_capacity = input$final_mw_utility_input,
            direct_jobs = 2.69,
            indirect_jobs = 0.93,
            induced_jobs = 0.5
        )
        
        # SLO Utility PV
        slo_utility_pv_om <- calculate_pv_om_jobs(
            county = "San Luis Obispo",
            technology = "Utility PV",
            ambition = "High",
            start_year = input$year_range_input_utility[1],
            end_year = input$year_range_input_utility[2],
            initial_capacity = input$initial_mw_utility_input,
            final_capacity = input$final_mw_utility_input,
            direct_jobs = 0.18,
            indirect_jobs = 0.02,
            induced_jobs = 0.01
        )
        
        slo_utility_pv_const <- calculate_pv_construction_jobs(
            county = "San Luis Obispo",
            start_year = input$year_range_input_utility[1],
            end_year = input$year_range_input_utility[2],
            technology = "Utility PV",
            ambition = "High",
            initial_capacity = input$initial_mw_utility_input,
            final_capacity = input$final_mw_utility_input,
            direct_jobs = 2.76,
            indirect_jobs = 1.09,
            induced_jobs = 0.51
        )
        
        # Ventura Utility PV
        ventura_utility_pv_om <- calculate_pv_om_jobs(
            county = "Ventura",
            technology = "Utility PV",
            ambition = "High",
            start_year = input$year_range_input_utility[1],
            end_year = input$year_range_input_utility[2],
            initial_capacity = input$initial_mw_utility_input,
            final_capacity = input$final_mw_utility_input,
            direct_jobs = 0.18,
            indirect_jobs = 0.02,
            induced_jobs = 0.01
        )
        
        # Construction Utility PV
        ventura_utility_pv_const <- calculate_pv_construction_jobs(
            county = "Ventura",
            start_year = input$year_range_input_utility[1],
            end_year = input$year_range_input_utility[2],
            technology = "Utility PV",
            ambition = "High",
            initial_capacity = input$initial_mw_utility_input,
            final_capacity = input$final_mw_utility_input,
            direct_jobs = 2.73,
            indirect_jobs = 0.91,
            induced_jobs = 0.5
        )
        
        # Join roof jobs by selected counties and job type
        utility_all <- rbind(sb_utility_pv_const, sb_utility_pv_om,
                             slo_utility_pv_const, slo_utility_pv_om,
                             ventura_utility_pv_const, ventura_utility_pv_om) |>
            filter(type %in% input$utility_job_type_input) |> # Filter to inputted job type
            filter(county %in% input$county_input) |>
            select(-ambition)
        
        # Fix rounding so if 0 < jobs < 1, we see 2 decimal places, otherwise 0 decimals
        utility_all <- utility_all %>%
            mutate(
                n_jobs_rounded = if_else(
                    n_jobs < 1,
                    round(n_jobs, 2),
                    round(n_jobs, 0)
                ),
                n_jobs_label = if_else(
                    n_jobs < 1 & n_jobs > 0,
                    scales::comma(n_jobs_rounded, accuracy = 0.01),
                    scales::comma(n_jobs_rounded, accuracy = 1)
                )
            )
        
        #### Utility Jobs Plot ####
        utility_plot <- ggplot(utility_all,
                            aes(
                                x = as.factor(year),
                                y = n_jobs_rounded,
                                group = occupation
                            )) +
            geom_col(aes(fill = occupation, text = purrr::map(
                paste0(occupation, " jobs: ", n_jobs_label), HTML
            ))) +
            scale_fill_manual(
                labels = c("Construction Jobs", "Operations & Maintenance Jobs"),
                values = c("#3A8398", "#A3BDBE")
            ) +
            scale_y_continuous(labels = scales::comma) +
            scale_x_discrete(breaks = scales::breaks_pretty(n = 5)) +
            labs(
                title = glue::glue(
                    "Projected {input$utility_job_type_input} Jobs in {input$county_input} County from Utility Solar Development"
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
            config(utility_plot, modeBarButtonsToRemove = c('zoom2d','pan2d','autoScale',
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
        
    })
    
    # Generate capacity plot based on user selection ---
    output$utility_cap_projections_output <- renderPlotly({
        
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
        
        ##### Utility Capacity Plot #####
        
        utility_cap_plot <- ggplot() +
            geom_point(
                data = utility,
                aes(x = as.factor(year), 
                    y = total_capacity_mw,
                    text = purrr::map(
                        paste0("Capacity: ", scales::comma(round(total_capacity_mw, 2)), " MW"), HTML
                    )),
                color = "#3A8398"
            ) +
            scale_x_discrete(breaks = scales::breaks_pretty(n = 4)) +
            scale_y_continuous(labels = scales::label_comma()) +
            labs(y = "Capacity (MW)", title = "Annual Online Capacity (MW)") +
            theme_minimal() +
            theme(axis.title.x = element_blank())
        
        
        
        plotly::ggplotly(utility_cap_plot, tooltip = "text") |>
            config(utility_cap_plot, modeBarButtonsToRemove = c('zoom2d','pan2d','autoScale',
                                                        'zoomIn', 'zoomOut','select',
                                                        'resetScale', 'lasso'),
                   displaylogo = FALSE,
                   toImageButtonOptions = list(
                       format = "jpeg",
                       width = 1000,
                       height = 700,
                       scale = 15
                   )) |>
            layout(hovermode = "x unified") 
        
    }) # End Utility capacity plot
    
    
    # County selection
    counties_input <- reactive({
        counties |>
            filter(County == input$county_input)
    })
    
    ####### EXPORT UTILITY SOLAR AS PDF #############
    output$export_utility <- downloadHandler(
        filename = "utility-jobs.pdf",
        
        content = function(file) {
            src <- normalizePath(here::here('app', 'files', 'utility-jobs.Rmd'))
            
            # Switch to a temp directory
            owd <- setwd(tempdir())
            on.exit(setwd(owd), add = TRUE)
            
            file.copy(src, 'utility-jobs.Rmd', overwrite = TRUE)
            
            # Render the Rmd to PDF, output file will be named 'utility-jobs.pdf'
            output_file <- rmarkdown::render(
                input = 'utility-jobs.Rmd',
                output_format = "pdf_document",
                output_file = "utility-jobs.pdf"
            )
            
            # Copy the rendered PDF to the target location
            file.copy(output_file, file, overwrite = TRUE)
        }
        
    )
    
    
    ####### EXPORT OSW AS PDF #############
    output$export_f_osw <- downloadHandler(
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
                        "Projected {input$job_type_input} Jobs in CA Central Coast from Floating OSW development"
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
                        paste0("Capacity: ", scales::comma(round(total_capacity_gw, 2)), " GW"), HTML
                    )),
                color = "#3A8398"
            ) +
            scale_x_discrete(breaks = scales::breaks_pretty(n = 4)) +
            scale_y_continuous(labels = scales::label_comma()) +
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
        sb_roof_pv_om <- calculate_pv_om_jobs(
            county = "Santa Barbara",
            technology = "Rooftop PV",
            ambition = "High",
            start_year = input$year_range_input_roof[1],
            end_year = input$year_range_input_roof[2],
            initial_capacity = input$initial_mw_roof_input,
            final_capacity = input$final_mw_roof_input,
            direct_jobs = 0.22,
            indirect_jobs = 0.028,
            induced_jobs = 0.014
        )
        
        sb_roof_pv_const <- calculate_pv_construction_jobs(
            county = "Santa Barbara",
            start_year = input$year_range_input_roof[1],
            end_year = input$year_range_input_roof[2],
            technology = "Rooftop PV",
            ambition = "High",
            initial_capacity = input$initial_mw_roof_input,
            final_capacity = input$final_mw_roof_input,
            direct_jobs = 5.688,
            indirect_jobs = 4.028,
            induced_jobs = 2.05
        )
        
        slo_roof_pv_om <- calculate_pv_om_jobs(
            county = "San Luis Obispo",
            technology = "Rooftop PV",
            ambition = "High",
            start_year = input$year_range_input_roof[1],
            end_year = input$year_range_input_roof[2],
            initial_capacity = input$initial_mw_roof_input,
            final_capacity = input$final_mw_roof_input,
            direct_jobs = 0.22,
            indirect_jobs = 0.028,
            induced_jobs = 0.014
        )
        
        slo_roof_pv_const <- calculate_pv_construction_jobs(
            county = "San Luis Obispo",
            start_year = input$year_range_input_roof[1],
            end_year = input$year_range_input_roof[2],
            technology = "Rooftop PV",
            ambition = "High",
            initial_capacity = input$initial_mw_roof_input,
            final_capacity = input$final_mw_roof_input,
            direct_jobs = 6.042,
            indirect_jobs = 4.564,
            induced_jobs = 1.91
        )
        
        ventura_roof_pv_om <- calculate_pv_om_jobs(
            county = "Ventura",
            technology = "Rooftop PV",
            ambition = "High",
            start_year = input$year_range_input_roof[1],
            end_year = input$year_range_input_roof[2],
            initial_capacity = input$initial_mw_roof_input,
            final_capacity = input$final_mw_roof_input,
            direct_jobs = 0.22,
            indirect_jobs = 0.028,
            induced_jobs = 0.014
        )
        
        ventura_roof_pv_const <- calculate_pv_construction_jobs(
            county = "Ventura",
            start_year = input$year_range_input_roof[1],
            end_year = input$year_range_input_roof[2],
            technology = "Rooftop PV",
            ambition = "High",
            initial_capacity = input$initial_mw_roof_input,
            final_capacity = input$final_mw_roof_input,
            direct_jobs = 5.906,
            indirect_jobs = 3.964,
            induced_jobs = 2.026
        )
        
        roof_all <- rbind(sb_roof_pv_om, sb_roof_pv_const,
                          slo_roof_pv_om, slo_roof_pv_const,
                          ventura_roof_pv_om, ventura_roof_pv_const) |>
            filter(type %in% input$roof_job_type_input) |> # Filter to inputted job type
            filter(county %in% input$roof_counties_input)
        
        roof_all <- roof_all |>
            mutate(
                n_jobs_rounded = if_else(
                    n_jobs < 1,
                    round(n_jobs, 2),
                    round(n_jobs, 0)
                ),
                n_jobs_label = if_else(
                    n_jobs < 1 & n_jobs > 0,
                    scales::comma(n_jobs_rounded, accuracy = 0.01),
                    scales::comma(n_jobs_rounded, accuracy = 1)
                )
            )
        
        ##### Rooftop Job Plot #####
        roof_plot <- ggplot(roof_all,
                           aes(
                               x = as.factor(year),
                               y = n_jobs_rounded,
                               group = occupation
                           )) +
            geom_col(aes(fill = occupation, text = purrr::map(
                paste0(occupation, " jobs: ", n_jobs_label), HTML
            ))) +
            scale_fill_manual(
                labels = c("Construction Jobs", "Operations & Maintenance Jobs"),
                values = c("#3A8398", "#A3BDBE")
            ) +
            scale_y_continuous(labels = scales::comma) +
            scale_x_discrete(breaks = scales::breaks_pretty(n = 5)) +
            labs(
                title = glue::glue(
                    "Projected {input$roof_job_type_input} Jobs in {input$roof_counties_input} County from Rooftop Solar Development"
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
            config(roof_plot, modeBarButtonsToRemove = c('zoom2d','pan2d','autoScale',
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
        
        
        ##### Rooftop Capacity Plot #####
        
        roof_cap_plot <- ggplot() +
            geom_point(
                data = roof,
                aes(x = as.factor(year), 
                    y = total_capacity_mw,
                    text = purrr::map(
                        paste0("Capacity: ", scales::comma(round(total_capacity_mw, 2)), " MW"), HTML
                    )),
                color = "#3A8398"
            ) +
            scale_x_discrete(breaks = scales::breaks_pretty(n = 4)) +
            scale_y_continuous(labels = scales::label_comma()) +
            labs(y = "Capacity (MW)", title = "Annual Online Capacity (MW)") +
            theme_minimal() +
            theme(axis.title.x = element_blank())
        
        
        
        plotly::ggplotly(roof_cap_plot, tooltip = "text") |>
            config(roof_cap_plot, modeBarButtonsToRemove = c('zoom2d','pan2d','autoScale',
                                                        'zoomIn', 'zoomOut','select',
                                                        'resetScale', 'lasso'),
                   displaylogo = FALSE,
                   toImageButtonOptions = list(
                       format = "jpeg",
                       width = 1000,
                       height = 700,
                       scale = 15
                   )) |>
            layout(hovermode = "x unified") 
        
    }) # End Rooftop capacity plot
    
    # EXPORT ROOFTOP JOBS AS PDF #############
    
    output$export_rooftop <- downloadHandler(
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
        
        # Calculation of rooftop solar jobs (construction and operations) ----
        sb_roof_pv_om <- calculate_pv_om_jobs(
            county = "Santa Barbara",
            technology = "Rooftop PV",
            ambition = "High",
            start_year = input$year_range_input_roof[1],
            end_year = input$year_range_input_roof[2],
            initial_capacity = input$initial_mw_roof_input,
            final_capacity = input$final_mw_roof_input,
            direct_jobs = 0.22,
            indirect_jobs = 0.028,
            induced_jobs = 0.014
        )
        
        sb_roof_pv_const <- calculate_pv_construction_jobs(
            county = "Santa Barbara",
            start_year = input$year_range_input_roof[1],
            end_year = input$year_range_input_roof[2],
            technology = "Rooftop PV",
            ambition = "High",
            initial_capacity = input$initial_mw_roof_input,
            final_capacity = input$final_mw_roof_input,
            direct_jobs = 5.688,
            indirect_jobs = 4.028,
            induced_jobs = 2.05
        )
        
        slo_roof_pv_om <- calculate_pv_om_jobs(
            county = "San Luis Obispo",
            technology = "Rooftop PV",
            ambition = "High",
            start_year = input$year_range_input_roof[1],
            end_year = input$year_range_input_roof[2],
            initial_capacity = input$initial_mw_roof_input,
            final_capacity = input$final_mw_roof_input,
            direct_jobs = 0.22,
            indirect_jobs = 0.028,
            induced_jobs = 0.014
        )
        
        slo_roof_pv_const <- calculate_pv_construction_jobs(
            county = "San Luis Obispo",
            start_year = input$year_range_input_roof[1],
            end_year = input$year_range_input_roof[2],
            technology = "Rooftop PV",
            ambition = "High",
            initial_capacity = input$initial_mw_roof_input,
            final_capacity = input$final_mw_roof_input,
            direct_jobs = 6.042,
            indirect_jobs = 4.564,
            induced_jobs = 1.91
        )
        
        ventura_roof_pv_om <- calculate_pv_om_jobs(
            county = "Ventura",
            technology = "Rooftop PV",
            ambition = "High",
            start_year = input$year_range_input_roof[1],
            end_year = input$year_range_input_roof[2],
            initial_capacity = input$initial_mw_roof_input,
            final_capacity = input$final_mw_roof_input,
            direct_jobs = 0.22,
            indirect_jobs = 0.028,
            induced_jobs = 0.014
        )
        
        ventura_roof_pv_const <- calculate_pv_construction_jobs(
            county = "Ventura",
            start_year = input$year_range_input_roof[1],
            end_year = input$year_range_input_roof[2],
            technology = "Rooftop PV",
            ambition = "High",
            initial_capacity = input$initial_mw_roof_input,
            final_capacity = input$final_mw_roof_input,
            direct_jobs = 5.906,
            indirect_jobs = 3.964,
            induced_jobs = 2.026
        )
        
        # Create joined dataframe
        roof_all <- rbind(sb_roof_pv_om, sb_roof_pv_const,
                        slo_roof_pv_om, slo_roof_pv_const,
                        ventura_roof_pv_om, ventura_roof_pv_const) |>
            filter(type %in% input$roof_job_type_input) |> # Filter to inputted job type
            filter(county %in% input$roof_counties_input)
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
            addProviderTiles("CartoDB.Voyager") |>
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
            addProviderTiles("CartoDB.Voyager") |>
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
        
        lw_all <- lw_all |>
            mutate(
                n_jobs_rounded = if_else(
                    n_jobs < 1,
                    round(n_jobs, 2),
                    round(n_jobs, 0)
                ),
                n_jobs_label = if_else(
                    n_jobs < 1 & n_jobs > 0,
                    scales::comma(n_jobs_rounded, accuracy = 0.01),
                    scales::comma(n_jobs_rounded, accuracy = 1)
                )
            )
        
        ##### LW Jobs Plot #####
        lw_plot <- ggplot(lw_all,
                          aes(
                              x = as.factor(year),
                              y = n_jobs_rounded,
                              group = occupation
                          )) +
            geom_col(aes(fill = occupation, text = purrr::map(
                paste0(occupation, " jobs: ", n_jobs_label), HTML
            ))) +
            scale_fill_manual(
                labels = c("Construction Jobs", "Operations & Maintenance Jobs"),
                values = c("#3A8398", "#A3BDBE")
            ) +
            scale_y_continuous(labels = scales::comma) +
            scale_x_discrete(breaks = scales::breaks_pretty(n = 5)) +
            labs(
                title = glue::glue(
                    "Projected {input$lw_job_type_input} Jobs in {input$lw_counties_input} County from Land Wind Development"
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
            config(lw_plot, modeBarButtonsToRemove = c('zoom2d','pan2d','autoScale',
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
        
    }) # end lw jobs plot
    
    ##### LW Capacity Plot #####
    
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
                        paste0("Capacity: ", scales::comma(round(total_capacity_gw, 2)), " GW"), HTML
                    )),
                color = "#3A8398"
            ) +
            scale_x_discrete(breaks = scales::breaks_pretty(n = 4)) +
            scale_y_continuous(breaks = scales::breaks_pretty(n = 4),
                               labels = scales::label_comma()) +
            labs(y = "Capacity (GW)", title = "Annual Online Capacity (GW)") +
            theme_minimal() +
            theme(axis.title.x = element_blank())
        
        
        
        plotly::ggplotly(lw_cap_plot, tooltip = "text") |>
            config(lw_cap_plot, modeBarButtonsToRemove = c('zoom2d','pan2d','autoScale',
                                                        'zoomIn', 'zoomOut','select',
                                                        'resetScale', 'lasso'),
                   displaylogo = FALSE,
                   toImageButtonOptions = list(
                       format = "jpeg",
                       width = 1000,
                       height = 700,
                       scale = 15
                   )) |>
            layout(hovermode = "x unified")
        
    }) # End LW capacity plot
    
    ####### EXPORT LAND BASED WIND AS PDF #############
    output$export_lw <- downloadHandler(
        filename = "land-wind-jobs.pdf",
        
        content = function(file) {
            src <- normalizePath(here::here('app', 'files', 'land-wind-jobs.Rmd'))
            
            # Switch to a temp directory
            owd <- setwd(tempdir())
            on.exit(setwd(owd), add = TRUE)
            
            file.copy(src, 'land-wind-jobs.Rmd', overwrite = TRUE)
            
            # Render the Rmd to PDF, output file will be named 'utility-jobs.pdf'
            output_file <- rmarkdown::render(
                input = 'land-wind-jobs.Rmd',
                output_format = "pdf_document",
                output_file = "land-wind-jobs.pdf"
            )
            
            # Copy the rendered PDF to the target location
            file.copy(output_file, file, overwrite = TRUE)
        }
        
    )
    
    
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
    
    ##### Phaseout Jobs Plot #####
    output$phaseout_plot <- renderPlotly({
        phaseout_plot <- filtered_data() %>%
            ggplot(aes(
                x = as.factor(year),
                y = round(total_emp, 0),
                text = paste("Year:", year, "<br>Jobs:", scales::comma(round(total_emp, 0)))
            )) +
            geom_col(position = "dodge", fill = "#A3BDBE") +
            labs(
                title = glue::glue(
                    "Projected Fossil Fuel Fobs in {input$phaseout_counties_input} County"),
                y = 'Total direct employment') +
            scale_y_continuous(labels = scales::label_comma()) +
            theme_minimal() +
            theme(axis.title.x = element_blank())
        
        plotly::ggplotly(phaseout_plot, tooltip = "text") |>
            config(phaseout_plot, modeBarButtonsToRemove = c('zoom2d','pan2d','autoScale',
                                                        'zoomIn', 'zoomOut','select',
                                                        'resetScale', 'lasso'),
                   displaylogo = FALSE,
                   toImageButtonOptions = list(
                       format = "jpeg",
                       width = 1000,
                       height = 700,
                       scale = 15
                   )) |>
            layout(hovermode = "x unified") 

        
    }) # End phaseout jobs plot
    
    
##### OIL CAPPING #####
    
    # Oil capping jobs plot ----
    output$oil_capping_jobs_plot <- renderPlotly({
        
        
        # Filter data for selected county
        county_data <- oil_capping_jobs_all |> 
            filter(county == input$county_wells_input)
        
        # Create ggplot
        p <- ggplot(county_data) +
            geom_point(
                aes(
                    x = as.factor(year),
                    y = total_jobs_created,
                    text = paste0("Year: ", year, "<br>Cumulative Jobs Created: ", scales::comma(total_jobs_created))
                ),
                color = "#3A8398"
            ) +
            scale_x_discrete(breaks = scales::breaks_pretty(n = 5)) +
            scale_y_continuous(
                labels = scales::label_comma()
            ) +
            labs(
                title = paste("Cumulative Jobs Created in", {input$county_wells_input}, "County"),
                y = "Total Jobs Created"
            ) +
            theme_minimal() +
            theme(
                axis.title.x = element_blank()
            )
        
        plotly::ggplotly(p, tooltip = "text") |>
            config(
                modeBarButtonsToRemove = c('zoom2d', 'pan2d', 'autoScale',
                                           'zoomIn', 'zoomOut', 'select',
                                           'resetScale', 'lasso'),
                displaylogo = FALSE,
                toImageButtonOptions = list(
                    format = "jpeg",
                    width = 1000,
                    height = 700,
                    scale = 15
                )
            ) |>
            layout(hovermode = "x unified")
    })
    
    # Oil capping wells plot ----
    output$oil_capping_plot <- renderPlotly({
        
        
        # Filter data for selected county
        county_data <- oil_capping_jobs_all |> 
            filter(county == input$county_wells_input)
        
        # Define max_y for annotation line
        max_y <- max(county_data$total_wells_capped, na.rm = TRUE)
        
        # Create ggplot
        p <- ggplot(county_data) +
            geom_point(
                aes(
                    x = as.factor(year),
                    y = total_wells_capped,
                    text = paste0("Year: ", year, "<br>Wells Capped: ", scales::comma(total_wells_capped))
                ),
                color = "#3A8398"
            ) +
            scale_x_discrete(breaks = scales::breaks_pretty(n = 5)) +
            scale_y_continuous(
                labels = scales::label_comma()
            ) +
            labs(
                title = paste("Well Capping Projection for", {input$county_wells_input}, "County"),
                y = "Number of Wells Capped"
            ) +
            theme_minimal() +
            theme(
                axis.title.x = element_blank()
            )
        
        plotly::ggplotly(p, tooltip = "text") |>
            config(
                modeBarButtonsToRemove = c('zoom2d', 'pan2d', 'autoScale',
                                           'zoomIn', 'zoomOut', 'select',
                                           'resetScale', 'lasso'),
                displaylogo = FALSE,
                toImageButtonOptions = list(
                    format = "jpeg",
                    width = 1000,
                    height = 700,
                    scale = 15
                )
            ) |>
            layout(hovermode = "x unified")
    })
    
    
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
                label_text = paste0("<b><u><font size = '2.5'>", name, " County </b></u></font><br>Total Oil & Gas Wells: ", scales::comma(well_count),
                                    "<br> Total FTE Jobs: ", scales::comma(n_jobs),
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
            addProviderTiles("CartoDB.Voyager") |>
            setView(lng = -120.40189, lat = 34.920030, zoom = 8)
        
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

    label_coords <- data.frame(
        name = c("Santa Barbara", "San Luis Obispo", "Ventura"),
        lng = c(-120.7201, -121.0508, -119.4855),
        lat = c(34.58742, 35.40949, 34.35622)
    )

    # Get projection data based on input
    phaseout_projection_data <- phaseout_employment_projection(
        county_input = input$phaseout_counties_input,
        setback = input$phaseout_setback_input,
        setback_existing_filter = input$phaseout_setback_existing_input
    )

    # Get total employment in 2025 and 2045
    jobs_2025_total <- phaseout_projection_data %>%
        filter(year == 2025) %>%
        summarise(total_jobs = sum(total_emp, na.rm = TRUE)) %>%
        pull(total_jobs)

    jobs_2045_total <- phaseout_projection_data %>%
        filter(year == 2045) %>%
        summarise(total_jobs = sum(total_emp, na.rm = TRUE)) %>%
        pull(total_jobs)

    # Calculate percent decrease
    percent_decrease <- if (!is.na(jobs_2025_total) && jobs_2025_total > 0) {
        round((1 - (jobs_2045_total / jobs_2025_total)) * 100, 1)
    } else {
        NA
    }

    # Build label
    percent_label <- paste0(
        "<b>Projected % Decrease in Fossil Fuel Jobs <br>
        (",input$phaseout_counties_input," County, 2025–2045): </b>", percent_decrease, "%<br><br>",
        "<b>Projected Jobs in 2045:</b> ",
        round(jobs_2045_total, 0)
    )

    # Add label to selected counties
    ca_counties <- ca_counties |>
        mutate(
            label_text = percent_label
        )

    # Prepare label data
    label_data <- ca_counties |>
        filter(name == input$phaseout_counties_input) |>
        left_join(label_coords, by = "name") |>
        st_drop_geometry()

    leaflet_map <- leaflet() |>
        addProviderTiles("CartoDB.Voyager") |>
        setView(lng = -121.698189,
                lat = 34.420830,
                zoom = 7)

    # Add selected county polygon
    leaflet_map <- leaflet_map |>
        addPolygons(
            data = ca_counties |> filter(name == input$phaseout_counties_input),
            color = "forestgreen",
            opacity = 0.7
        )

    # Add label if county is selected
    if (!is.null(input$phaseout_counties_input)) {
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

    
    ##### Project Overview image carousel #####
    output$image_carousel <- renderSlickR({
        slickR(
            c("why_cc.svg","project_goal.svg","correct_tech.svg","all_tech.svg","next_step.svg") 
        )
    })
}
