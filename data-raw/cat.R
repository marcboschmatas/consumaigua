# script to prepare `cat` dataset


cat <- sf::read_sf("~/final_postgrau/data/cat_borders.geojson")

usethis::use_data(cat, overwrite = TRUE)


