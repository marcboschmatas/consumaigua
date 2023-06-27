# library(tidyverse)
# library(sf)
# library(osmdata)
# library(readxl)
#
# #### DON'T RUN ####
#
# # Aquest arxiu recull els processos de neteja i obtenció de dades. Podeu trobar els resultats aquí https://doi.org/10.6084/m9.figshare.c.6712686.v1
#
# # Recomano córrer aquest script en un projecte a part per a validar l'input.
# #### obtenció piscines i camps de golf i assignació a un municipi ####
#
# # municipis obtinguts d'aquí https://analisi.transparenciacatalunya.cat/resource/5ryy-c5zw.json?%24limit=5000
# munis <- st_read("data/munis.geojson")
#
#
# ggplot(munis) +
#   geom_sf(fill = NA) +
#   theme_void()
#
#
# # piscines - agafar el centroide de cada una
#
# piscines <- opq(getbb("Catalunya", format_out = "osm_type_id"),
#                 osm_types = "nwr") |>
#   add_osm_features(list("amenity" = "swimming_pool", "leisure" = "swimming_pool")) |>
#     osmdata_sf()
#
# piscines_points <- piscines$osm_points
# piscines_pol <- bind_rows(piscines$osm_polygons, piscines$osm_multipolygons)
#
# piscines_sf <- bind_rows(piscines_points, st_centroid(st_make_valid(piscines_pol)))
#
# piscines_sf <- filter(piscines_sf, !is.na(leisure) & !is.na(amenity))
#
#
#
#
# hotels_points <- hotels$osm_points
# hotels_pol <- st_centroid(st_make_valid(hotels$osm_polygons))
#
# hotels_sf <- bind_rows(hotels_points, hotels_pol) |>
#   filter(!is.na(tourism))
#
# # hotels
# st_write(piscines_sf, "data/dades_geo.gpkg", layer = "piscines")
# st_write(hotels_sf, "data/dades_geo.gpkg", layer = "hotels")
#
#
#
#
#
# # piscines
#
#
# piscines_muni <- piscines_sf |>
#   st_join(munis[,"municipi"]) |>
#   st_drop_geometry() |>
#   summarise(n_piscines = n(), .by = municipi)
#
#
# # hotels
#
# hotels_muni <- hotels_sf |>
#   st_join(munis[,"municipi"]) |>
#   st_drop_geometry() |>
#   summarise(n_hotel = n(), .by = municipi)
#
#
# # unió a la bdd
# munis <- munis |>
#   select(municipi, codiine, nom_muni, comarca1, provincia1) |>
#   left_join(golf_muni, by = "municipi") |>
#   left_join(hotels_muni, by = "municipi") |>
#   left_join(piscines_muni, by = "municipi") |>
#   mutate(across(n_golf:n_piscines, function(x) ifelse(is.na(x), 0, x)))
#
#
# # consum d'aigua
#
#
# sheets <- excel_sheets("data/informe-dotacions-sequera-total.xlsx")
# # s'han eliminat Hostalric, Alcover i Gombrèn, clarament equivocats (manca de coma decimal)
# # funció per llegir cada conca
# read_sheet <- function(path = "data/informe-dotacions-sequera-total.xlsx", sheet){
#   ex <- read_xlsx(path = path, sheet = sheet, na = "-", skip = 6)
#   ex <- ex |>
#     rename("municipi" = "(valors en l/hab dia)") |>
#     mutate(across(-municipi, \(x) as.numeric(str_remove(x, "\\*")))) |>
#     mutate(conca = sheet)
#   return(ex)
# }
#
# aigua <- bind_rows(lapply(sheets,
#                           \(x) read_sheet(path = "data/informe-dotacions-sequera-total.xlsx",
#                                                   sheet = x)))
#
# # càlcul variables interès
#
#
# mitjana_total <- aigua |>
#   pivot_longer(-c(municipi, conca), names_to = "mes", values_to = "consum") |>
#   group_by(municipi) |>
#   mutate(num_nas = sum(is.na(consum))) |>
#   filter(num_nas <= 3) |>  # filtrar número de NA igual o menor a 3
#   summarise(consum_total = mean(consum, na.rm = TRUE))
#
#
# mitjana_estacional <- aigua |>
#   pivot_longer(-c(municipi, conca), names_to = "mes", values_to = "consum") |>
#   group_by(municipi) |>
#   mutate(num_nas = sum(is.na(consum))) |>
#   filter(num_nas <= 3) |>
#   ungroup() |>
#   mutate(estacio = case_when(str_starts(mes, "jul|ago|set") ~ "estiu",
#                              str_starts(mes, "oct|nov|dec") ~ "tardor",
#                              str_starts(mes, "gen|feb|mar") ~  "hivern",
#                              TRUE ~ "primavera")) |>
#   summarise(consum = mean(consum, na.rm = TRUE), .by = c(municipi, estacio)) |>
#   pivot_wider(id_cols = municipi, names_from = "estacio", names_prefix = "consum_", values_from = "consum")
#
#
# # unió i comprovar noms de municipis que calgui canviar
#
# munis_consum <- munis |>
#   inner_join(mitjana_total, by = c("nom_muni" = "municipi"))
#
# noms_erronis <- mitjana_total[!(mitjana_total$municipi %in% munis_consum$nom_muni),"municipi"]
#
# munis_consum <- filter(munis_consum, !(nom_muni %in% c("Alcover", "Gombrèn", "Hostalric")))
# # posar l'article davant
#
# mitjana_total <- mitjana_total |>
#   mutate(municipi = case_when(str_detect(municipi, ", l'") ~ paste0("l'",str_remove(municipi, ", l'")),
#                               str_detect(municipi, ", la") ~ paste0("la ",str_remove(municipi, ", la")),
#                               str_detect(municipi, ", els") ~ paste0("els ",str_remove(municipi, ", els")),
#                               str_detect(municipi, ", el") ~ paste0("el ",str_remove(municipi, ", el")),
#                               str_detect(municipi, ", les") ~ paste0("les ",str_remove(municipi, ", les")),
#                               municipi == "Roda de Barà" ~ "Roda de Berà",
#                               TRUE ~ municipi))
#
# mitjana_estacional <- mitjana_estacional |>
#   mutate(municipi = case_when(str_detect(municipi, ", l'") ~ paste0("l'",str_remove(municipi, ", l'")),
#                               str_detect(municipi, ", la") ~ paste0("la ",str_remove(municipi, ", la")),
#                               str_detect(municipi, ", els") ~ paste0("els ",str_remove(municipi, ", els")),
#                               str_detect(municipi, ", el") ~ paste0("el ",str_remove(municipi, ", el")),
#                               str_detect(municipi, ", les") ~ paste0("les ",str_remove(municipi, ", les")),
#                               municipi == "Roda de Barà" ~ "Roda de Berà",
#                               TRUE ~ municipi))
#
# munis_consum <- munis |>
#   mutate(nom_muni = ifelse(nom_muni == "Santa Maria de Corcó", "l'Esquirol", nom_muni)) |>
#   inner_join(mitjana_total, by = c("nom_muni" = "municipi")) |>
#   inner_join(mitjana_estacional, by = c("nom_muni" = "municipi"))
#
# # mapa per comprovar
# cat <- st_union(munis)
# ggplot() +
#   geom_sf(data = cat, fill = NA, colour = "black") +
#   geom_sf(data = mutate(munis_consum, consum_total_quantil = cut(consum_total,
#                                                                   breaks = quantile(consum_total,
#                                                                                     c(0, .25, .5, .75, 1)))),
#           aes(fill = consum_total_quantil)) +
#   scale_fill_viridis_d() +
#   theme_void()
#
# # renda per càpita
#
#
# renda <- read.csv2("data/renda.csv")
#
# glimpse(renda)
#
# renda <- renda |>
#   filter(Secciones == "" &
#            Distritos =="" &
#            Indicadores.de.renta.media == "Renta neta media por persona " &
#            Periodo == 2020) |>
#   mutate(codiine = str_extract(Municipios, "\\d{5}"),
#          Total = as.numeric(gsub("\\.", "", Total))) |>
#   select(codiine, "renda_capita" = Total) |>
#   filter(codiine %in% munis_consum$codiine)
#
# munis_consum <- inner_join(munis_consum, renda, by = "codiine")
#
# # vab per sectors d'activitat - descarregat d'aquí https://www.idescat.cat/indicadors/?id=aec&n=15337
#
#
# vab <- read.csv("data/vab_comarques.csv",skip = 7)
# colnames(vab)[1] <- "comarca"
# vab_absolut <- vab[1:42,]
# vab_relatiu <- vab[52:93,]
#
# vab_absolut <- vab_absolut |>
#   mutate(across(-comarca, as.numeric))
#
# vab_relatiu <- vab_relatiu |>
#   select(-Total) |>
#   mutate(across(-comarca, as.numeric))
#
# colnames(vab_relatiu) <- sapply(colnames(vab_relatiu), \(x) ifelse(x == "comarca", x, paste0("vab_relatiu_",x)),USE.NAMES = FALSE)
# colnames(vab_absolut) <- sapply(colnames(vab_absolut), \(x) ifelse(x == "comarca", x, paste0("vab_absolut_",x)),USE.NAMES = FALSE)
# # assignar nom comarca a cada municipi
#
#
# m <- request("https://analisi.transparenciacatalunya.cat/resource/9aju-tpwc.json?$limit=1000") |>
#   req_perform() |>
#   resp_body_string() |>
#   fromJSON() |>
#   select(codi, nom, nom_comarca)
#
#
# m <- m |> mutate(nom_comarca = case_when(nom %in% c("Alpens","Lluçà",
#                                                     "Olost", "Oristà", "Perafita",
#                                                     "Prats de Lluçanès", "Sant Martí d'Albars", "Sobremunt") ~ "Osona",
#                                  nom == "Sant Feliu Sasserra" ~ "Bages",
#                                  TRUE ~ nom_comarca))# canviar municipis del Lluçanès per fer merge
#
# munis_consum <- munis_consum |>
#   select(-c(comarca1, provincia1)) |>
#   left_join(m, by = c("municipi" = "codi")) |>
#   left_join(vab_relatiu, by = c("nom_comarca" = "comarca")) |>
#   left_join(vab_absolut, by = c("nom_comarca" = "comarca"))
#
#
# # població
#
#
# pob <- read.csv2("data/poblacio_municipis.csv")
#
# pob <- pob |>
#   filter(any == "2022") |>
#   summarise(poblacio = sum(valor, na.rm = TRUE), .by = geo)
#
#
# munis_consum <- munis_consum |>
#   left_join(pob, by = c("municipi" = "geo"))
#
# munis_consum |>
#   mutate(pispob = n_piscines/poblacio*1000,
#          hopob = n_hotel/poblacio*1000,
#          mes_400 = ifelse(consum_total > 400, 1, 0)) |>
#   lm(mes_400 ~ pispob + hopob + vab_relatiu_Agricultura + vab_relatiu_Indústria + renda_capita, data = _) |> summary()
#
#
# munis_consum <- munis_consum |>
#   #select(-n_golf) |>
#   mutate(piscines_1000hab = n_piscines/poblacio*1000,
#          hotels_1000hab = n_hotel/poblacio*1000,
#          mes_400_total = ifelse(consum_total > 400, 1, 0),
#          mes_400_primavera = ifelse(consum_primavera > 400, 1, 0),
#          mes_400_estiu = ifelse(consum_estiu > 400, 1, 0),
#          mes_250_hivern = ifelse(consum_hivern > 250, 1, 0),
#          mes_250_total = ifelse(consum_total > 250, 1, 0),
#          mes_250_primavera = ifelse(consum_primavera > 250, 1, 0),
#          mes_250_estiu = ifelse(consum_estiu > 250, 1, 0),
#          mes_250_hivern = ifelse(consum_hivern > 250, 1, 0))
#
#
# ### urbanisme - cases aïllades i adossades
# baseurl <- "https://analisi.transparenciacatalunya.cat/resource/epsm-zskb.json?$query="
# query <- "SELECT any, codi_ine_5_txt AS codiine, _13_r5_suc AS su_cases_agrupades, _13_r6_suc AS su_cases_aillades LIMIT 1000000"
# query <- str_replace_all(query, " ", "%20")
# urb <- request(paste0(baseurl,query)) |>
#   req_perform() |>
#   resp_body_string() |>
#   fromJSON()
#
# # quedar-se amb l'any més recent
#
# urb <- urb |>
#   group_by(codiine) |>
#   filter(any == max(any)) |>
#   mutate(across(c(su_cases_agrupades, su_cases_aillades), as.numeric)) |>
#   ungroup()
#
# munis_consum <- munis_consum |>
#   left_join(urb[,c("codiine", "su_cases_agrupades", "su_cases_aillades")], by = "codiine") |>
#   mutate(area_muni = as.numeric(st_area(geometry)),
#          pct_su_cases_agrupades = su_cases_agrupades*10000/area_muni,
#          pct_su_cases_aillades = su_cases_aillades*10000/area_muni)
#
# st_write(munis_consum, "raw_data_final.gpkg", layer = "munis_consum", append = FALSE)
#
# # silueta catalunya per mapes i mapa base openstreetmap
# st_write(cat, "data_final/cat_borders.geojson")
#
#
#
#
#
#
#
