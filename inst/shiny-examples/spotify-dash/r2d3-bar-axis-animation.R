library(shiny)
library(r2d3)

ui <- 
  fluidPage(style='overflow: hidden',
            tags$head(
              tags$link(rel = "stylesheet", type = "text/css", href = "w3.css"),
            )
            ,
            h1('r2d3 example'),
            div(class='w3-container w3-padding w3-light-grey w3-round-xlarge w3-margin',
                sliderInput("bar_max", label = "Randomise with max value of:",
                            min = 0, max = 5, value = 2.5, step = 0.5,
                            width = '100%')
            )
            ,
            div(class='w3-container w3-card w3-margin', style='padding-left:0;',
                d3Output(outputId = "d3", width = '100%')
            )
  )

server <- function(input, output) {
  
  data <- reactive({
    # data.frame(grp = sample(LETTERS[1:5]),
    #            value = round(runif(n = 5, min = 0, input$bar_max), 1))
    
    hist_data <- hist(rnorm(100, mean = input$bar_max), plot = F)
    
    data.frame(grp = hist_data$mids,
               value = hist_data$counts)
  })

  output$d3 <- renderD3({
    r2d3(data(),
      script = 'r2d3-plot.js'
    )
  })
}

shinyApp(ui = ui, server = server)