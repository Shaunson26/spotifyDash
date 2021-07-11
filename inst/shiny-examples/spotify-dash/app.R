## app.R ##
library(shiny)
library(r2d3)

ui <- fluidPage(
  fluidRow(
    sliderInput('mean', 'Mean', value = 2.5, min = 0, max = 5, step = 0.1)
  ),
  fluidRow(
    d3Output(outputId = "hist", width = '100%')
  ),
  fluidRow(
    column(12, id='banner')
  ),
  tags$script('')
)

server <- function(input, output) {

  data <- reactive({

    hist_data <- hist(rnorm(100, mean = 5), plot = F)
    aa <- data.frame(x = hist_data$mids,
                     y = hist_data$counts)
    aa$id <- 1:nrow(aa)
    aa
  })

  divs <-
    lapply(aa$id, function(i){
      tags$div(id = i,
               style='height:50px;width:50px;background-color:pink;display:inline-block;',
               onmouseover="console.log(this.id)",
               i)
    })



  insertUI('#banner', ui = tagList(divs))


  output$hist <- r2d3::renderD3({
    r2d3(data = data(),
         script = 'r2d3-vertical-barplot.js'
         #script = 'inst/shiny-examples/spotify-dash/r2d3-vertical-barplot.js'
    )
  })

}


shinyApp(ui, server)
