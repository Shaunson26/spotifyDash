summarise_top_artists <- function(result_list){
  purrr::map_df(result_list$items, function(item){
    data.frame(artist = item$name,
               genres = paste(unlist(item$genres), collapse = ','),
               artist_id = item$id,
               artist_img = item$images[[2]]$url
    )
  })
}
