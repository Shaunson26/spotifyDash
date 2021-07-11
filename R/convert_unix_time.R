#' Convert UNIX time
#'
#' Convert date-time from milliseconds UTC
#'
#' @param x number or string
convert_unix_time <- function(x){
  x <- base::as.numeric(x)/1000
  base::.POSIXct(x, tz=base::Sys.timezone())
}
