
<!-- README.md is generated from README.Rmd. Please edit that file -->

# spotifyDash

<!-- badges: start -->
<!-- badges: end -->

The goal of spotifyDash is to interact with the Spotify API to obtain
data and then visualize it. Only few data selections are avaiable here
related to what goes into the dashboard.

## Installation

You can install the development version of spotifyDash with:

``` r
# install.packages("devtools")
devtools::install_github("Shaunson26/spotifyDash")
```

``` r
library(spotifyDash)
```

## API key

You need an API key and secret in order to obtain data from the Spotify
API. Follow their instructions for setup. Also have a look at the
[spotifyr package github page](https://www.rcharlie.com/spotifyr/). Add
these to your environmental variables `SPOTIFY_CLIENT_ID` and
`SPOTIFY_CLIENT_SECRET`. I’ve put mine in my user `.renviron` file.

## OAuth

You’ll next need to get an OAuth token in order get data from users.
This will result in a .httr-oauth file stored in the working directory,
and which will be used automatically with later functions.

``` r
get_spotify_oauth_token()
```

## to-do

``` r
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
```
