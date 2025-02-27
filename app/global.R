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


