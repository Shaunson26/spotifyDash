audio_hist <- function(x, title=NULL, font.family=NULL, title.font.size = 24, tickfont.size = 12){

  font.family = paste(c(font.family, '"Open Sans", verdana, arial, sans-serif'), collapse = ', ')

  hist_data <- hist(x, plot = F)

  plotly::plot_ly(x=hist_data$mids, y=hist_data$counts, type='bar') %>%
    plotly::layout(
      margin = list(l = 10, r = 10, t = 20, b = 10),
      font = list(family=font.family),
      title = list(text = title, font = list(size = title.font.size)),
      xaxis = list(visible = T,
                   tickvals = hist_data$breaks,
                   title = NULL,
                   showticklabels = TRUE,
                   tickfont = list(size = tickfont.size)),
      yaxis = list(visible = T,
                   title=NULL,
                   tickfont = list(size = tickfont.size))) %>%

    plotly::config(displayModeBar = FALSE)

}
