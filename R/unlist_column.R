unlist_column <- function(list_column){
  purrr::map_df(list_column, as.data.frame)
}
