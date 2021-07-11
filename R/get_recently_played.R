#' Get recently played tracks
#'
#' Get recently played tracks
#'
#' @param limit numeric, limit the number of records returned (max = 50)
#' @param before numeric, recently played tracks before this time (in milliseconds UTC)
#' @param after numeric, recently played tracks after this time (in milliseconds UTC)
#'
#' @return parsed list from the GET
get_recently_played <- function(limit=50, before=NULL, after=NULL){

  url <- httr::parse_url('https://api.spotify.com/v1/me/player/recently-played')
  url$query <- list(limit=limit, before=before, after=after)
  url <- httr::build_url(url)

  response <-
    httr::RETRY(verb = 'GET',
                url =  url,
                config = httr::config(token = get_spotify_oauth_token()),
                encode = 'json')

  # I believe RETRY throw R messages/errors from status codes
  httr::stop_for_status(response)
  # else return the response
  httr::content(response)

}




