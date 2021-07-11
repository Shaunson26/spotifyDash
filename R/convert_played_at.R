#' Convert Spotify played_at UNIX time
#'
#' Convert Spotify played_at UNIX time character vector
#'
#' @param x date-time string
#'
convert_played_at <- function(x){
  x_clean <- base::gsub('T|\\..*', ' ', x)
  x_utc <-  base::as.POSIXct(x_clean, format='%Y-%m-%d %H:%M:%S', tz='UTC')
  base::as.POSIXlt(x_utc, tz= base::Sys.timezone())
}
