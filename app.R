#Create shiny app---------------------------------------------------
pacman::p_load(
  shiny,
  bslib,
  ggpubr,
  ggplot2,
  bs4Dash
)

source("clean.R")

#Define UI for application that draws interactive bar chart 
ui <- fluidPage(
  
  titlePanel("Vector control in dengue fever management"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("area_type","Area type",levels(dengue_infr$area_type))
    ),
    mainPanel(
      navset_card_underline(
        nav_panel("Data visualization", titlePanel("Data visualization"), plotOutput("BarChart")),
        nav_panel("Interpretation", titlePanel("Interpretation"), plotOutput("BarChart")),
        nav_panel("Recommendation", titlePanel("Recommendation"), plotOutput("BarChart"))
      ),
      p("Graph description"),
      tags$ul(
        tags$li(tags$b("Area"), " - the are of Dhaka district were dengue fever cases have been confirmed"),
        tags$li(tags$b("area_type"), " - the area type the case was confirmed"),
        tags$li(tags$b("house_type"), " - the house type the case was confirmed")
      )
    )
  )
)



#Create server function
server <- function(input, output) {
  filteredData <- reactive({
    dengue_infr <- dengue_infr %>% filter(area_type == input$area_type)
    return(dengue_infr)  # Add this line to return the filtered data
  })
  
  output$barChart <- renderPlot({
    ggplot(filteredData(), aes(x = area, fill = house_type)) +
      geom_bar() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      labs(title = "Number of cases by area",
           x = "Area",
           y = "Cases",
           fill = "House type")
  })
}


# Run the Shiny app
shinyApp(ui = ui, server = server)
