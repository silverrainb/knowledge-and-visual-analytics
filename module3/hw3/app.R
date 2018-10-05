# DATA608 Module 3 shiny app project

## Load Libraries
if (!require('shiny')) install.packages('shiny')
if (!require('dplyr')) install.packages('dplyr')
if (!require('googleVis')) install.packages('googleVis')

# load libraries and get data
source('global.R')

# Define UI
ui <- fluidPage(
  
  # App title ----
  h2
  ("Explore the Underlying Cause of Death database provided by CDC"),
  
  h4("Rose Koh, Fall 2018"),
  
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      conditionalPanel(
        'input.dataset === "Q1"',
        selectInput('cause', 'ICD Chapter', sub1$cause),
        p("Select cause of death to compare crude mortality rates across different US States.")
      ),
      
      conditionalPanel(
        'input.dataset === "Q2"',
        selectInput('cause2', 'ICD Chapter', raw.data$ICD.Chapter),
        selectInput('state', 'State', raw.data$State),
        p("Select cause of death and state to compare crude mortality rates for that US state to the US national average.")
      )
    ),
    
    # Main panel for displaying outputs ----    
    mainPanel(
      tabsetPanel(
        id = 'dataset',
        
        tabPanel("Q1",
                 br(),
                 p("Please select ICD Chapter in the sidebar to view the chart."),
                 p("As a researcher, you frequently compare mortality rates from particular causes across different States. You need a visualization that will let you see (for 2010 only) the crude mortality rate, across all States, from one cause (for example, Neoplasms, which are effectively cancers). Create a visualization that allows you to rank States by crude mortality for each cause of death."),
                 br(),
                 htmlOutput('plot1')),
        
        tabPanel("Q2",
                 br(),
                 p("Please select ICD Chapter and State in the sidebar to view the chart."),
                 p("Often you are asked whether particular States are improving their mortality rates (per cause) faster than, or slower than, the national average. Create a visualization that lets your clients see this for themselves for one cause of death at the time. Keep in mind that the national average should be weighted by the national population."),
                 br(),
                 htmlOutput('plot2'))
      )
    )
  ),
  
  fluidRow(
    column(12,
           h4("Data Source: Centers for Disease Control and prevention"),
           helpText(
             a(href="https://wonder.cdc.gov/wonder/help/ucd.html#", target="_blank", "CDC-WONDER")
           )
    )
  )
)


# Define server logic
server <- function(input, output, session) {
  
  # create data for Q1 ---
  q1.data <- reactive({
    sub1[sub1$cause == input$cause, ]
  })
  
  # create data for Q2 ---
  q2.data <- reactive({
    df <- sub2 %>%
      filter(cause == input$cause2 & state == input$state) %>%
      select(Year, State.Avg, Nat.Avg)
  })
  
  # create plot 1 ---   
  output$plot1 <- renderGvis({
    q1.title <- paste0("Cause: ", input$cause)
    gvisBarChart(q1.data(), 
                    options=list(title=q1.title, 
                                 legend="none",
                                 hAxis="{title:'Crude Rate'}",
                                 vAxis="{title:'State', fontSize:1, showTextEvery:1, gridlines:50}",
                                 height = 1000)
                   ) #gvisColumnChart
  })
  
  # create plot 2 ---
  output$plot2 <- renderGvis({
    q2.title <- paste0("State: ", input$state, " | Cause: ", input$cause2)
    gvisAreaChart(q2.data(), 
                  options=list(title=q2.title, hAxis="{format:'####'}"))
  })
  
}


shinyApp(ui, server)