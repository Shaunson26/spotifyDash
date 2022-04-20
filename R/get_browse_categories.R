get_browse_categories <- function(country, limit = 20){
  url <- httr::parse_url('https://api.spotify.com/v1/browse/categories')
  url$query <- list(country=country, limit=limit)
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

# aa <- get_browse_categories('AU')
# aa$message
# aa$categories$items[[1]]
# sapply(aa$categories$items, purrr::pluck, 'id')
