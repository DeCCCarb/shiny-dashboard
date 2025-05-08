# User Manual 

## Assumptions

Depending on the technology, there are different assumptions for each of the defaults. Each of these technologies use a compounding growth equation to reach the target goal inputted by the user, except for Oil Well Capping and Fossil Fuel Phaseout (see below).

### Compounding Growth Technologies

- *Floating Offshore Wind* defaults are set by the California Energy Commission statewide goal of 25 GW by 2045. Assuming 60% of the energy will be located in the Central Coast, the regional default goal is 15 GW by 2045. *Construction Jobs* are assumed to take 5 years after the start of construction before *Operations and Maintenance Jobs (O&M)* begin. Once started, O&M Jobs will be ongoing.
- *Utility Solar* defaults were made using the [California Air Resources Board Scoping Plan](https://ww2.arb.ca.gov/sites/default/files/2023-04/2022-sp.pdf). Using the current [county level utility renewable capacity](https://gis-california.opendata.arcgis.com/documents/0e04286d36a04acc82978f946c4fcdc3/about), the default values assume that 40% of customer solar comes from utility. This proportion of renewable capacity is based on historical data from the Solar Industries Association.

- *Rooftop Solar* defaults were made using the [California Air Resources Board Scoping Plan](https://ww2.arb.ca.gov/sites/default/files/2023-04/2022-sp.pdf). Using the current [county level customer solar capacity](https://www.californiadgstats.ca.gov/charts/), the default values assume that 60% of customer solar is rooftop. This proportion of renewable capacity is based on historical data from the Solar Industries Association.

- *Land Based Wind* No job projections were calculated for land-based wind, as no regional capacity goals are defined in the Central Coast. Currently, there is only 1 land-based wind project in the Central Coast, the Strauss Wind Project. As the Central Coast continues to decarbonize, land-based wind has the potential to grow, and therefore this model is included in the analysis. Should there be interest in projecting job creation from land-based wind development, this analysis can be used to explore many target scenarios within the dashboard. 

---

### Other Methods
- *Oil Well Capping:* In order to calculate the number of jobs produced from oil well capping, we must first calculate the rate at which all wells in the Central Coast will be capped. These projections come from [Deshmukh et al.](https://asu.elsevierpure.com/en/publications/equitable-low-carbon-transition-pathways-for-californias-oil-extr) We project a linear phaseout of the roughly 40,000 currently idle wells in the Central Coast from the present to 2045. Next, make a second linear projection if we were to phase out all 200,000 active wells in the Central Coast. 

- *Fossil Fuel Phase Out:* [Deshmukh et al.](https://asu.elsevierpure.com/en/publications/equitable-low-carbon-transition-pathways-for-californias-oil-extr) developed an empirical model that projected job loss by county in California under different decarbonization policy scenarios. This analysis incorporates these projections to model job loss as California moves away from fossil fuels. 2025 employment projections from their model were validated against current employment data from the Bureau of Labor Statistics to ensure the projections’ continued accuracy and usability. Of Deshmukh et. al.’s scenarios, the 2500 foot setback policy with no excise tax most closely resembles current policy, reflecting the most probable projections under current conditions. All scenarios presented in Deshmukh et. al., including projections for a 90% carbon tax or business-as-usual approach, are to be visualized in the dashboard.

---
## Projecting Outputs

### Jobs and Economic Development Impact (JEDI) Model

The Jobs and Economic Development (JEDI) models are static input-output models developed by the [National Renewable Energy Laboratory](https://www.nrel.gov/analysis/jedi/models). JEDI estimates the state level economic impacts of constructing and operating power generation and biofuel plants, using built-in economic multipliers from the economic development software IMPLAN. These multipliers are rates of change that describe how a given change in a particular industry generates impact in the overall economy. 

---
## IMPLAN

IMPLAN is an economic impact modeling tool that were used to get county multipliers for each technology used in JEDI. IMPLAN supplies multipliers for 528 pre-defined industries and 4 different variables.

### Multipliers of interest: 
- *Total Output:* describes the total output generated as a result of 1 dollar of output in the target industry
- *Employment:* describes the total jobs generated as a result of 1 job in the target industry
- *Labor Income:* describes the dollars of labor income generated as a result of one dollar of labor income in the target industry
- *Value Added:* describes the total dollars of value added generated as a result of one dollar of value added in the target industry

---

