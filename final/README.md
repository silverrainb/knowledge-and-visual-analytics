# Knowledge and visual analytics
## Final Project Proposal
### Rose Koh, Fall 2018

## Idea
An article `Desperate for Data Scientists` intrigued me for this final project.

Based on the premise that the Occupational Employment Statistics data for the Computer and Mathematical Occupations (Major Group) is
representative of the Data Science profession, my goal is to provide information such as a number of employment, mean and median wage per state. 
Additionally, I plan to provide the same information for top 20 MSA (regarding a number of employment) along with cost of living index so that audience can properly assess their consideration.

### Data Source

* Occupational Employment Statistics - Computer and Mathematical Occupations

https://www.bls.gov/oes/current/oes150000.htm#st

The Bureau of Labor Statistics collated `Occupational Employment Statistics`. 
The data I obtained to leverage is limited to 15-0000 Computer and Mathematical Occupations (Major Group) in May 2017.
These estimates are calculated with data collected from employers in all industry sectors, all metropolitan and non-metropolitan areas, and all states and the District of Columbia.

* Cost of living index - 2017 annual average data for comparing 269 urban areas

http://kedc.com/wp-content/uploads/2018/02/2017-Annual-Average-Index.pdf

Assume that City A has a composite index of 98.3 and City B has a composite index of 128.5. If you live in City A and are contemplating
a job offer in City B, how much of an increase in your after-taxes income is needed to maintain your present lifestyle?

100*[(City B – City A)/City A] = 100*[(128.5-98.3)/98.3] = 100*(.3072) = 30.72%, or about a 31% increase

Conversely, if you are considering a move from City B to City A, how much of a cut in after-taxes income can you sustain without
reducing your present lifestyle?

100*[(City A – City B)/City b] = 100*[(98.3 – 128.5)/128.5] = 100*(-.2350) = -23.5%, or about a 24% reduction

### Data Parameters

*-* OES *-*

* number of employment
* mean annual wage
* median annual wage
* location quotient:  The location quotient is the ratio of the area concentration of occupational employment to the national average concentration. A location quotient greater than one indicates the occupation has a higher share of employment than average, and a location quotient less than one indicates the occupation is less prevalent in the area than average.

*-* Cost of living index *-*

* 100% composite index per metro urban area

### Tools
D3.js, dash or shinyR

### Deliverable
I am yet unfamiliar with D3.js but would like to take this opportunity to create a visualization using it. 
However, in case I fail to acquire the knowledge within a limited time, I am open to implementing Dash or Shiny app.

The visualization will display a geo heatmap according to the number of employment per state.
I plan to implement tooltip to provide detailed information such as the number of employment, mean and median wage per state in numeric value.
I plan to add MSA cost of living index on the map in order to provide the audience with enough information so that it is possible to assess job relocation.

In short, D3.js, Dash or ShinyR app that enables the audience to understand better of where are the area to land data scientist job while securing comfortable living when it comes to relocation.

### The value of the project
As the article `Desperate for Data Scientists` suggests, the demand for the data scientist is growing every year.
Given the hyped attraction to the Data science career in the market, this can be valuable to job seekers to properly assess their relocation options.

### References

https://spectrum.ieee.org/view-from-the-valley/at-work/tech-careers/desperate-for-data-scientists

https://www.bls.gov/oes/current/oes150000.htm#st

http://kedc.com/wp-content/uploads/2018/02/2017-Annual-Average-Index.pdf