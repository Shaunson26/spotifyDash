audio_scatterpolar_single <- function(features){

  features_long <-
    features %>%
    dplyr::select(danceability, energy, loudness, speechiness, acousticness,
                  instrumentalness, liveness, valence, -tempo, -time_signature) %>%
    dplyr::mutate(loudness = 1.125^(loudness)) %>%
    tidyr::pivot_longer(tidyr::everything())

  plotly::plot_ly(data = features_long,
                  type = 'scatterpolar',
                  mode = 'markers+lines',
                  fill = 'toself',
                  r = ~value,
                  theta = ~name,
                  hoverinfo = 'text',
                  hovertemplate = '%{theta} <br> r: %{r}<extra></extra>')  %>%
    plotly::layout(
      polar = list(
        domain = list(
          x = c(0.1, 0.9),
          y = c(0.1, 0.9)
        ),
        radialaxis = list(
          type = 'linear',
          angle = 45,
          showline = FALSE,
          showticklabels = FALSE,
          ticklen = 0,
          showgrid = TRUE,
          gridcolor = 'pink',
          gridwidth = 2
        ),
        angularaxis = list(
          tickwidth = 2,
          linewidth = 3,
          layer = 'below traces'
        )
      )
    )
}
