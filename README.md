# shiny-dashboard

## Shiny dashboard development for modeling decarbonization labor impacts

This repository holds our code for the development and deployment of our shiny dashboard. The purpose of this dashboard is to help community organizers and labor advocates assess the impacts of the clean energy transition on labor.

### Authors & contributors

- Brooke Grazda  [GitHub](https://github.com/bgrazda) | [Website](https://bgrazda.github.io/) | [LinkedIn](https://www.linkedin.com/in/brooke-grazda-a02248217/) 
- Marina Kochuten  [GitHub](https://github.com/marinakochuten) | [Website](https://marinakochuten.github.io/) | [LinkedIn](https://www.linkedin.com/in/marina-kochuten-4786b6324/) 
- Liz Peterson  [GitHib](https://github.com/egp4aq) | [Website](https://egp4aq.github.io/) | [LinkedIn](https://www.linkedin.com/in/elizabeth-peterson-85046b204/)

### Purpose

### File contents & structure

├── app/
│   ├── data/
│   │   ├── ca_counties/
│   │   │   ├── CA_Counties.cpg
│   │   │   ├── CA_Counties.dbf
│   │   │   ├── CA_Counties.prj
│   │   │   ├── CA_Counties.sbn
│   │   │   ├── CA_Counties.sbx
│   │   │   ├── CA_Counties.shp
│   │   │   ├── CA_Counties.shp.xml
│   │   │   ├── CA_Counties.shx
│   │   ├── .DS_Store
│   │   ├── ccc-coords.xlsx
│   │   ├── county_oil_employment_projections.csv
│   │   ├── osw.csv
│   │   ├── pv_all_plot.csv
│   ├── files/
│   │   ├── osw-jobs.Rmd
│   │   ├── osw_report.qmd
│   │   ├── rooftop-jobs.Rmd
│   │   ├── rooftop-jobs.Rnw
│   ├── text/
│   │   ├── citation.md
│   │   ├── disclaimer.md
│   │   ├── intro.md
│   ├── www/
│   │   ├── .sass_cache_keys
│   │   ├── california_counties_map1.png
│   │   ├── dashboard-fresh-themes.css
│   │   ├── teamwork-engineer-wearing-safety-uniform.jpg
│   ├── .DS_Store
│   ├── global.R
│   ├── server.R
│   ├── ui.R
├── scratch/
│   ├── create-fresh-theme.R
│   ├── modeling-jobs-transform-scratch.qmd
│   ├── osw_capacity_growth_plot_faculty_review.png
│   ├── plotly_scratch.R
│   ├── pv_all_plot.png
│   ├── scratch-download.R
│   ├── scratch-tmap.R
│   ├── scratch.qmd
│   ├── server_scratch.R
├── .DS_Store
├── .gitignore
├── README.md
├── shiny-dashboard.Rproj

```text ### File contents & structure ├── app/ │ ├── data/ │ │ ├── ca_counties/ │ │ │ ├── CA_Counties.cpg │ │ │ ├── CA_Counties.dbf │ │ │ ├── CA_Counties.prj │ │ │ ├── CA_Counties.sbn │ │ │ ├── CA_Counties.sbx │ │ │ ├── CA_Counties.shp │ │ │ ├── CA_Counties.shp.xml │ │ │ ├── CA_Counties.shx │ │ ├── .DS_Store │ │ ├── ccc-coords.xlsx │ │ ├── county_oil_employment_projections.csv │ │ ├── osw.csv │ │ ├── pv_all_plot.csv │ ├── files/ │ │ ├── osw-jobs.Rmd │ │ ├── osw_report.qmd │ │ ├── rooftop-jobs.Rmd │ │ ├── rooftop-jobs.Rnw │ ├── text/ │ │ ├── citation.md │ │ ├── disclaimer.md │ │ ├── intro.md │ ├── www/ │ │ ├── .sass_cache_keys │ │ ├── california_counties_map1.png │ │ ├── dashboard-fresh-themes.css │ │ ├── teamwork-engineer-wearing-safety-uniform.jpg │ ├── .DS_Store │ ├── global.R │ ├── server.R │ ├── ui.R ├── scratch/ │ ├── create-fresh-theme.R │ ├── modeling-jobs-transform-scratch.qmd │ ├── osw_capacity_growth_plot_faculty_review.png │ ├── plotly_scratch.R │ ├── pv_all_plot.png │ ├── scratch-download.R │ ├── scratch-tmap.R │ ├── scratch.qmd │ ├── server_scratch.R ├── .DS_Store ├── .gitignore ├── README.md ├── shiny-dashboard.Rproj ```
