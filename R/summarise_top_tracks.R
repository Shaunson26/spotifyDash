summarise_top_tracks <- function(result_list){

  track_df <-
    purrr::map_df(result_list$items, function(item){
      tibble::tibble(track = item$name,
                     album = item$album$name,
                     artist = paste(collapse = ', ', sapply(item$artists, purrr::pluck, 'name')),
                     track_id = item$id,
                     track_img = item$album$images[[2]]$url)
    })

  track_df$artist_id <-
    purrr::map(result_list$items, function(item){
      purrr::map_df(item$artists, function(artists){
        data.frame(artist = artists$name, id = artists$id)
      })
    })

  # track_df$track_img <-
  #   purrr::map(result_list$items, function(item){
  #     item$album$images[[2]]
  #   })

  track_df
}
