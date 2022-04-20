extract_track_info <- function(tracks_list){
  purrr::map_df(tracks_list$items, function(item){
    tibble::tibble(track = item$track$name,
                   album = item$track$album$name,
                   artist = paste(collapse = ', ', sapply(item$track$artists, purrr::pluck, 'name')),
                   # played_at = convert_played_at(item$played_at),
                   track_id = item$track$id,
                   track_img = item$track$album$images[[2]]$url)
  })
}
