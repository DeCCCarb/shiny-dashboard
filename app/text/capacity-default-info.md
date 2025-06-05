## How did we get our default capacity values?
When you enter our technology tabs, you will see a couple of default capacity scenarios to choose from. But... how did we get these?

### Floating Offshore Wind

The California Energy Commission’s Strategic Plan for Offshore Wind has established a statewide goal of 25 GW of floating offshore wind capacity by 2045. This capacity will be split between two regions slated for offshore wind development, two projects in Humboldt Bay and three in the Central Coast. In this analysis, the 25 GW capacity is split between these two sites based on the proposed projects, estimating that 60%, or 15 GW capacity by 2045, would be the Central Coast’s contribution to this goal. 

However, we know that this is quite an ambitious scenario, dependent on quick development backed by investment, infrastructure, and policy. Therefore, we calculated a second scenario: 6 GW, which is 40% of the original 15 GW goal. We gave these scenarios so that all users could have a place to start with our tool, based on the current statewide conversation around Floating Offshore Wind Development. However, we know that this conversation is changing rapidly. Therefore, users are also encouraged to enter in their own specific capacity goals. The scenario buttons are simply a jumping off point. 

### Rooftop & Utility-scale Solar

The California Air Resource's Board 2022 Scoping Plan sets forth statewide targets for rooftop and utility-scale solar, but it doesn't specify how these targets should be distributed among the counties. Therefore, to scale these estimates down the county level, our first step was to gather each county's current installed solar capacity from state energy data. Next, we calculated the percent increase needed statewide to meet California's 2045 goals. Finally, we applied that same percent increase to each county's current installed capacity, assuming that the counties would grow at a similar pace to the state as a whole. 

These tabs also have scenario buttons. These scenarios are the full goal for each county, calculated in the analysis above, and then 50% of that goal. 

## How did we calculate oil decline?

### Job Loss from Phasing out Crude Oil

To project job losses by county in California under various decarbonization policy scenarios, we used an empirical model developed by the Environmental Markets Lab at UCSB. This analysis incorporates these projections, along with additional estimates from the previous MEDS capstone project, Investigating the Social and Environmental Impacts of Supply Side Oil and Gas Policies in California, to model job loss as California transitions away from fossil fuels. The model's 2025 employment projections were validated against current Bureau of Labor Statistics data to ensure continued accuracy and relevance.

We visualized the employment projections under 5 setback policy scenarios, with the default being set to the current state policy, 3200-feet setback applied to only new wells. Including these other options provides context for the broader implications of California’s decarbonization transition under different possible scenarios.


### Jobs Created from Onshore Oil Well Capping

To project potential job creation from onshore oil well capping between 2025 and 2045, we multiplied the average number of jobs created per well by the total number of idle and active wells in California’s Central Coast. We gathered this number from a dataset created by Deshmukh et. al. that catalogs all wells in California, the number of idle and active oil and gas wells in Ventura, Santa Barbara, and San Luis Obispo Counties. 

According to Raimi et. al., capping a single oil well generates an average of 0.25 FTE jobs. By multiplying the total number of wells in each county by this factor, we estimate the total number of potential jobs created. To determine annual job creation, this total is divided by 20 years.
This model has several assumptions:
- All active wells will become idle and ready for capping by 2045, consistent with the typical 15–20 year lifespan of an oil well.
- Well capping will occur at an exponential rate, similar to other technologies.
- The number of new wells drilled in the Central Coast between 2025 and 2045 will be negligible.
