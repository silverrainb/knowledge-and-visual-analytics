## 20181215
## Load Libraries
if (!require('shiny')) install.packages('shiny')
if (!require('data.table')) install.packages('data.table')
if (!require('dplyr')) install.packages('dplyr')
if (!require('DT')) install.packages('DT')
if (!require('ggplot2')) install.packages('ggplot2')
if (!require('xts')) install.packages('xts')
if (!require('leaflet')) install.packages('leaflet')
if (!require('RColorBrewer')) install.packages('RColorBrewer')
if (!require('scales')) install.packages('scales')
if (!require('lattice')) install.packages('lattice')

## Data ###########################################
raw.data <- read.csv('https://raw.githubusercontent.com/silverrainb/knowledge-and-visual-analytics/master/final/data.csv', 
                     stringsAsFactors = FALSE, header = TRUE)

## UI ###########################################

# Choices for drop-downs
vars <- c(
  "Annual Mean Wage" = "AnnualMeanWage",
  "Annual Median Wage" = "AnnualMedianWage",
  "Population" = "Population",
  "Employment" = "Employment",
  "Employment per 1000" = "EmploymentPer1000",
  "Location Quotient" = "Location.Quotient",
  "Cost of living index" = "CostOfLivingIndex"
)

ui <- navbarPage(
  
  title = "Computer-Math Job Relocation Estimator", id="nav",
  # # # # Page 1
  tabPanel("Interactive map",
           div(class="outer",
               
               tags$head(
                 # Include our custom CSS
                 includeCSS("style.css"),
                 includeScript("gomap.js")
               ),
               
               # If not using custom CSS, set height of leafletOutput to a number instead of percent
               leafletOutput("map", width="100%", height="100%"),
               
               # Shiny versions prior to 0.11 should use class = "modal" instead.
               absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                             draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                             width = 330, height = "auto",
                             
                             h2("Cost Index Explorer"),
                             
                             selectInput(inputId = "Location", 
                                         label = "Present Location", 
                                         choices = raw.data$UrbanArea,
                                         selected = "Milwaukee"),
                             selectInput(inputId = "reLocation",
                                         label = "Prospect Location",
                                         choices = raw.data$UrbanArea,
                                         selected = "Austin"),
                             
                             textOutput("p2"),
                             tags$head(tags$style("#p2{color: red;
                                                    font-size: 15px;
                                                    font-style: italic;
                                                  }")
                             ),
                             
                             plotOutput("g1", height = 200),
                             plotOutput("g2", height = 200),
                             
                             selectInput(inputId = "color",
                                         label = "Graph by Color",
                                         choices = vars),

                             selectInput(inputId = "size",
                                         label = "Graph by Size",
                                         choices = vars)
               )
           )
  ),

  # # # # Page 2
  tabPanel("Final Write-up",
           
           fluidRow(
                    column(12,
                    
                    h3("Knowledge & Visual Analytics"),
                    h4("Rose Koh, Fall 2018, CUNY DATA 608"),
                    
                    #
                    h3("Data Source"),
                    div(HTML("<a href='https://www.bls.gov/oes/current/oes150000.htm#st'>Occupational Employment Statistics</a>")),
                    p("The Bureau of Labor Statistics collated Occupational Employment Statistics. 
                      The data I obtained to leverage is limited to 15-0000 Computer and Mathematical Occupations (Major Group) in May 2017. 
                      These estimates are calculated with data collected from employers in all industry sectors, 
                      all metropolitan and non-metropolitan areas, and all states and the District of Columbia."),
                    
                    div(HTML("<a href='https://www2.census.gov/library/publications/2011/compendia/statab/131ed/tables/12s0728.xls'>Cost of living index</a>")),
                    p("The Cost of Living Index measures relative price levels for consumer goods and services in participating areas. 
                       The average for all participating places, both metropolitan and nonmetropolitan, equals 100, 
                      and each participant's index is read as a percentage of the average for all places."),
                    
                    div(HTML("<a href='https://www.moving.com/tips/the-top-10-largest-us-cities-by-population/'>US cities by population</a>")),
                    
                    #
                    h3("Presentation"),
                    p("The visualization is based on the premise that the OES data for Computer and Math-related occupations is representative of the Data Science profession and presents the map of the US with the following information: Median annual wage, Mean annual wage, Population, Employment, Employment per 1000,  Location Quotient and Cost of living index.
                       The Location Quotient is the ratio of the area concentration of occupational employment to the national average concentration. A location quotient greater than one indicates the occupation has a higher share of employment than average, and a location quotient less than one indicates the occupation is less prevalent in the area than average.
                       The visualization plots top 50 Urban Areas sorted by population with detailed information inside a tooltip which is accessible by click. The estimator calculates costs of relocation by calculating the standard of living comparing present and prospect of location and provides an instant statement.
                       The tooltip includes information in text and you can access the information by clicking the circles on the map. On the bottom of the Cost Index Explorer panel, you have an option to view the graph by Color or Size of drop-down variables."),
                    
                    #
                    h3("The Value Of This Work"),
                    p("This information may be helpful for those who are looking for relocation in Computer and Mathematical Occupations. While some aspects of the display are not particularly insightful, the estimator gives meaningful information comparing Urban areas with cost of living index. 

                      This visualization has some room for improvement by including more areas and providing catchy visuals for the cost of living estimator instead of using texts. Another idea is to come up with some kind of score that calculates according to users' preferences or priorities when it comes to relocation."),
                    
                    #
                    h3("Source Code"),
                    div(HTML("<a href='github url</a>")),
                    
                    #
                    h3("References"),
                    div(HTML("<a href='https://github.com/rstudio/shiny-examples/tree/master/063-superzip-example'>Shiny-R SuperZip Example</a>"))
                    )
          )
  )
)

## Define server logic required to draw a histogram ############################################

server <- function(input, output, session) {
  
  df <- reactive({
    raw.data
  })
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = -93.85, lat = 37.45, zoom = 4)
  })
  
  LocationCost <- reactive({
    raw.data[raw.data$UrbanArea == input$Location,]$CostOfLivingIndex
  })
  
  reLocationCost <- reactive({
    raw.data[raw.data$UrbanArea == input$reLocation,]$CostOfLivingIndex
  })
  
  output$p2 <- renderText({
    if (LocationCost() < reLocationCost()) {
      calc <- round(100* ((reLocationCost()-LocationCost())/LocationCost()), 2)
      print(paste0("You need ", calc, "% of increase in after-tax income in order to maintain your current standard of living."))
    } else {
      calc <- round(100 * ((LocationCost()-reLocationCost())/reLocationCost()), 2)
      print(paste0("You can sustain your current standard of living with ", calc, "% of reduction in after-tax income."))
    }
  })
  # 
  # output$g1 <- renderPlot({
  #   hist(df()$AnnualMeanWage,
  #        main = "Annual Mean Wage Histogram",
  #        xlab = "Percentile",
  #        xlim = range(raw.data$AnnualMeanWage),
  #        col = '#00DD00',
  #        border = 'white')
  # })
  
  output$g1 <- renderPlot({
    ggplot(data = df(), aes(x = AnnualMeanWage, y = ..density..)) +
      geom_histogram(fill='red', alpha=0.5) +
      geom_density() +
      labs(x = "Annual Mean Wage", title = "Annual Mean Wage Distribution")
  })
  
  output$g2 <- renderPlot({
    print(ggplot(data = df(), aes(x = AnnualMedianWage, y = CostOfLivingIndex)) + 
            geom_point(size = I(2), alpha =0.5) +
            scale_y_continuous(labels = comma) +
            geom_text(aes(label = UrbanArea), size = 2.5, angle = 45, color = 'red') +
            guides(fill = FALSE) +
            labs(x = "Annual Median Wage", 
                 y = "Cost of living index", 
                 title = "Median Wage Vs Cost Of Living Index"))
  })
  
  # This observer is responsible for maintaining the circles and legend,
  # according to the variables the user has chosen to map to color and size.
  observe({
    colorBy <- input$color
    sizeBy <- input$size
    
    colorData <- raw.data[[colorBy]]
    pal <- colorBin("viridis", colorData, 15, pretty = FALSE)
    radius <- raw.data[[sizeBy]] / max(raw.data[[sizeBy]]) * 200000
    
    leafletProxy("map", data = raw.data) %>%
      clearShapes() %>%
      addCircles(~Longitude, ~Latitude, radius=radius, layerId=~UrbanArea,# TODO
                 stroke=FALSE, fillOpacity=0.4, fillColor=pal(colorData)) %>%
      addLegend("bottomleft", pal=pal, values=colorData, title=colorBy,
                layerId="colorLegend")
  })
  
  # Show a popup at the given location
  showPopup <- function(UrbanArea, lat, lng) {
    selectedUrbanArea <- raw.data[raw.data$UrbanArea == UrbanArea,]
    
    content <- as.character(tagList(
      tags$h5(paste0(selectedUrbanArea$UrbanArea, ", ", selectedUrbanArea$State)),
      tags$strong(HTML(sprintf("%s, %s",
                               selectedUrbanArea$UrbanArea.x, selectedUrbanArea$State.x
      ))),
      sprintf("Median Annual Wage: %s", dollar(selectedUrbanArea$AnnualMedianWage)), tags$br(),
      sprintf("Employment per 1000: %s", as.integer(selectedUrbanArea$EmploymentPer1000)), tags$br(),
      sprintf("Location Quotient: %s", as.numeric(selectedUrbanArea$Location.Quotient)), tags$br(),
      sprintf("Population: %s", selectedUrbanArea$Population)
    ))
    leafletProxy("map") %>% addPopups(lng, lat, content, layerId = UrbanArea)
  }
  
  # When map is clicked, show a popup with city info
  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_shape_click
    if (is.null(event))
      return()
    
    isolate({
      showPopup(event$id, event$lat, event$lng)
    })
  })
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

