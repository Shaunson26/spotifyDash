get_category_playlist <- function(category_id, country, limit = 20){

  url <- httr::parse_url(sprintf('https://api.spotify.com/v1/browse/categories/%s/playlists', category_id))
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
