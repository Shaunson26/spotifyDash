summarise_recently_played <- function(result_list){

  track_df <-
    purrr::map_df(result_list$items, function(item){
      tibble::tibble(track = item$track$name,
                     album = item$track$album$name,
                     artist = paste(collapse = ', ', sapply(item$track$artists, purrr::pluck, 'name')),
                     played_at = convert_played_at(item$played_at),
                     track_id = item$track$id,
                     track_img = item$track$album$images[[2]]$url)
    })

  track_df$artist_id <-
    purrr::map(result_list$items, function(item){
      purrr::map_df(item$track$artists, function(artists){
        data.frame(artist = artists$name, id = artists$id)
      })
    })

  # track_df$track_img <-
  #   purrr::map(result_list$items, function(item){
  #     item$track$album$images[[2]]
  #   })

  track_df
}
