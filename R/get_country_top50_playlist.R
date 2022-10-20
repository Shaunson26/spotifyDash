#' Get country top 50 playlist
#'
#' @param country_id character, two letter country abbreivation
get_country_top50_playlist <- function(country_id) {

  message(country_id)

  # Get playlist ID
  country_toplists <- get_category_playlist('toplists', country_id)
  country_toplists_names <- sapply(country_toplists$playlists$items, purrr::pluck, 'name')
  grepl_top50 <- grepl('Top 50', country_toplists_names) & !grepl('Top 50 - Global', country_toplists_names)
  country_toplists_top50 <- country_toplists$playlists$items[grepl_top50][[1]]

  country_top50_id <-
    with(country_toplists_top50,
         data.frame(name = name,
                    id = id)
    )

  # Get playlist track data
  country_top50_playlist <- get_playlist(country_top50_id$id)
  country_top50_playlist_extracted <- extract_track_info(country_top50_playlist$tracks)

  # Output
  country_top50_playlist_extracted$country <- country_top50_id$name
  country_top50_playlist_extracted$country_id <- country_id

  country_top50_playlist_extracted

}
