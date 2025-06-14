# Load packages

library(shiny)
library(shinydashboard)
library(tidyverse)
library(leaflet)
library(shinycssloaders)
library(fresh)
library(shinyWidgets)
library(plotly)
library(shinyjs)
library(glue)
library(rintrojs)
library(slickR)
library(gridExtra)
library(mapview)
library(magick)
library(webshot2)
library(webshot)
library(here)
library(knitr)
library(tmap)
library(usdata)
library(sf)
library(readxl)
library(markdown)

########### Read in data ####################

counties <- read_csv(('data/ccc-coords.csv'))


job_projections <- read_csv('data/subset_county_results.csv') %>% 
    filter(county %in% c('Santa Barbara','San Luis Obispo','Ventura'))

########## JEDI Results - Jobs / Unit Energy ##########

# OSW ----
# Construction jobs/GW
osw_c_direct <- 82 
osw_c_indirect <- 2571
osw_c_induced <- 781
# Operations & Maintenance jobs/GW
osw_om_direct <- 127
osw_om_indirect <- 126
osw_om_induced <- 131

# Utility Ventura----
# Construction jobs/MW
util_v_c_direct <- 2.73 
util_v_c_indirect <- 0.91
util_v_c_induced <- 0.5
# Operations & Maintenance jobs/MW
util_v_om_direct <- 0.18
util_v_om_indirect <- 0.02
util_v_om_induced <- 0.01

# Utility SLO----
# Construction jobs/MW
util_slo_c_direct <- 2.76 
util_slo_c_indirect <- 1.09
util_slo_c_induced <- 0.51
# Operations & Maintenance jobs/MW
util_slo_om_direct <- 0.18
util_slo_om_indirect <- 0.02
util_slo_om_induced <- 0.01

# Utility SB----
# Construction jobs/MW
util_sb_c_direct <- 2.69 
util_sb_c_indirect <- 0.93
util_sb_c_induced <- 0.5
# Operations & Maintenance jobs/MW
util_sb_om_direct <- 0.18
util_sb_om_indirect <- 0.02
util_sb_om_induced <- 0.01

# Rooftop Ventura----
# Construction jobs/MW
roof_v_c_direct <- 5.906 
roof_v_c_indirect <- 3.964
roof_v_c_induced <- 2.026
# Operations & Maintenance jobs/MW
roof_v_om_direct <- 0.22
roof_v_om_indirect <- 0.028
roof_v_om_induced <- 0.014

# Rooftop SLO----
# Construction jobs/MW
roof_slo_c_direct <- 6.042 
roof_slo_c_indirect <- 4.564
roof_slo_c_induced <- 1.91
# Operations & Maintenance jobs/MW
roof_slo_om_direct <- 0.22
roof_slo_om_indirect <- 0.028
roof_slo_om_induced <- 0.014


# Rooftop SB----
# Construction jobs/MW
roof_sb_c_direct <- 5.688
roof_sb_c_indirect <- 4.028
roof_sb_c_induced <- 2.05
# Operations & Maintenance jobs/MW
roof_sb_om_direct <- 0.22
roof_sb_om_indirect <- 0.028
roof_sb_om_induced <- 0.014


########### Shapefile for leaflet map in server ####################


ca_counties <- sf::read_sf(('data/ca_counties/CA_Counties.shp')) %>%
    sf::st_transform('+proj=longlat +datum=WGS84') |> 
    janitor::clean_names() |> 
    filter(namelsad %in% c('Santa Barbara County', 'Ventura County', 'San Luis Obispo County'))

####### Shapefile for OSW leaflet map #############
osw_all_counties <- st_union(ca_counties, by_feature = FALSE)


###################### PV O&M Jobs Function ######################
#' Calculate PV Operations and Maintenance jobs and annual capacity
#'
#' @param county Character string. Name of the county.
#' @param start_year Integer. The year that you are starting with. E.g., 2025 for a 2025-2045 analysis.
#' @param end_year Integer. The year you are ending with. E.g., 2045 for a 2025-2045 analysis.
#' @param technology Character string. Name of the technology. E.g., "Utility PV" or "Rooftop PV".
#' @param ambition Character string, either "High" or "Low".
#' @param initial_capacity Numeric. Starting capacity in Megawatts. E.g., 100 for 100MW of solar already installed in 2025.
#' @param final_capacity Numeric. Target capacity in Megawatts. E.g., 500 for 500MW goal in 2045.
#' @param direct_jobs Numeric. JEDI output representing number of direct O&M jobs per MW of solar.
#' @param indirect_jobs Numeric. JEDI output representing number of indirect O&M jobs per MW of solar.
#' @param induced_jobs Numeric. JEDI output representing number of induced O&M jobs per MW of solar.
#'
#' @return Data Frame projecting total O&M jobs each year and energy capacity over designated time period

calculate_pv_om_jobs <- function(county, start_year, end_year, technology, ambition, initial_capacity,
                                 final_capacity, direct_jobs, indirect_jobs, induced_jobs) {
    
    # Calculate the annual growth rate
    growth_rate <- (final_capacity / initial_capacity)^(1 / (end_year - start_year)) - 1
    
    # Create variables to store the results
    year <- start_year:end_year
    capacity <- numeric(length(year))
    new_capacity <- numeric(length(year))
    
    # Calculate the total capacity for each year
    for (i in 1:length(year)) {
        capacity[i] <- initial_capacity * (1 + growth_rate)^(year[i] - start_year)
        if (i == 1) {
            new_capacity[i] <- capacity[i] - initial_capacity
        } else {
            new_capacity[i] <- capacity[i] - capacity[i-1]
        }
    }
    
    # Create a data frame with the results
    df <- data.frame(county = county, 
                     year = year, 
                     technology = technology,
                     ambition = ambition,
                     new_capacity_mw = round(new_capacity, 2),
                     total_capacity_mw = round(capacity, 2),
                     new_capacity_gw = round(new_capacity / 1000, 2),
                     total_capacity_gw = round(capacity / 1000, 2))
    
    # Direct jobs
    df_direct <- df %>%
        mutate(occupation = "O&M", 
               type = "Direct", 
               n_jobs = round(total_capacity_mw * direct_jobs, 2))
    
    # Indirect jobs
    df_indirect <- df %>%
        mutate(occupation = "O&M",
               type = "Indirect", 
               n_jobs = round(total_capacity_mw * indirect_jobs, 2))
    
    # Induced jobs
    df_induced <- df %>%
        mutate(occupation = "O&M",
               type = "Induced", 
               n_jobs = round(total_capacity_mw * induced_jobs, 2))
    
    # Stack them together for total jobs
    df_combined <- rbind(df_direct, df_indirect, df_induced)
    
    # Calculate total jobs
    df_total <- df_combined %>%
        group_by(county, year, technology, ambition) %>%
        summarise(n_jobs = sum(n_jobs, na.rm = TRUE), .groups = "drop") %>%
        left_join(df %>% 
                      select(county, year, new_capacity_mw, total_capacity_mw, new_capacity_gw, total_capacity_gw),
                  by = c("county", "year")) %>%
        mutate(occupation = "O&M", type = "Total")
    
    # Combine all into final dataframe
    df_final <- rbind(df_combined, df_total)
    
    # Return final result
    return(df_final)
}

#################### PV Construction Jobs Function ####################
#' Calculate PV Construction jobs and annual capacity
#'
#' @param county Character string. Name of the county.
#' @param start_year Integer. The year that you are starting with. E.g., 2025 for a 2025-2045 analysis.
#' @param end_year Integer. The year you are ending with. E.g., 2045 for a 2025-2045 analysis.
#' @param technology Character string. Name of the technology. E.g., "Utility PV" or "Rooftop PV".
#' @param ambition Character string, either "High" or "Low".
#' @param initial_capacity Numeric. Starting capacity in Megawatts. E.g., 100 for 100MW of solar already installed in 2025.
#' @param final_capacity Numeric. Target capacity in Megawatts. E.g., 500 for 500MW goal in 2045.
#' @param direct_jobs Numeric. JEDI output representing number of direct construction jobs per MW of solar.
#' @param indirect_jobs Numeric. JEDI output representing number of indirect construction jobs per MW of solar.
#' @param induced_jobs Numeric. JEDI output representing number of induced construction jobs per MW of solar.
#'
#' @return Data Frame projecting total construction jobs each year and energy capacity over designated time period


calculate_pv_construction_jobs <- function(county, start_year, end_year, technology, ambition, initial_capacity, final_capacity, direct_jobs, indirect_jobs, induced_jobs) {
    
    # Calculate the annual growth rate
    growth_rate <- (final_capacity / initial_capacity)^(1 / (end_year - start_year)) - 1
    
    # Create variables to store the results
    year <- start_year:end_year
    capacity <- numeric(length(year))
    new_capacity <- numeric(length(year))
    
    # Calculate the total capacity for each year
    for (i in 1:length(year)) {
        capacity[i] <- initial_capacity * (1 + growth_rate)^(year[i] - start_year)
        if (i == 1) {
            new_capacity[i] <- capacity[i] - initial_capacity
        } else {
            new_capacity[i] <- capacity[i] - capacity[i-1]
        }
    }
    
    # Create a data frame with the results
    df <- data.frame(county = county, 
                     year = year, 
                     technology = technology,
                     ambition = ambition,
                     new_capacity_mw = round(new_capacity, 2),
                     total_capacity_mw = round(capacity, 2),
                     new_capacity_gw = round(new_capacity / 1000, 2),
                     total_capacity_gw = round(capacity / 1000, 2))
    
    # Direct jobs
    df_direct <- df %>%
        mutate(occupation = "Construction", 
               type = "Direct", 
               n_jobs = round(new_capacity_mw * direct_jobs, 2))   # Assuming that construction jobs only last the year, jobs/mw year will multiply by the new capacity
    
    # Indirect jobs
    df_indirect <- df %>%
        mutate(occupation = "Construction",
               type = "Indirect", 
               n_jobs = round(new_capacity_mw * indirect_jobs, 2))
    
    # Induced jobs
    df_induced <- df %>%
        mutate(occupation = "Construction",
               type = "Induced", 
               n_jobs = round(new_capacity_mw * induced_jobs, 2))
    
    # Stack them together for total jobs
    df_combined <- rbind(df_direct, df_indirect, df_induced)
    
    # Calculate total jobs only for the final year
    df_total <- df_combined %>%
        group_by(county, year, technology, ambition) %>%
        summarise(n_jobs = sum(n_jobs, na.rm = TRUE), .groups = "drop") %>%
        left_join(df %>% 
                      select(county, year, new_capacity_mw, total_capacity_mw, new_capacity_gw, total_capacity_gw),
                  by = c("county", "year")) %>%
        mutate(occupation = "Construction", type = "Total")
    
    # Combine all into final dataframe
    df_final <- rbind(df_combined, df_total)
    
    # Return final result
    return(df_final)
}

###################### OSW Construction Jobs Function ######################  
#' Calculate OSW Construction jobs and annual capacity
#'
#' @param county Character string. Name of the county.
#' @param start_year Integer. The year that you are starting with. E.g., 2025 for a 2025-2045 analysis.
#' @param end_year Integer. The year you are ending with. E.g., 2045 for a 2025-2045 analysis.
#' @param ambition Character string, either "High" or "Low".
#' @param initial_capacity Numeric. Starting capacity in Gigawatts. E.g., 5 for 5 GW of wind to begin constructing at the start year
#' @param target_capacity Numeric. Target capacity in Gigawatts. E.g., 15 for 15 GW goal in end year.
#' @param direct_jobs Numeric. JEDI output representing number of direct construction jobs per GW of OSW.
#' @param indirect_jobs Numeric. JEDI output representing number of indirect construction jobs per GW of OSW.
#' @param induced_jobs Numeric. JEDI output representing number of induced construction jobs per GW of OSW.
#'
#' @return Data Frame projecting total construction jobs each year and energy capacity over designated time period


calculate_osw_construction_jobs <- function(county, start_year, end_year, ambition, initial_capacity,
                                            target_capacity, direct_jobs, indirect_jobs, induced_jobs) {
    # initial capacity cannot be zero!
    # if (initial_capacity == 0 || initial_capacity < 0){
    #     stop("initial_capacity must be a positive, non-zero number")
    # }
    
    # Create list of years
    year = start_year:end_year
    
    # Calculate the annual growth rate
    growth_rate <- (target_capacity / initial_capacity)^(1 / (end_year - (start_year+5))) - 1
    
    # Add total capacity for each year into empty list
    total_capacity <- numeric(length(year))
    
    # Calculate up and running capacity, starting 5 years after the year construction starts
    for (i in 6:length(year)) {
        total_capacity[i] <- initial_capacity * (1 + growth_rate)^(year[i] - (start_year + 5))
    }  
    
    # Calculate new capacity on the year construction starts
    new_capacity = lead(total_capacity, 5) - lead(total_capacity, 4)
    
    # Fill NAs with 0
    new_capacity[is.na(new_capacity)] <- 0
    
    # Create a data frame with the results
    df <- data.frame(county = county, 
                     year = year, 
                     technology = "Offshore Wind",
                     ambition = ambition,
                     new_capacity_mw = round(new_capacity*1000, 2),
                     total_capacity_mw = round(total_capacity*1000, 2),
                     new_capacity_gw = round(new_capacity, 2),
                     total_capacity_gw = round(total_capacity, 2))
    
    # Direct jobs
    # Initialize jobs/per GW Year that will be multiplied by capacity each year
    direct_jobs_gw_year <- direct_jobs/5 # Direct construction jobs outputted by JEDI / 5 Years
    # New jobs each year
    new_jobs <- direct_jobs_gw_year * df$new_capacity_gw
    
    # Total direct jobs each year: need to sum construction jobs over 5 year periods
    df_direct <- df %>%
        mutate(occupation = "Construction", 
               type = "Direct", 
               n_jobs = zoo::rollapply(new_jobs, width = 5, FUN = sum, align = "right", partial = TRUE))
    
    # Indirect jobs
    # Initialize jobs/per GW Year that will be multiplied by capacity each year
    indirect_jobs_gw_year <- indirect_jobs/5 # Indirect construction jobs outputted by JEDI / 5 Years
    # New jobs each year
    new_jobs <- indirect_jobs_gw_year * df$new_capacity_gw
    
    # Total indirect jobs each year: need to sum construction jobs over 5 year periods
    df_indirect <- df %>%
        mutate(occupation = "Construction", 
               type = "Indirect", 
               n_jobs = zoo::rollapply(new_jobs, width = 5, FUN = sum, align = "right", partial = TRUE))
    
    # Induced jobs
    # Initialize jobs/per GW Year that will be multiplied by capacity each year
    induced_jobs_gw_year <- induced_jobs/5 # Direct construction jobs outputted by JEDI / 5 Years
    # New jobs each year
    new_jobs <- induced_jobs_gw_year * df$new_capacity_gw
    
    # Total indirect jobs each year: need to sum construction jobs over 5 year periods
    df_induced <- df %>%
        mutate(occupation = "Construction", 
               type = "Induced", 
               n_jobs = zoo::rollapply(new_jobs, width = 5, FUN = sum, align = "right", partial = TRUE))
    
    # Combine direct, indirect, and induced job data
    df_combined <- rbind(df_direct, df_indirect, df_induced)
    
    # Calculate total jobs across all types
    df_total <- df_combined %>%
        group_by(county, year, technology, ambition) %>%
        summarise(n_jobs = sum(n_jobs, na.rm = TRUE), .groups = "drop") %>%
        left_join(df %>% select(county, year, new_capacity_mw, total_capacity_mw, new_capacity_gw, total_capacity_gw),
                  by = c("county", "year")) %>%
        mutate(occupation = "Construction", type = "Total")
    
    # Add the total row into the full dataframe
    df_final <- rbind(df_combined, df_total)
    
    # Return the final dataframe
    return(df_final)
    
}

###################### OSW Operations and Maintenance Jobs Function ######################  
#' Calculate OSW O&M jobs and annual capacity
#'
#' @param county Character string. Name of the county.
#' @param start_year Integer. The year that you are starting with. E.g., 2025 for a 2025-2045 analysis.
#' @param end_year Integer. The year you are ending with. E.g., 2045 for a 2025-2045 analysis.
#' @param ambition Character string, either "High" or "Low".
#' @param initial_capacity Numeric. Starting capacity in Gigawatts. E.g., 5 for 5 GW of wind to begin constructing at the start year
#' @param target_capacity Numeric. Target capacity in Gigawatts. E.g., 15 for 15 GW goal in end year.
#' @param direct_jobs Numeric. JEDI output representing number of direct O&M jobs per GW of OSW.
#' @param indirect_jobs Numeric. JEDI output representing number of indirect O&M jobs per GW of OSW.
#' @param induced_jobs Numeric. JEDI output representing number of induced O&M jobs per GW of OSW.
#'
#' @return Data Frame projecting total O&M jobs each year and energy capacity over designated time period


calculate_osw_om_jobs <- function(county, start_year, end_year, ambition, initial_capacity,
                                  target_capacity, direct_jobs, indirect_jobs, induced_jobs) {
    
    # initial capacity cannot be zero!
    # if (initial_capacity == 0 || initial_capacity < 0){
    #     stop("initial_capacity must be a positive, non-zero number")
    # }
    
    # Create list of years
    year = start_year:end_year
    
    # Calculate the annual growth rate
    growth_rate <- (target_capacity / initial_capacity)^(1 / (end_year - (start_year+5))) - 1
    
    # Add total capacity for each year into empty list
    total_capacity <- numeric(length(year))
    
    # Calculate up and running capacity, starting 5 years after the year construction starts
    for (i in 6:length(year)) {
        total_capacity[i] <- initial_capacity * (1 + growth_rate)^(year[i] - (start_year + 5))
    }  
    
    # Calculate new capacity on the year construction starts
    new_capacity = lead(total_capacity, 5) - lead(total_capacity, 4)
    
    # Fill NAs with 0
    new_capacity[is.na(new_capacity)] <- 0
    
    # Create a data frame with the results
    df <- data.frame(county = county, 
                     year = year, 
                     technology = "Offshore Wind",
                     ambition = ambition,
                     new_capacity_mw = round(new_capacity*1000, 2),
                     total_capacity_mw = round(total_capacity*1000, 2),
                     new_capacity_gw = round(new_capacity, 2),
                     total_capacity_gw = round(total_capacity, 2))
    
    # Calculate direct jobs
    df_direct <- df %>%
        mutate(occupation = "O&M", 
               type = "Direct", 
               n_jobs = total_capacity_gw * direct_jobs)
    
    # Calculate indirect jobs
    df_indirect <- df %>%
        mutate(occupation = "O&M",
               type = "Indirect",
               n_jobs = total_capacity_gw * indirect_jobs)
    
    # Calculate induced jobs
    df_induced <- df %>%
        mutate(occupation = "O&M",
               type = "Induced",
               n_jobs = total_capacity_gw * induced_jobs)
    
    # Combine direct, indirect, and induced job data
    df_combined <- rbind(df_direct, df_indirect, df_induced)
    
    # Calculate total jobs across all types
    df_total <- df_combined %>%
        group_by(county, year, technology, ambition) %>%
        summarise(n_jobs = sum(n_jobs, na.rm = TRUE), .groups = "drop") %>%
        left_join(df %>% select(county, year, new_capacity_mw, total_capacity_mw, new_capacity_gw, total_capacity_gw),
                  by = c("county", "year")) %>%
        mutate(occupation = "O&M", type = "Total")
    
    # Add the total row into the full dataframe
    df_final <- rbind(df_combined, df_total)
    
    # Return the final dataframe
    return(df_final)
}

# osw_construction <- calculate_osw_construction_jobs(
#     county = "Tri-County",
#     start_year = 2026,
#     end_year = 2045,
#     ambition = "High", 
#     initial_capacity = 2,
#     target_capacity = 15,
#     direct_jobs = 82,
#     indirect_jobs = 2571,
#     induced_jobs = 781)

################## Create default values for rooftop solar ###########

# Create dataframe that has each of the counties initial capacity and final capacity goals
# Create the original long-format data frame
rooftop_targets <- expand.grid(
    counties = c('San Luis Obispo', 'Santa Barbara', 'Ventura'),
    values = c("initial", "final")
)

# Add capacity values
rooftop_targets$capacity <- c(344.84, 242.02, 424.20, 1843.69, 1293.94, 3026.38)

# Pivot to wide format
rooftop_targets <- rooftop_targets %>%
    pivot_wider(names_from = counties, values_from = capacity)

################## Create default values for utility solar ###########
# Create the long-format dataframe
utility_targets_long <- expand.grid(
    counties = c('San Luis Obispo', 'Santa Barbara', 'Ventura'),
    values = c("initial", "final")
)

# Add capacity values
utility_targets_long$capacity <- c(1615.82, 110.86, 6.72, 10524.86, 722.08, 43.76)


# Pivot to wide format
utility_targets <- utility_targets_long %>%
    pivot_wider(names_from = counties, values_from = capacity)

# Remove longer utility df after pivoting
rm(utility_targets_long)


###################### Land Wind O&M Jobs Function ######################
#' Calculate Land-Based Wind Operations and Maintenance jobs and annual capacity
#'
#' @param county Character string. Name of the county.
#' @param start_year Integer. The year that you are starting with. E.g., 2025 for a 2025-2045 analysis.
#' @param end_year Integer. The year you are ending with. E.g., 2045 for a 2025-2045 analysis.
#' @param initial_capacity Numeric. Starting capacity in Gigawatts.
#' @param final_capacity Numeric. Target capacity in Gigawatts. E.g., 5 for 5 GW goal in 2045.
#' @param direct_jobs Numeric. JEDI output representing number of direct O&M jobs per GW of land wind.
#' @param indirect_jobs Numeric. JEDI output representing number of indirect O&M jobs per GW of land wind.
#' @param induced_jobs Numeric. JEDI output representing number of induced O&M jobs per GW of land wind.
#'
#' @return Data Frame projecting total O&M jobs each year and energy capacity over designated time period
#'


calculate_land_wind_om_jobs <- function(county, start_year, end_year, initial_capacity,
                                        final_capacity, direct_jobs, indirect_jobs, induced_jobs) {
    
    # Calculate the annual growth rate
    growth_rate <- (final_capacity / initial_capacity)^(1 / (end_year - start_year)) - 1
    
    # Create variables to store the results
    year <- start_year:end_year
    capacity <- numeric(length(year))
    new_capacity <- numeric(length(year))
    
    # Calculate the total capacity for each year
    for (i in 1:length(year)) {
        capacity[i] <- initial_capacity * (1 + growth_rate)^(year[i] - start_year)
        if (i == 1) {
            new_capacity[i] <- capacity[i] - initial_capacity
        } else {
            new_capacity[i] <- capacity[i] - capacity[i-1]
        }
    }
    
    # Create a data frame with the results
    df <- data.frame(county = county, 
                     year = year, 
                     technology = "Land-Based Wind",
                     ambition = NA,
                     new_capacity_mw = round(new_capacity*1000, 2),
                     total_capacity_mw = round(capacity*1000, 2),
                     new_capacity_gw = round(new_capacity, 2),
                     total_capacity_gw = round(capacity, 2))
    
    # Direct jobs
    df_direct <- df %>%
        mutate(occupation = "O&M", 
               type = "Direct", 
               n_jobs = total_capacity_gw * direct_jobs)
    
    # Indirect jobs
    df_indirect <- df %>%
        mutate(occupation = "O&M",
               type = "Indirect", 
               n_jobs = total_capacity_gw * indirect_jobs)
    
    # Induced jobs
    df_induced <- df %>%
        mutate(occupation = "O&M",
               type = "Induced", 
               n_jobs = total_capacity_gw * induced_jobs)
    
    # Stack them together for total jobs
    df_combined <- rbind(df_direct, df_indirect, df_induced)
    
    # Calculate total jobs only for the final year
    df_total <- df_combined %>%
        group_by(county, year, technology, ambition) %>%
        summarise(n_jobs = sum(n_jobs, na.rm = TRUE), .groups = "drop") %>%
        left_join(df %>% 
                      select(county, year, new_capacity_mw, total_capacity_mw, new_capacity_gw, total_capacity_gw),
                  by = c("county", "year")) %>%
        mutate(occupation = "O&M", type = "Total")
    
    # Combine all into final dataframe
    df_final <- rbind(df_combined, df_total)
    
    # Return final result
    return(df_final)
}

#################### Land Wind Construction Jobs Function ####################
#' Calculate Land Wind Construction jobs and annual capacity
#'
#' @param county Character string. Name of the county.
#' @param start_year Integer. The year that you are starting with. E.g., 2025 for a 2025-2045 analysis.
#' @param end_year Integer. The year you are ending with. E.g., 2045 for a 2025-2045 analysis.
#' @param initial_capacity Numeric. Starting capacity in Gigawatts.
#' @param final_capacity Numeric. Target capacity in Gigawatts. E.g., 5 for 5 GW goal in 2045.
#' @param direct_jobs Numeric. JEDI output representing number of direct construction jobs per GW of land wind.
#' @param indirect_jobs Numeric. JEDI output representing number of indirect construction jobs per GW of land wind.
#' @param induced_jobs Numeric. JEDI output representing number of induced construction jobs per GW of land wind.
#'
#' @return Data Frame projecting total construction jobs each year and energy capacity over designated time period


calculate_land_wind_construction_jobs <- function(county, start_year, end_year, initial_capacity, final_capacity, direct_jobs, indirect_jobs, induced_jobs) {
    
    # Calculate the annual growth rate
    growth_rate <- (final_capacity / initial_capacity)^(1 / (end_year - start_year)) - 1
    
    # Create variables to store the results
    year <- start_year:end_year
    capacity <- numeric(length(year))
    new_capacity <- numeric(length(year))
    
    # Calculate the total capacity for each year
    for (i in 1:length(year)) {
        capacity[i] <- initial_capacity * (1 + growth_rate)^(year[i] - start_year)
        if (i == 1) {
            new_capacity[i] <- capacity[i] - initial_capacity
        } else {
            new_capacity[i] <- capacity[i] - capacity[i-1]
        }
    }
    
    # Create a data frame with the results
    df <- data.frame(county = county, 
                     year = year, 
                     technology = "Land-Based Wind",
                     ambition = NA,
                     new_capacity_mw = round(new_capacity*1000, 2),
                     total_capacity_mw = round(capacity*1000, 2),
                     new_capacity_gw = round(new_capacity, 2),
                     total_capacity_gw = round(capacity, 2))
    
    # Direct jobs - it is assumed that construction of land wind project takes on average 1 year
    df_direct <- df %>%
        mutate(occupation = "Construction", 
               type = "Direct", 
               n_jobs = new_capacity_gw * direct_jobs)
    
    # Indirect jobs
    df_indirect <- df %>%
        mutate(occupation = "Construction",
               type = "Indirect", 
               n_jobs = new_capacity_gw * indirect_jobs)
    
    # Induced jobs
    df_induced <- df %>%
        mutate(occupation = "Construction",
               type = "Induced", 
               n_jobs = new_capacity_gw * induced_jobs)
    
    # Stack them together for total jobs
    df_combined <- rbind(df_direct, df_indirect, df_induced)
    
    # Calculate total jobs only for the final year
    df_total <- df_combined %>%
        group_by(county, year, technology, ambition) %>%
        summarise(n_jobs = sum(n_jobs, na.rm = TRUE), .groups = "drop") %>%
        left_join(df %>% 
                      select(county, year, new_capacity_mw, total_capacity_mw, new_capacity_gw, total_capacity_gw),
                  by = c("county", "year")) %>%
        mutate(occupation = "Construction", type = "Total")
    
    # Combine all into final dataframe
    df_final <- rbind(df_combined, df_total)
    
    # Return final result
    return(df_final)
}

#################### Fossil Fuel Jobs Phaseout function ####################

#' Calculate direct employment in fossil fuels given certain policy scenario. 
#'
#' @param excise_tax Character string. Could be no tax or tax_setback_1000ft.
#' @param setback Character string. Could be setback_1000ft, setback_2500ft, setback_5280ft, or no_setback.
#' @param oil_price Character string. Could be low oil price, high oil price, or reference case.
#' @param prod_quota Character string. Could be no quota.
#'
#' @return Plot showing direct employment under given scenario
#'
#' @example
#' Direct fossil fuel employment phaseout 2025–2045: 5280 ft setback policy
#' phaseout_employment_projection(setback = 'setback_5280ft')

phaseout_employment_projection <- function(county_input, excise_tax = 'no tax', setback,
                                           oil_price = 'reference case', prod_quota = 'no quota', setback_existing_filter, carbon_price = 'price floor') {
    
    # Filter data according to function inputs
    filtered_data <- job_projections %>%
        filter(county == county_input,
               excise_tax_scenario == excise_tax,
               setback_scenario == setback,
               setback_existing == setback_existing_filter,
               oil_price_scenario == oil_price,
               prod_quota_scenario == prod_quota,
               carbon_price_scenario == carbon_price,
               year %in% c(2025:2045)) %>% 
        select(year, excise_tax_scenario, setback_scenario, prod_quota_scenario, oil_price_scenario, county, total_emp) %>% 
        return(filtered_data)
    
}


#################### Oil Capping Workflow ####################

# Read in well data from Deshmukh et al. paper
wells <- read_csv("data/AllWells_20210427.csv")


#### Calculate total wells in all 3 counties - include idle, active, and new

idle_plus_active_wells_total <- wells |> 
    filter(WellStatus %in% c("Idle", "Active", "New") &
               WellTypeLa == "Oil & Gas") |> 
    filter(CountyName %in% c('Santa Barbara', 'San Luis Obispo', 'Ventura')) |> 
    group_by(CountyName) |> 
    summarise(total_wells_capped = n())

############# Calculate Oil Well Capping total exponential growth  ##########

#' @param total_wells_capped_df  Deshmukh et. al dataframe
calculate_capping_jobs_all <- function(total_wells_capped_df, start_year = 2025, end_year = 2045) {
    results <- list()
    
    for (i in 1:nrow(total_wells_capped_df)) {
        county_name <- total_wells_capped_df$CountyName[i]
        final_jobs <- total_wells_capped_df$total_jobs[i]
        
        initial_jobs <- 4
        
        growth_rate <- (final_jobs / initial_jobs)^(1 / (end_year - start_year)) - 1
        
        year <- start_year:end_year
        employment <- numeric(length(year))
        new_jobs <- numeric(length(year))
        
        for (j in 1:length(year)) {
            employment[j] <- initial_jobs * (1 + growth_rate)^(year[j] - start_year)
            if (j == 1) {
                new_jobs[j] <- employment[j] - initial_jobs
            } else {
                new_jobs[j] <- employment[j] - employment[j - 1]
            }
        }
        
        df <- data.frame(
            county = county_name,
            year = year,
            technology = "Oil Well Capping",
            new_jobs = round(new_jobs, 2),
            total_jobs = round(employment, 2)
        )
        
        results[[i]] <- df
    }
    
    return(do.call(rbind, results))
}




############################# Santa Barbara #############################

# Calculate total wells in Santa Barbara to be capped and save - include Idle, Active, and New
idle_plus_active_wells_sb <- nrow(wells |>
                                      filter(WellStatus %in% c("Idle", "Active", "New") &
                                                 WellTypeLa == "Oil & Gas" &
                                                 CountyName == "Santa Barbara"))

# Calculate the capping rate (number of wells to cap each year)
capping_rate <- idle_plus_active_wells_sb / (2045-2025)

# Make df with year
oil_capping_jobs <- data.frame(
    year = 2025:2045
)

# Calculate total wells capped at each year
oil_capping_jobs <- oil_capping_jobs |>
    mutate(total_wells_capped = round((year - 2025) * capping_rate, 0))

# Calculate total jobs
oil_capping_jobs_sb <- oil_capping_jobs |>
    mutate(total_jobs_created = round(total_wells_capped * 0.25, 0),
           county = "Santa Barbara")

################# CALCULATE OIL WELL CAPPING EXPONENTIAL GROWTH ################
calculate_capping_jobs <- function(wells_df){
    
    if(wells_df$CountyName == 'Santa Barbara') {
        final_jobs = oil_capping_jobs_sb
    } else if(wells_df$CountyName == 'San Luis Obispo'){
        final_jobs == oil_capping_jobs_slo
    } else if(wells_df$CountyName == 'Ventura'){
        final_jobs == oil_capping_jobs_v
    }
    
    # Calculate the annual growth rate
    growth_rate <- (wells_df$final_jobs / 4)^(1 / (2045 - 2025)) - 1 # 4 jobs to start by default
    
    # Create variables to store the results
    year <- 2025:2045
    employment <- numeric(length(year))
    new_jobs <- numeric(length(year))
    
    # Calculate the total employment for each year
    for (i in 1:length(year)) {
        employment[i] <- initial_jobs * (1 + growth_rate)^(year[i] - start_year)
        if (i == 1) {
            new_jobs[i] <- employment[i] - initial_jobs
        } else {
            new_jobs[i] <- employment[i] - employment[i-1]
        }
    }
    
    # Create a data frame with the results
    df <- data.frame(county = county, 
                     year = year, 
                     technology = "Oil Well Capping",
                     new_jobs = round(new_jobs, 2),
                     total_jobs = round(employment, 2), # .25 FTE jobs per well
                     total_wells = round(emplyoment, 2)) # Total wells
    
    
    
}


############################# San Luis Obispo #############################

# Calculate total wells in Santa Barbara to be capped and save - include Idle, Active, and New
idle_plus_active_wells_slo <- nrow(wells |>
                                       filter(WellStatus %in% c("Idle", "Active", "New") &
                                                  WellTypeLa == "Oil & Gas" &
                                                  CountyName == "San Luis Obispo"))

# Calculate the capping rate (number of wells to cap each year)
capping_rate <- idle_plus_active_wells_slo / (2045-2025)

# Make df with year
oil_capping_jobs <- data.frame(
    year = 2025:2045
)

# Calculate total wells capped at each year
oil_capping_jobs <- oil_capping_jobs |>
    mutate(total_wells_capped = round((year - 2025) * capping_rate, 0))

# Calculate total jobs
oil_capping_jobs_slo <- oil_capping_jobs |>
    mutate(total_jobs_created = round(total_wells_capped * 0.25, 0),
           county = "San Luis Obispo")

############################# Ventura #############################

# Calculate total wells in Santa Barbara to be capped and save - include Idle, Active, and New
idle_plus_active_wells_v <- nrow(wells |>
                                     filter(WellStatus %in% c("Idle", "Active", "New") &
                                                WellTypeLa == "Oil & Gas" &
                                                CountyName == "Ventura"))

# Calculate the capping rate (number of wells to cap each year)
capping_rate <- idle_plus_active_wells_v / (2045-2025)

# Make df with year
oil_capping_jobs <- data.frame(
    year = 2025:2045
)

# Calculate total wells capped at each year
oil_capping_jobs <- oil_capping_jobs |>
    mutate(total_wells_capped = round((year - 2025) * capping_rate, 0))

# Calculate total jobs
oil_capping_jobs_v <- oil_capping_jobs |>
    mutate(total_jobs_created = round(total_wells_capped * 0.25, 0),
           county = "Ventura")

# Combine county data
oil_capping_jobs_all <- bind_rows(
    oil_capping_jobs_sb,
    oil_capping_jobs_slo,
    oil_capping_jobs_v
)