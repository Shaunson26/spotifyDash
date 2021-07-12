#' A shiny app with GNAF address selection and view on leaflet
#'
#' Start a shiny app with address selectors that show results on leaflet
#' @export
run_spotify_shiny_dash <- function() {
  appDir <- system.file("shiny-examples", "spotify-shiny-dash", package = "spotifyDash")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `spotifyDash`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
