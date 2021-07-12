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
      paste('body {background-color: coral; height:100%;}',
            '.track-card:hover {transform: scale(1.02)}',
            '::-webkit-scrollbar {height: 16px;}',
            '::-webkit-scrollbar-track {background: #f1f1f1; background: white;}',
            '::-webkit-scrollbar-thumb {background: #888; background: coral;}',
            '::-webkit-scrollbar-thumb:hover {background: #555; background: steelblue;}',
            'h1 {color:white;font-size:5em;font-family:Tourney-title, sans-serif;text-align:center;}',
            'h3 {color:white;font-size:2.5em;font-family:Tourney-title}')
    ),
    id='main',
    title = 'Spotify dash',
    style = css(`max-width` = '900px', margin = 'auto',
                `font-family`= "'Tourney', sans-serif;", `font-size` = '12px'),
    h1('Your Spotify'),
    h3('Top tracks'),
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

  authModel <-
    modalDialog(
      title = 'Authorize data collection',
      'Authorise this app to collect user data - recently played',
      easyClose = TRUE,
      footer =  tagList(
        modalButton("Cancel"),
        actionButton("authOk", "OK")
      )
    )

  showModal(authModel)

  observeEvent(input$authOk, {

    removeModal()

    # * Get data ----
    get_spotify_oauth_token()

    #+ Insert error check here

    rp_df <-
      get_recently_played() %>%
      summarise_recently_played()

    rp_tf_df <-
      get_audio_features(rp_df$track_id) %>%
      summarise_audio_features()

    #+ Insert error check here

    # * plots ----
    output$audio_scatter <- renderPlotly(
      rp_tf_df %>%
        dplyr::mutate(track = 1:nrow(rp_tf_df)) %>%
        audio_scatterpolar_multiple(mode = 'lines', alpha = 0.5, add_mean = F) %>%
        config(displayModeBar = FALSE)
    )

    #+ Program this?

    #   features = c('danceability', 'energy', 'loudness', 'speechiness',
    #                'acousticness', 'instrumentalness', 'liveness', 'valence')

    output$audio_hists1 <- renderPlotly({ audio_hist(rp_tf_df$danceability, 'danceability', font.family = 'Tourney', title.font.size = 12, tickfont.size = 8)})
    output$audio_hists2 <- renderPlotly({ audio_hist(rp_tf_df$energy, 'energy', font.family = 'Tourney', title.font.size = 12, tickfont.size = 8)})
    output$audio_hists3 <- renderPlotly({ audio_hist(rp_tf_df$loudness, 'loudness', font.family = 'Tourney', title.font.size = 12, tickfont.size = 8)})
    output$audio_hists4 <- renderPlotly({ audio_hist(rp_tf_df$speechiness, 'speechiness', font.family = 'Tourney', title.font.size = 12, tickfont.size = 8)})
    output$audio_hists5 <- renderPlotly({ audio_hist(rp_tf_df$acousticness, 'acousticness', font.family = 'Tourney', title.font.size = 12, tickfont.size = 8)})
    output$audio_hists6 <- renderPlotly({ audio_hist(rp_tf_df$instrumentalness, 'instrumentalness', font.family = 'Tourney', title.font.size = 12, tickfont.size = 8)})
    output$audio_hists7 <- renderPlotly({ audio_hist(rp_tf_df$liveness, 'liveness', font.family = 'Tourney', title.font.size = 12, tickfont.size = 8)})
    output$audio_hists8 <- renderPlotly({ audio_hist(rp_tf_df$valence, 'valence', font.family = 'Tourney', title.font.size = 12, tickfont.size = 8)})

    # * cards ----
    flex_content <-
      apply(rp_df, 1, function(row){
        as.list(row) %>%
          make_track_card() }) %>%
      htmltools::tagList()

    insertUI(selector = '#track-banner',
             ui = flex_content)

  })
}

# Run app ----
shinyApp(ui = ui, server = server)
