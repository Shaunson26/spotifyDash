get_artist_id <- function(result_list){
  # if class == 'recently_played'
  if ('played_at' %in% names(result_list$items[[1]])){
    out <-
      purrr::map(result_list$items, function(item){
        purrr::map_chr(item$track$artists, function(artist) artist$id)
      }) %>%
      unlist()
    return (out)
  }
  if ('id' %in% names(result_list$items[[1]])){
    out <-
      purrr::map(result_list$items, function(item){
        purrr::map_chr(item$artists, function(artist) artist$id)
      }) %>%
      unlist()
    return(out)
  }

}

