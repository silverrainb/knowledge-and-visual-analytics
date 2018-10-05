## DATA 608 module 3

## Get data from url and save it as .rds
if (!file.exists('data.rds')) {
  raw.data <- read.csv('https://raw.githubusercontent.com/charleyferrari/CUNY_DATA608/master/lecture3/data/cleaned-cdc-mortality-1999-2010-2.csv', 
                       stringsAsFactors = FALSE)
  saveRDS(raw.data, 'data.rds')
} else {
  raw.data <- readRDS('data.rds')
}

## Subset for Q1
sub1 <- raw.data %>%
  filter(Year == 2010) %>%
  select(State, Crude.Rate, ICD.Chapter) %>%
  rename('state' = 'State', 'rate' = 'Crude.Rate', 'cause' = 'ICD.Chapter') %>%
  arrange(rate)

## Subset for Q2
sub2 <- raw.data %>%
  group_by(ICD.Chapter, Year) %>%
  mutate(Nat.Avg = round((sum(Deaths) / sum(Population)) * 100000, 1)) %>%
  select(ICD.Chapter, State, Year, Crude.Rate, Nat.Avg) %>%
  rename('state' = 'State', 'cause' = 'ICD.Chapter', 'State.Avg' = 'Crude.Rate') %>%
  ungroup()

## References
# https://shiny.rstudio.com/images/shiny-cheatsheet.pdf
# https://www.youtube.com/watch?v=Gyrfsrd4zK0
# https://www.analyticsvidhya.com/blog/2016/10/creating-interactive-data-visualization-using-shiny-app-in-r-with-examples/
# https://developers.google.com/chart/interactive/docs/customizing_axes
# https://cran.r-project.org/web/packages/googleVis/googleVis.pdf
# https://cran.r-project.org/web/packages/googleVis/vignettes/googleVis_examples.html
