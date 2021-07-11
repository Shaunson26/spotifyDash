library(devtools)
library(magrittr)

#load('dev_area/spotify_tmp.rdata')

document()
load_all()

get_spotify_oauth_token()

# GET TRACK DATA ----
# Recently played, top tracks, playlist tracks

# * Recently played ----
# item[[i]]$track$name
# track, album, artist, played_at, track_id and artist_id
rp <- get_recently_played()
rp_df <- summarise_recently_played(rp)

# * Top tracks ----
# item[[i]]$name
# track, album, artist, track_id, artist_id
tt <- get_top_tracks()
tt_df <- summarise_top_tracks(tt)

# * Playlist tracks ----
# [to-do]

# GET AUDIO FEATURES ----
# tf = track features
rp_tf <-
get_track_id(rp) %>%
  get_audio_features()

rp_tf_df <-
  rp_tf %>%
  summarise_audio_features()

tt_tf <-
  get_track_id(tt) %>%
  get_audio_features()

tt_tf_df <-
  tt_tf %>%
  summarise_audio_features()

# GET ARTIST GENRES ----
rp_af <-
  get_artist_id(rp) %>%
  get_artist_features()


tt_af <-
  get_artist_id(tt) %>%
  get_artist_features()

rp_af_df <- summarise_artist_features(rp_af)
tt_af_df <- summarise_artist_features(tt_af)

##
save(rp,tt,rp_tf,rp_af, tt_tf, tt_af, file='dev_area/spotify_tmp.rdata')
##

# Dash components
document()

as.list(rp_df[6,]) %>%
  make_track_card()

apply(rp_df, 1, function(row){ as.list(row) %>% make_track_card()}) %>% htmltools::tagList()


audio_hist(rp_tf_df$danceability)






# GET TOP ARTISTS ----

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



save(rp,tt,ta,rp_df, tt_df, ta_df, af, tf, file = 'spotify_tmp.rdata')



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
