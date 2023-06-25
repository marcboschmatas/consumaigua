## code to prepare `basemap` dataset goes here

basemap <- stars::read_stars("~/final_postgrau/data/basemap.tif", proxy = FALSE)

basemap <- stars::st_transform_proj(basemap, "EPSG:4326")

usethis::use_data(basemap, overwrite = TRUE)
