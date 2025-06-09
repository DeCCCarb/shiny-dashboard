## Understanding our Default Capacity Values

This tool is meant to help users explore possible futures for clean energy and oil transition in California’s Central Coast. In each technology tab, you'll find a couple of **default capacity scenarios** to choose from. These scenarios are not predictions - they’re starting points, based on current state-level goals, local data, and planning documents.

We included these to give users a baseline to begin exploring trade-offs, impacts, and opportunities. But the future is uncertain, and local realities will continue to evolve - so you are encouraged to modify these values and input your own.

Here’s how we arrived at the default scenarios you’ll see in each section:

---

### Floating Offshore Wind

The California Energy Commission’s Strategic Plan for Offshore Wind has established a statewide goal of 25 GW of floating offshore wind capacity by 2045. This capacity is split between two regions slated for development: two projects in Humboldt Bay and three in the Central Coast.

In this analysis, the 25 GW goal is divided based on these projects, estimating that 60%, or 15 GW, would come from the Central Coast by 2045.

However, since this is a highly ambitious target - relying on rapid development, investment, infrastructure, and policy - we also calculated a second scenario: 6 GW, which is 40% of the 15 GW goal.

These scenarios are meant to give users a place to start, based on the current statewide conversation around floating offshore wind. But that conversation is evolving, and users are encouraged to enter their own capacity goals. The scenario buttons are just a jumping off point.

---

### Rooftop & Utility-Scale Solar

The California Air Resources Board’s 2022 Scoping Plan sets statewide targets for rooftop and utility-scale solar, but it doesn’t specify how to divide these goals among counties.

To estimate county-level targets, we:
1. Collected current installed solar capacity by county using state energy data.
2. Calculated the percent increase needed statewide to meet the 2045 target.
3. Applied that increase to each county’s current capacity, assuming they grow at a similar pace as the state.

Each solar tab includes two default scenarios: the full 2045 goal for each county, and 50% of that goal.

#### Rooftop Scenarios

<table border="1" style="border-collapse: collapse;">
  <tr>
    <th style="padding: 8px;">County</th>
    <th style="padding: 8px;">Full Goal (MW by 2045)</th>
    <th style="padding: 8px;">50% Scenario (MW by 2045)</th>
  </tr>
  <tr>
    <td style="padding: 8px;">Santa Barbara</td>
    <td style="padding: 8px;">1,294</td>
    <td style="padding: 8px;">647</td>
  </tr>
  <tr>
    <td style="padding: 8px;">San Luis Obispo</td>
    <td style="padding: 8px;">1,844</td>
    <td style="padding: 8px;">922</td>
  </tr>
  <tr>
    <td style="padding: 8px;">Ventura</td>
    <td style="padding: 8px;">3,026</td>
    <td style="padding: 8px;">1,513</td>
  </tr>
</table>



#### Utility-Scale Scenarios

<table border="1" style="border-collapse: collapse;">
  <tr>
    <th style="padding: 8px;">County</th>
    <th style="padding: 8px;">Full Goal (MW by 2045)</th>
    <th style="padding: 8px;">50% Scenario (MW by 2045)</th>
  </tr>
  <tr>
    <td style="padding: 8px;">Santa Barbara</td>
    <td style="padding: 8px;">722</td>
    <td style="padding: 8px;">371</td>
  </tr>
  <tr>
    <td style="padding: 8px;">San Luis Obispo</td>
    <td style="padding: 8px;">10,525</td>
    <td style="padding: 8px;">5,262</td>
  </tr>
  <tr>
    <td style="padding: 8px;">Ventura</td>
    <td style="padding: 8px;">44</td>
    <td style="padding: 8px;">22</td>
  </tr>
</table>


---

## How did we calculate oil decline?

### Job loss from phasing out crude oil

To project job losses by county under different decarbonization policies, we used a model developed by the Environmental Markets Lab at UCSB. This model was supplemented by estimates from a previous MEDS capstone project: *Investigating the Social and Environmental Impacts of Supply Side Oil and Gas Policies in California*.

The model’s 2025 employment projections were validated against Bureau of Labor Statistics data to help ensure accuracy.

We show job loss projections under five different setback policies. The default is California’s current policy: a 3,200-foot setback applied only to new wells. Including alternative scenarios helps illustrate how job losses could vary based on policy choices.

---

### Jobs created from onshore oil well capping

To estimate jobs from onshore oil well capping between 2025 and 2045, we used data on idle and active wells in Ventura, Santa Barbara, and San Luis Obispo counties from a dataset by Deshmukh et al.

Based on Raimi et al., capping one well generates an average of 0.25 full-time equivalent (FTE) jobs. To estimate total jobs:

- Total wells × 0.25 = total FTE jobs  
- Total jobs ÷ 20 years = estimated annual job creation

Key assumptions in this model:
- All active wells will become idle and be ready for capping by 2045, consistent with their 15–20 year lifespan.
- Well capping will proceed at an exponential rate.
- The number of new wells drilled from 2025 to 2045 will be negligible.
