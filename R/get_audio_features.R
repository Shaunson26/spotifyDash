#' Get audio features from Spotify IDs
#'
#' Get audio features from Spotify IDs
#'
#' @param ids character vector, Spotify track IDs
#'
#' @export
get_audio_features <- function(ids){

  url <- httr::parse_url('https://api.spotify.com/v1/audio-features')
  url$query <- base::list(ids=base::paste(ids, collapse = ','))
  url <- httr::build_url(url)

  response <-
    httr::RETRY(verb = 'GET',
                url =  url,
                config = httr::config(token = get_spotify_oauth_token()),
                encode = 'json')

  httr::stop_for_status(response)

  httr::content(response)

}
