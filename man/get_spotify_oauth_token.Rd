% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_spotify_oauth_token.R
\name{get_spotify_oauth_token}
\alias{get_spotify_oauth_token}
\title{Get Spotify OAuth 2.0 token}
\usage{
get_spotify_oauth_token(
  client_id,
  client_secret,
  scope = c("user-read-recently-played", "user-top-read"),
  cache = TRUE,
  show = TRUE
)
}
\arguments{
\item{client_id}{Defaults to System Envioronment variable "SPOTIFY_CLIENT_ID"}

\item{client_secret}{Defaults to System Envioronment variable "SPOTIFY_CLIENT_SECRET"}

\item{scope}{Space delimited string of spotify scopes,
found here: https://developer.spotify.com/documentation/general/guides/scopes/.
All scopes are selected by default}
}
\value{
The Spotify Web API Token2.0 reference class object (see
\code{httr::\link[httr]{oauth2.0_token}}), or an error message.
}
\description{
This function creates a Spotify authorization code.
See \code{httr::\link[httr]{oauth2.0_token}}.
}
\examples{
\donttest{
authorization <- get_spotify_authorization_code()
}
}
