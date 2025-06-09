# Models, Assumptions, & Limitations

---

## Models

### --- Jobs and Economic Development Impact (JEDI) Model ---

The [JEDI models](https://www.nrel.gov/analysis/jedi/models), developed by the [National Renewable Energy Laboratory (NREL)](https://www.nrel.gov), are static input-output models designed to estimate economic impacts from constructing and operating renewable energy projects. JEDI calculates job creation, labor income, and economic output through three types of effects:

- **Direct effects:** Jobs and income generated on-site or directly related to the project (e.g., construction crews, project developers, operations and maintenance (O&M) staff).
- **Indirect effects:** Jobs and income generated in supply chains and supporting industries (e.g., equipment manufacturers, consultants, financial services).
- **Induced effects:** Economic activity driven by spending of wages earned by workers in the direct and indirect categories (e.g., retail, hospitality, local services).

JEDI distinguishes two phases of job creation:

- **Construction phase:** Short-term full-time equivalent (FTE) jobs lasting the construction period.
- **Operations phase:** Long-term, ongoing annual FTE jobs related to operation and maintenance.

### --- IMPLAN Economic Multipliers ---

IMPLAN (IMpact analysis for PLANning) provides detailed county-level economic multipliers to reflect regional economic structures. These multipliers quantify how economic activity in one industry propagates through local supply chains and spending, enabling localized job and economic impact estimates.

IMPLAN multipliers are integrated into JEDI’s framework via the User Add-in Location feature to generate county-level projections for California’s Central Coast.

Key multiplier types used:

- **Output Multiplier:** Total economic output generated per dollar of direct output.
- **Employment Multiplier:** Total jobs (direct, indirect, induced) generated per direct job.
- **Labor Income Multiplier:** Total labor income generated per dollar of direct labor income.
- **Value Added Multiplier:** Additional economic value created per dollar of value added in the industry.

### --- Additional Models ---

**Fossil Fuel Phaseout Job Loss Model:** Projections from the [Environmental Market's Lab (emLab)](https://emlab.ucsb.edu) are reported on in this tool, to provide context to potential transitional pathways the clean energy transition can provide. This model, developed by Deshmukh *et al*., estimates county-level job losses due to fossil fuel phaseout under various decarbonization scenarios. These projections were validated against current Bureau of Labor Statistics data.

---

### Assumptions

**JEDI Model Assumptions:**

JEDI is a static input-output model that assumes fixed inter-industry relationships and consumption patterns. It does not incorporate future productivity improvements, price changes, or supply chain evolution. Many inputs are required including project size, costs, and local economic shares, all of which shape the output of the model. Detailed JEDI inputs used for this analysis are documented in the full [technical documentation](https://bren.ucsb.edu/projects/modeling-impact-decarbonization-labor-californias-central-coast).

**Capacity Growth:**

All technologies use a compounding growth equation to project capacity expansion toward 2045 targets, scaling statewide goals to county-level where county-specific goals are unavailable.

**Technology-Specific Assumptions:**

- *Floating Offshore Wind:* Assumes a 25 GW statewide target by 2045, with 60% (15 GW) assigned to the Central Coast. Construction lasts 5 years; O&M jobs begin post-construction and continue indefinitely.
- *Utility-Scale Solar:* Capacity growth scaled from California Air Resources Board targets, assuming 40% of customer solar is utility-scale.
- *Rooftop Solar:* Similarly scaled from statewide targets, assuming 60% of customer solar is rooftop installations. Residential and commercial rooftop solar job estimates are weighted accordingly (40% residential, 60% commercial).
- *Oil Well Capping:* Assumes all active wells will be capped by 2045 with negligible new wells drilled.
 
---

## Limitations

- JEDI does not model dynamic changes in productivity, price, or technology over time.
- IMPLAN multipliers are static and reflect 2025 economic structures. They do not capture evolving economic structures beyond 2025.
- Scaling statewide capacity targets to counties assumes uniform growth rates, which may not reflect local policy, geography, or market conditions.
- Floating offshore wind job estimates depend on the development of specialized infrastructure (e.g., wind ports), which is uncertain and may concentrate job growth geographically.

---

For detailed model inputs, assumptions, and methodology, please refer to the [full Technical Documentation](https://bren.ucsb.edu/projects/modeling-impact-decarbonization-labor-californias-central-coast)


