# Load packages
library(shiny)
library(shinydashboard)
library(tidyverse)
library(leaflet)
library(shinycssloaders)
library(fresh)
library(shinyWidgets)


# read in data ---

counties <- readxl::read_xlsx('data/ccc-coords.xlsx')


pv_all_plot <- read_csv(here::here('app', 'data', 'pv_all_plot.csv'))


ca_counties <- sf::read_sf(here::here('app', 'data', 'ca_counties', 'CA_Counties.shp')) %>%
    sf::st_transform('+proj=longlat +datum=WGS84') |> 
    janitor::clean_names() |> 
    filter(namelsad %in% c('Santa Barbara County', 'Ventura County', 'San Luis Obispo County'))

osw <- read_csv(here::here('app', 'data', 'osw.csv'))
