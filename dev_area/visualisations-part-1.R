library(devtools)
library(magrittr)
library(plotly)
library(networkD3)
library(kableExtra)
library(dplyr)

load('spotify_tmp.rdata')

load_all()


# Recently played
rp %>%
  kable() %>%
  kable_styling()


audio_scatterpolar_single(slice(tf, 2))
audio_scatterpolar_multiple(tf)
network_graph(af)
wordcloud(af)

rank_genres(af$genres)

af %>%
  dplyr::mutate(genres = rank_genres(genres)) %>%
  dplyr::distinct() %>%
  network_graph()



af$genres %>% grep('rap$', ., value = T)


af %>%
  dplyr::mutate(genres = rank_genres(genres)) %>%
  dplyr::distinct() %>%
  dplyr::mutate(present = 1) %>%
  tidyr::pivot_wider(names_from = 'genres', values_from = 'present', values_fill = list(present = 0)) %>%
  as.data.frame() %>%
  set_rownames(value = .$name) %>%
  dplyr::select(-name) %>%
  t() %>%
  pheatmap::pheatmap(clustering_method = 'average')

af %>%
  dplyr::mutate(present = 1) %>%
  ggplot(aes(x = name, y = genres, z = present)) +
  geom_tile()



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
