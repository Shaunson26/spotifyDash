get_track_id <- function(result_list){
  # if class == 'recently_played'
  if ('played_at' %in% names(result_list$items[[1]])){
    out <- purrr::map_chr(result_list$items, function(x) x$track$id)
    return (out)
  }
  if ('id' %in% names(result_list$items[[1]])){
    out <- purrr::map_chr(result_list$items, function(x) x$id)
    return(out)
  }

}

