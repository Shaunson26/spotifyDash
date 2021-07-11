wordcloud <- function(features){
  features %>%
    dplyr::count(genres) %>%
    wordcloud2::wordcloud2(#color = 'blue',
      #backgroundColor = 'pink',
      #minRotation = 0, maxRotation = 0
    )
}
