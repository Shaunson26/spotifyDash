library(shiny)
library(dplyr)
library(plotly)
library(htmltools)
#library(spotifyDash)

# load(here::here('dev_area/spotify_tmp.rdata'))
#
# for(i in list.files(here::here('R/'))){
#   source(here::here(paste0('R/', i)))
#   rm(i)
# }

# UI ----
ui <-
  fluidPage(
    tags$head(htmltools::includeCSS('www/font.css')),
    tags$style(
      paste('body {background-color: coral; height:100%; padding: 4px}',
            '.track-card:hover {transform: scale(1.02)}',
            '::-webkit-scrollbar {height: 16px;}',
            '::-webkit-scrollbar-track {background: #f1f1f1; background: white;}',
            '::-webkit-scrollbar-thumb {background: #888; background: coral; border: 1px steelblue solid;}',
            '::-webkit-scrollbar-thumb:hover {background: #555; background: steelblue;}',
            'h1 {color:white;font-size:5em;font-family:Tourney-title, sans-serif;text-align:center;}',
            'h3 {color:white;font-size:2.5em;font-family:Tourney-title}')
    ),
    id='main',
    title = 'Spotify dash',
    style = css(`max-width` = '900px', margin = 'auto',
                `font-family`= "'Tourney', sans-serif;", `font-size` = '12px'),
    h1('Top 50 audio features'),
    fluidRow(
      shiny::selectInput(inputId = 'country_selected', label = 'country',
                         choices = c('AU', 'NZ', 'ES', 'GB', 'DK', 'LK'))
    ),
    fluidRow(style = css(padding = '16px', border = '0px solid black',`border-radius` = '5px 5px 50px 50px ',`background-color` = 'white', overflow = 'hidden'),
             column(width = 6,
                    style = 'margin: 0px;',
                    plotlyOutput('audio_scatter', width = '100%')),
             column(width = 6,
                    style = css(`margin-top` = '16px'),
                    fluidRow(column(6, plotlyOutput('audio_hists1', height = '100px')),
                             column(6, plotlyOutput('audio_hists2', height = '100px'))),
                    fluidRow(column(6, plotlyOutput('audio_hists3', height = '100px')),
                             column(6, plotlyOutput('audio_hists4', height = '100px'))),
                    fluidRow(column(6, plotlyOutput('audio_hists5', height = '100px')),
                             column(6, plotlyOutput('audio_hists6', height = '100px'))),
                    fluidRow(column(6, plotlyOutput('audio_hists7', height = '100px')),
                             column(6, plotlyOutput('audio_hists8', height = '100px'))),
             )
    ),
    br(),
    fluidRow(style = css(`border-radius` = '50px 50px 5px 5px',`background-color` = 'white'),
             tags$div(id='track-banner', style = css(display = 'flex',
                                                     `overflow-x` = 'scroll',
                                                     `overflow-y` = 'hidden',
                                                     margin = '16px',
                                                     `min-height` = '175px',
                                                     `margin-bottom` = 0,
                                                     `padding-bottom` = '8px')
                      # cards insert here
             )
    )
  )

# Server ----
server <- function(input, output, session) {

  message('Spotify starting')

  countries = c('AU', 'NZ', 'ES', 'GB', 'DK', 'LK')
  countries <- setNames(countries, countries)
  countries <- as.list(countries)

  # Download wrangle
  # 2) Get playlist song data ----

  # country_top50_playlists <-
  #   purrr::map_df(countries, get_country_top50_playlist)
  #
  #
  # # 3) Get track audio features ----
  # # Straight to data.frame
  # country_top50_track_audio_features <-
  #   country_top50_playlists %>%
  #   dplyr::distinct(track_id, .keep_all = T) %>%
  #   # batch calling
  #   dplyr::mutate(group = rep(seq(1, ceiling(dplyr::n() / 10)), each = 10)[1:dplyr::n()]) %>%
  #   dplyr::group_split(group) %>%
  #   # API and data wrangle
  #   purrr::map_df(function(split){
  #     split %>%
  #       dplyr::pull(track_id) %>%
  #       get_audio_features() %>%
  #       summarise_audio_features()
  #   })
  #
  #
  # country_top50 <-
  #   dplyr::left_join(country_top50_playlists, country_top50_track_audio_features,
  #                    by = c('track_id' = 'id'))
  #
  # save(country_top50, file = 'country_top50_test.rdata')
  message('data downloaded')

  #countries_top50 <- readRDS(file = 'inst/shiny-examples/spotify-shiny-dash/countries_top50_test.rds')
  countries_top50 <- readRDS(file = 'countries_top50_test.rds')

  # Select on wrangled data
  country_top50 <-
    reactive({
      message('filtering data')

      #country_id_selected = 'AU'
      country_id_selected <- input$country_selected

      countries_top50 %>%
        dplyr::filter(country_id == country_id_selected)

    }) %>%
    bindEvent(input$country_selected)

  observeEvent(country_top50(), {

    message('building visualisation')

    output$audio_scatter <- renderPlotly(
      #country_top50() %>%
        countries_top50 %>%
        dplyr::mutate(track = 1:dplyr::n()) %>%
        audio_scatterpolar_multiple(mode = 'lines', alpha = 0.25, add_mean = F) %>%
        config(displayModeBar = FALSE)
    )

    features = c('danceability', 'energy', 'loudness', 'speechiness',
                 'acousticness', 'instrumentalness', 'liveness', 'valence')

    output$audio_hists1 <- renderPlotly({ audio_hist(country_top50()$danceability, 'danceability', font.family = 'Tourney', title.font.size = 12, tickfont.size = 8)})
    output$audio_hists2 <- renderPlotly({ audio_hist(country_top50()$energy, 'energy', font.family = 'Tourney', title.font.size = 12, tickfont.size = 8)})
    output$audio_hists3 <- renderPlotly({ audio_hist(country_top50()$loudness, 'loudness', font.family = 'Tourney', title.font.size = 12, tickfont.size = 8)})
    output$audio_hists4 <- renderPlotly({ audio_hist(country_top50()$speechiness, 'speechiness', font.family = 'Tourney', title.font.size = 12, tickfont.size = 8)})
    output$audio_hists5 <- renderPlotly({ audio_hist(country_top50()$acousticness, 'acousticness', font.family = 'Tourney', title.font.size = 12, tickfont.size = 8)})
    output$audio_hists6 <- renderPlotly({ audio_hist(country_top50()$instrumentalness, 'instrumentalness', font.family = 'Tourney', title.font.size = 12, tickfont.size = 8)})
    output$audio_hists7 <- renderPlotly({ audio_hist(country_top50()$liveness, 'liveness', font.family = 'Tourney', title.font.size = 12, tickfont.size = 8)})
    output$audio_hists8 <- renderPlotly({ audio_hist(country_top50()$valence, 'valence', font.family = 'Tourney', title.font.size = 12, tickfont.size = 8)})

    # * cards ----
    flex_content <-
      apply(country_top50(), 1, function(row){
        as.list(row) %>%
          make_track_card() }) %>%
      htmltools::tagList()

    removeUI(selector = '.track-card', multiple = TRUE)

    insertUI(selector = '#track-banner',
             ui = flex_content)


  })


}

# Run app ----
shinyApp(ui = ui, server = server)
