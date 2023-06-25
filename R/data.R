#' mapa base de Catalunya (OpenStreetMap)
#'
#' Objecte stars utilitzat com a mapa base. Font: Col·laboradors d'OpenStreetMap
#'
#' @format ## `basemap`
#' stars object with 3 dimensions and 1 attribute:
#' @source "Openstreetmap Collaborators"

"basemap"

#' límits de Catalunya (Idescat)
#'
#' Objecte sf que recull un polígon amb tota la superfície de Catalunya
#' @format ## `cat`
#' Simple feature collection with 1 feature and 0 fields
#'  Geometry type: MULTIPOLYGON
#'  Dimension:     XY
#'  Bounding box:  xmin: 0.1594159 ymin: 40.52289 xmax: 3.332551 ymax: 42.86149
#'  Geodetic CRS:  WGS 84
#' @source "Idescat"

"cat"


#' Dades de consum d'aigua i variables explicatives
#'
#' Objecte sf que recull les dades de municipis de conques internes amb dades de consum d'aigua
#' @format ## `munis_consum`
#' Simple feature collection with 532 features and 38 fields
#'  Geometry type: MULTIPOLYGON
#'  Dimension:     XY
#'  Bounding box:  xmin: 0.6423511 ymin: 40.76635 xmax: 3.332551 ymax: 42.46151
#'  Geodetic CRS:  WGS 84
#' @source "Idescat, INE, OpenStreetMap, Generalitat"

"munis_consum"
