rank_genres <- function(genres){
  dplyr::case_when(
    grepl('pop$', genres) ~ 'pop',
    grepl('rock$', genres) ~ 'rock',
    grepl('house$', genres) ~ 'house',
    grepl('dance$', genres) ~ 'dance',
    grepl('metal$', genres) ~ 'metal',
    grepl('rap$', genres) ~ 'rap',
    grepl('hip hop', genres) ~ 'hip hop',
    grepl('r&b', genres) ~ 'r&b',
    TRUE ~ genres)
}
