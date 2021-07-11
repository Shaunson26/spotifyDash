library(devtools)
library(magrittr)

Sys.setenv(SPOTIFY_CLIENT_ID = '010e9d1bdca144e886246a77a1b2ed67')
Sys.setenv(SPOTIFY_CLIENT_SECRET = '5efb7631c7ba48329008f98d7ba1f4b6')

document()
load_all()

get_spotify_oauth_token()

# Recently played
# track, album, artist, played_at, track_id and artist_id
rp <- get_recently_played(as.df = F)
rp_df <- summarise_recently_played(rp)


# Top tracks
# track, album, artist, track_id, artist_id
tt <- get_top_tracks(as.df = F)
tt_df <- summarise_top_tracks(tt)


# Artist
# artist, genre and artist_id
ta <- get_top_artists(as.df = F)
ta_df <- summarise_top_artists(ta)


# Artist features
af <-
  tt_df$artist_id %>%
  unlist_column() %>%
  dplyr::distinct(id) %>%
  dplyr::pull(id) %>%
  get_artist_features()

# Audio features
tf <- get_audio_features(tt_df$track_id, as.df = T)

save(rp,tt,ta,rp_df, tt_df, ta_df, af, tf, file = 'dev_area/spotify_tmp.rdata')



af_pca <-
  af %>%
  dplyr::select(danceability, energy, loudness, speechiness, acousticness,
                instrumentalness, liveness, valence, tempo, time_signature) %>%
  prcomp(scale. = TRUE)

library(ggplot2)

af_pca$x %>%
  as.data.frame() %>%
  dplyr::bind_cols(tt) %>%
  ggplot(aes(x = PC1, y = PC2, label = track)) +
  geom_hline(yintercept = 0, colour = 'grey50') +
  geom_vline(xintercept = 0, colour = 'grey50') +
  #geom_point() +
  geom_text(aes(colour = artist)) +
  ggtitle('PCA recently played')

autoplot(cc, data = bb,
         loadings = TRUE, loadings.colour = 'blue',
         loadings.label = TRUE, loadings.label.size = 3)
