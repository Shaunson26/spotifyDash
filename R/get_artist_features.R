#' Get artist features
#'
#' @param ids character vector, Spotify artist IDs
#' @param as.df boolean, return data.frame of results or parsed list
#' (as-is from the API call)
#' @param as.df boolean, return data.frame of results or parsed list
#' (as-is from the API call)
#'
#' @export
get_artist_features <- function(ids){

  ids <- unique(ids)

  url <- httr::parse_url('https://api.spotify.com/v1/artists')
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
