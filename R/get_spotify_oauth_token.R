#' Get Spotify OAuth 2.0 token
#'
#' This function creates a Spotify authorization code.
#' See \code{httr::\link[httr]{oauth2.0_token}}.
#'
#' @param client_id Defaults to System Envioronment variable "SPOTIFY_CLIENT_ID"
#' @param client_secret Defaults to System Envioronment variable "SPOTIFY_CLIENT_SECRET"
#' @param scope Space delimited string of spotify scopes,
#' found here: https://developer.spotify.com/documentation/general/guides/scopes/.
#' All scopes are selected by default
#' @export
#' @return The Spotify Web API Token2.0 reference class object (see
#'  \code{httr::\link[httr]{oauth2.0_token}}), or an error message.
#' @examples
#' \donttest{
#' authorization <- get_spotify_authorization_code()
#' }

get_spotify_oauth_token <-
  function(client_id, client_secret, scope = c('user-read-recently-played', 'user-top-read'), cache = TRUE, show = TRUE) {

    if (missing(client_id)){
      client_id = Sys.getenv("SPOTIFY_CLIENT_ID")
      if (client_id == ''){
        stop("Sys.getenv('SPOTIFY_CLIENT_ID') = ''")
      }
    }

    if (missing(client_secret)){
      client_secret = Sys.getenv("SPOTIFY_CLIENT_SECRET")
      if (client_secret == ''){
        stop("Sys.getenv('SPOTIFY_CLIENT_SECRET') = ''")
      }
    }

    # Describe an endpoint
    endpoint <-
      httr::oauth_endpoint(authorize = 'https://accounts.spotify.com/authorize',
                           access = 'https://accounts.spotify.com/api/token')

    app <-
      httr::oauth_app('projSpotify',
                      key = client_id,
                      secret = client_secret)

    # is this needed?
    token_safely <- purrr::safely(.f = httr::oauth2.0_token)

    token <- token_safely(endpoint = endpoint, app = app, scope = scope, cache = cache)

    if (!is.null(token$error)) {
      token$error
    } else if (show){
      token$result
    } else {
      invisible(NULL)
    }
  }

