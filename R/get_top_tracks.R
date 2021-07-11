#' Get top tracks
#'
#' Get top tracks for a given term
#'
get_top_tracks <- function(term = c('short', 'medium', 'long'), limit=50, offset=0, as.df = TRUE){

  term <- term[1]

  url <- httr::parse_url('https://api.spotify.com/v1/me/top/tracks')
  url$query <- list(limit=limit, time_range=paste0(term,'_term'), offset=offset)
  url <- httr::build_url(url)

  response <-
    httr::RETRY(verb = 'GET',
                url =  url,
                config = httr::config(token = get_spotify_oauth_token()),
                encode = 'json')

  httr::stop_for_status(response)

  httr::content(response)

}
