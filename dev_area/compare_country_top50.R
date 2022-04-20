
countries = c('AU', 'NZ', 'ES', 'GB', 'DK', 'LK')
countries <- setNames(countries, countries)
countries <- as.list(countries)

aa <-
  purrr::map_df(countries, function(country_id){

    message(country_id)

    country_toplists <- get_category_playlist('toplists', country_id)
    country_toplists_names <- sapply(country_toplists$playlists$items, purrr::pluck, 'name')
    grepl_top50 <- grepl('Top 50', country_toplists_names) & !grepl('Top 50 - Global', country_toplists_names)
    country_toplists_top50 <- country_toplists$playlists$items[grepl_top50][[1]]

    country_top50_id <-
      with(country_toplists_top50,
           data.frame(name = name,
                      id = id)
      )

    country_top50_playlist <- get_playlist(country_top50_id$id)

    country_top50_playlist_extracted <- extract_track_info(country_top50_playlist$tracks)
    country_top50_playlist_extracted$country <- country_top50_id$name
    country_top50_playlist_extracted$country_id <- country_id
    country_top50_playlist_extracted

  })

bb <-
  aa %>%
  dplyr::distinct(track_id, .keep_all = T) %>%
  dplyr::mutate(group = rep(seq(1, ceiling(n() / 10)), each = 10)[1:n()]) %>%
  group_split(group) %>%
  purrr::map_df(function(split){
    split %>%
      dplyr::pull(track_id) %>%
      get_audio_features() %>%
      summarise_audio_features()
  })


cc <-
  aa %>%
  left_join(bb, by = c('track_id' = 'id'))

features = c('danceability', 'energy', 'loudness', 'speechiness',
             'acousticness', 'instrumentalness', 'liveness', 'valence')

# library(MASS)
#
# dd <-
#   cc %>%
#   dplyr::select(all_of(features))
#
# for(i in seq_along(dd)){
#   dd[[i]] <- jitter(dd[[i]], amount = mean(dd[[1]] * 0.01))
# }
#
# ee <-
#   dd %>%
#   dist() %>%
#   MASS::isoMDS()
#
#
# ee$points <- as_tibble(ee$points)
# ee$points$country <- cc$country
#
# ggplot(ee$points, aes(x = V1, y = V2, colour = country)) +
#   geom_point()

library(reactable)

show_img <- function(value) {
  image <- img(src = value, alt = value, width = '100%')
  tagList(
    div(style = list(display = "inline-block"), image)
  )
}

colour_cell <- function(value) {
  normalized <- value + 1
  color <- RColorBrewer::brewer.pal(3, 'Set1')[normalized]
  list(background = color)
}


aa %>%
  dplyr::select(-c(country, track_id)) %>%
  mutate(present = 1) %>%
  tidyr::pivot_wider(names_from = country_id, values_from = present, values_fill = 0) %>%
  reactable(
    defaultColDef = colDef(
      style = function(value){
        if (!is.numeric(value)) return()
        colour_cell(value)
      },
      width = 40
    ),
    columns = list(
      track = colDef(width = 150),
      album = colDef(width = 150),
      artist = colDef(width = 150),
      track_img = colDef(cell = show_img, width = 150)
    )
  )
