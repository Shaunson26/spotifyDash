
make_track_card <- function(summarised_track){

  container_css <-
    htmltools::css(flex = '1 1 100px;',
                   width = '100px',
                   margin = '4px',
                   `background-color` = 'rgba(70, 130, 180, 0.05)',
                   #border =  '1px solid black',
                   `border-radius` = '4px',
                   `box-shadow` = '2px 2px 4px rgba(0,0,0,0.25)'#,
                   #overflow = 'hidden',
                   #position = 'relative'
    )

  number_css <-
    htmltools::css(position='absolute',
                   color = 'black',
                   `background-color`= 'white',
                   width = '16px',
                   height = '16px',
                   `margin-left` = '2px',
                   `margin-top` = '2px',
                   `text-align` = 'center',
                   `border-radius` = '2px',
                   `font-weight` = 900)

  img_css <-
    htmltools::css(#`border-radius` = '4px 4px 0 0',
      `border-radius` = '4px',
      height = '100px',
      width = '100px')

  track_css <-
    htmltools::css(display = 'block',
                   #`font-weight`='bold',
                   `font-size`='1em',
                   `padding-left`='2px',
                   `font-weight` = 900)

  artist_css <-
    htmltools::css(`font-size`='0.75em',
                   `padding-left`='2px',
                   `font-weight` = 900)

  htmltools::div(class = 'track-card', style=container_css,
                 #htmltools::span(style=number_css, 1),
                 htmltools::img(class='track-img', style=img_css, src=summarised_track$track_img),
                 htmltools::span(class='track-name', style=track_css,
                                 summarised_track$track),
                 htmltools::span(class='artist-name', style=artist_css,
                                 summarised_track$artist)
  )
}


