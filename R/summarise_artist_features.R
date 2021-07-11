summarise_artist_features <- function(result_list){

  purrr::map_df(result_list$artists, function(artist){
    name <- artist$name
    genres <- unlist(artist$genres)
    if (length(genres) == 0) genres <- 'unknown'
    data.frame(name = name, genres = genres)
  })

}
