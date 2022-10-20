library(magrittr)

countries = c('AU', 'NZ', 'ES', 'GB', 'DK', 'LK')
countries <- setNames(countries, countries)
countries <- as.list(countries)

country_id = 'AU'

# 2) Get playlist song data ----
country_top50_playlists <-
  purrr::map_df(countries, get_country_top50_playlist)


# 3) Get track audio features ----
# Straight to data.frame
country_top50_track_audio_features <-
  country_top50_playlists %>%
  dplyr::distinct(track_id, .keep_all = T) %>%
  # batch calling
  dplyr::mutate(group = rep(seq(1, ceiling(dplyr::n() / 10)), each = 10)[1:dplyr::n()]) %>%
  dplyr::group_split(group) %>%
  # API and data wrangle
  purrr::map_df(function(split){
    split %>%
      dplyr::pull(track_id) %>%
      get_audio_features() %>%
      summarise_audio_features()
  })


country_top50 <-
  dplyr::left_join(country_top50_playlists,country_top50_audio_features,
                   by = c('track_id' = 'id'))

save(country_top50, file = 'country_top50_test.rdata')
