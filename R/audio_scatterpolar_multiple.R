audio_scatterpolar_multiple <-
  function(features, mode = 'markers+lines', alpha = 1, fill = FALSE, add_mean = TRUE){

    p <-
      features %>%
      dplyr::select(track, danceability, energy, loudness, speechiness, acousticness,
                    instrumentalness, liveness, valence) %>%
      dplyr::mutate(loudness = 1.125^(loudness),
                    track_number = dplyr::row_number()) %>%
      tidyr::pivot_longer(-c(track, track_number)) %>%
      dplyr::arrange(track_number, name) %>%
      dplyr::group_by(track_number) %>%
      dplyr::slice(1:n(),1) %>%
      dplyr::ungroup(track) %>%
      plotly::plot_ly(
        type = 'scatterpolar',
        mode = mode,
        fill = ifelse(fill, 'toself', 'none'),
        r = ~value,
        theta = ~name,
        name = ~track,
        text = ~track,
        color = I('steelblue'),
        alpha = alpha,
        hoverinfo = 'none',
        hovertemplate = '%{text} <br> %{theta} <br> r: %{r}<extra></extra>'
      )

    if (add_mean){

      p <-
        plotly::add_trace(
          data = features %>%
            dplyr::select(danceability, energy, loudness, speechiness, acousticness,
                          instrumentalness, liveness, valence, -tempo, -time_signature) %>%
            dplyr::mutate(loudness = 1.125^(loudness)) %>%
            tidyr::pivot_longer(dplyr::everything()) %>%
            dplyr::group_by(name) %>%
            dplyr::summarise(value = mean(value)),
          type = 'scatterpolar',
          mode = 'lines',
          r = ~value,
          theta = ~name,
          name = 'mean',
          color = I('red'),
          alpha = 1,
          fill = NULL)

    }
    p %>%
      layout(showlegend = FALSE,
             margin = list(t=40,l=70,b=50,r=85),
             polar = list(
               #domain = list(x = c(0, 0.5),#c(0.1, 0.9), y = c(0.1, 0.9)),
               radialaxis = list(
                 type = 'linear',
                 angle = 45,
                 showline = FALSE,
                 showticklabels = FALSE,
                 ticklen = 0,
                 showgrid = TRUE,
                 gridcolor = 'rgba(0,0,0,0.125)',
                 gridwidth = 1
               ),
               angularaxis = list(
                 visible = TRUE, # hide everything
                 color = 'black', # color everything
                 showline = FALSE, # bounding line
                 linecolor = 'black', # bounding line
                 linewidth = 1, # bounding line
                 showgrid = TRUE, # lines to labels
                 gridcolor = 'rgba(0,0,0,0.125)',
                 gridwidth = 1,
                 ticklen = 5,
                 tickwidth = 1,
                 tickcolor = 'white',
                 showticklabels = TRUE,
                 tickfont = list(family = "Tourney",
                                 color = 'black'),

                 layer = 'below traces'
               )
             )
      )
  }
