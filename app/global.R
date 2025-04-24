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
library(sf)


########### Shapefile for leaflet map in server ####################

ca_counties <- sf::read_sf(here::here('app', 'data', 'ca_counties', 'CA_Counties.shp')) %>%
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
               type = "direct", 
               n_jobs = round(total_capacity_mw * direct_jobs, 2))
    
    # Indirect jobs
    df_indirect <- df %>%
        mutate(occupation = "O&M",
               type = "indirect", 
               n_jobs = round(total_capacity_mw * indirect_jobs, 2))
    
    # Induced jobs
    df_induced <- df %>%
        mutate(occupation = "O&M",
               type = "induced", 
               n_jobs = round(total_capacity_mw * induced_jobs, 2))
    
    # Stack them together for total jobs
    df_final <- rbind(df_direct, df_indirect, df_induced)
    
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
               type = "direct", 
               n_jobs = round(new_capacity_mw * direct_jobs, 2))   # Assuming that construction jobs only last the year, jobs/mw year will multiply by the new capacity
    
    # Indirect jobs
    df_indirect <- df %>%
        mutate(occupation = "Construction",
               type = "indirect", 
               n_jobs = round(new_capacity_mw * indirect_jobs, 2))
    
    # Induced jobs
    df_induced <- df %>%
        mutate(occupation = "Construction",
               type = "induced", 
               n_jobs = round(new_capacity_mw * induced_jobs, 2))
    
    # Stack them together for total jobs
    df_final <- rbind(df_direct, df_indirect, df_induced)
    
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
    if (initial_capacity == 0 || initial_capacity < 0){
        stop("initial_capacity must be a positive, non-zero number")
    }
    
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
               type = "direct", 
               n_jobs = zoo::rollapply(new_jobs, width = 5, FUN = sum, align = "right", partial = TRUE))
    
    # Indirect jobs
    # Initialize jobs/per GW Year that will be multiplied by capacity each year
    indirect_jobs_gw_year <- indirect_jobs/5 # Direct construction jobs outputted by JEDI / 5 Years
    # New jobs each year
    new_jobs <- indirect_jobs_gw_year * df$new_capacity_gw
    
    # Total indirect jobs each year: need to sum construction jobs over 5 year periods
    df_indirect <- df %>%
        mutate(occupation = "Construction", 
               type = "indirect", 
               n_jobs = zoo::rollapply(new_jobs, width = 5, FUN = sum, align = "right", partial = TRUE))
    
    # Induced jobs
    # Initialize jobs/per GW Year that will be multiplied by capacity each year
    induced_jobs_gw_year <- induced_jobs/5 # Direct construction jobs outputted by JEDI / 5 Years
    # New jobs each year
    new_jobs <- induced_jobs_gw_year * df$new_capacity_gw
    
    # Total indirect jobs each year: need to sum construction jobs over 5 year periods
    df_induced <- df %>%
        mutate(occupation = "Construction", 
               type = "induced", 
               n_jobs = zoo::rollapply(new_jobs, width = 5, FUN = sum, align = "right", partial = TRUE))
    
    # Stack them together for total jobs
    df_final <- rbind(df_direct, df_indirect, df_induced)
    
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
    if (initial_capacity == 0 || initial_capacity < 0){
        stop("initial_capacity must be a positive, non-zero number")
    }
    
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
               type = "direct", 
               n_jobs = total_capacity_gw * direct_jobs)

   # Calculate indirect jobs
    df_indirect <- df %>%
        mutate(occupation = "O&M",
               type = "indirect",
               n_jobs = total_capacity_gw * indirect_jobs)

    # Calculate induced jobs
    df_induced <- df %>%
        mutate(occupation = "O&M",
               type = "induced",
               n_jobs = total_capacity_gw * induced_jobs)

    # Stack them together for total jobs
    df_final <- rbind(df_direct, df_indirect, df_induced)

    return(df_final)
}

osw_construction <- calculate_osw_construction_jobs(
    county = "Tri-County",
    start_year = 2026,
    end_year = 2045,
    ambition = "High", 
    initial_capacity = 2,
    target_capacity = 15,
    direct_jobs = 82,
    indirect_jobs = 2571,
    induced_jobs = 781)

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
               type = "direct", 
               n_jobs = round(total_capacity_gw * direct_jobs, 2))
    
    # Indirect jobs
    df_indirect <- df %>%
        mutate(occupation = "O&M",
               type = "indirect", 
               n_jobs = round(total_capacity_gw * indirect_jobs, 2))
    
    # Induced jobs
    df_induced <- df %>%
        mutate(occupation = "O&M",
               type = "induced", 
               n_jobs = round(total_capacity_gw * induced_jobs, 2))
    
    # Stack them together for total jobs
    df_final <- rbind(df_direct, df_indirect, df_induced)
    
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
               type = "direct", 
               n_jobs = round(new_capacity_gw * direct_jobs, 2))
    
    # Indirect jobs
    df_indirect <- df %>%
        mutate(occupation = "Construction",
               type = "indirect", 
               n_jobs = round(new_capacity_gw * indirect_jobs, 2))
    
    # Induced jobs
    df_induced <- df %>%
        mutate(occupation = "Construction",
               type = "induced", 
               n_jobs = round(new_capacity_gw * induced_jobs, 2))
    
    # Stack them together for total jobs
    df_final <- rbind(df_direct, df_indirect, df_induced)
    
    return(df_final)
}