
<!-- README.md is generated from README.Rmd. Please edit that file -->

# consumaigua

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

Aquest paquet té com a objectiu generar funcions per a analitzar
l’impacte de factors urbanístics i econòmics en el consum d’aigua als
municipis de les conques internes de Catalunya entre juny de 2022 i maig
de 2023 en el marc del projecte final del Postgrau d’Anàlisi de dades
per a l’anàlisi política i la gestió pública (UB). Aquestes funcions
donen suport a la següent [app de
shiny](https://marcbosch.shinyapps.io/consumaigua/) que permet
visualitzar aquestes anàlisis. D’una banda, permet crear mapes i gràfics
de dispersió per a comparar diferents variables d’interès i de l’altra,
construir models de regressió per a analitzar-ne l’impacte.

## App

[L’app de shiny](https://marcbosch.shinyapps.io/consumaigua/), generada
utilitzant el framework [golem](https://thinkr-open.github.io/golem/),
permet dissenyar un model de regressió per a analitzar els determinants
del consum d’aigua dels 532 municipis amb dades de les conques internes
de Catalunya, observar les correlacions entre les variables estudiades,
representar-les amb mapes coropleta i estudiar els coeficients i
principals estadístics del model de regressió. Està inspirada en la
següent
[app](https://github.com/amitvkulkarni/Interactive-Modelling-with-Shiny/tree/main).

## Instal·lació

Us podeu instal·lar el paquet de la manera següent.

``` r
devtools::install_github("marcboschmatas/consumaigua")
```

Per a córrer l’app en local, podeu fer-ho de la manera següent.

``` r
library(consumaigua)
run_app()
```

## Dades

El paquet conté tres objectes de dades. El procés de neteja i les dades
originals s’han tramès per separat a través del campus virtual. \###
basemap `basemap` és un objecte `stars` amb un mapa base de Catalunya
obtingut d’openstreetmap. Serveix per a contextualitzar els mapes de
coropleta.

### cat

L’objecte `cat` és un objecte `sf` consistent en un polígon que
representa els límits de Catalunya. Serveix també per a contextualitzar
els mapes de coropleta.

### munis_consum

`munis_consum` és uun objecte `sf` que representa els 532 municipis de
les conques internes de Catalunya amb dades de consum d’aigua per, com a
mínim, 9 dels dotze mesos amb dades (juny de 2022 fins a maig de 2023).
Conté les variables següents.

- municipi: codi de sis xifres del municipi (Idescat)
- codiine: codi de cinc xifres del municipi (Idescat)
- nom_muni: nom del municipi (Idescat)
- nom_comarca: nom de la comarca a la qual pertany el municipi (Idescat)
- consum_total: mitjana de la dotació per habitant i dia al municipi
  entre juny de 2022 i maig de 2023 (ACA).
- consum_primavera: mitjana de la dotació per habitant i dia al municipi
  els mesos d’abril, maig i juny 2022 i abril i maig 2023 (ACA).
- consum_estiu: mitjana de la dotació per habitant i dia al municipi els
  mesos de juliol, agost i setembre 2022 (ACA).
- consum_tardor: mitjana de la dotació per habitant i dia al municipi
  els mesos d’octubre, novembre i desembre 2022 (ACA).
- consum_hivern: mitjana de la dotació per habitant i dia al municipi
  els mesos de gener, febrer i març 2023 (ACA).
- mes_400_total: variable dicotòmica que indica si `consum_total` ha
  estat superior a 400 litres per persona i dia (ACA).
- mes_400_primavera: variable dicotòmica que indica si
  `consum_primavera` ha estat superior a 400 litres per persona i dia
  (ACA).
- mes_400_estiu: variable dicotòmica que indica si `consum_estiu` ha
  estat superior a 400 litres per persona i dia (ACA).
- mes_400_tardor: variable dicotòmica que indica si `consum_tardor` ha
  estat superior a 400 litres per persona i dia (ACA).
- mes_400_hivern: variable dicotòmica que indica si `consum_hivern` ha
  estat superior a 400 litres per persona i dia (ACA).
- mes_250_total: variable dicotòmica que indica si `consum_total` ha
  estat superior a 250 litres per persona i dia (ACA).
- mes_250_primavera: variable dicotòmica que indica si
  `consum_primavera` ha estat superior a 250 litres per persona i dia
  (ACA).
- mes_250_estiu: variable dicotòmica que indica si `consum_estiu` ha
  estat superior a 250 litres per persona i dia (ACA).
- mes_250_tardor: variable dicotòmica que indica si `consum_tardor` ha
  estat superior a 250 litres per persona i dia (ACA).
- mes_250_hivern: variable dicotòmica que indica si `consum_hivern` ha
  estat superior a 250 litres per persona i dia (ACA).
- n_hotel: número d’hotels al municipi (Openstreetmap)
- n_piscines: número de piscines, públiques i privades, al municipi
  (Openstreetmap)
- piscines_1000hab: número de piscines, públiques i privades al municipi
  per cada 1000 habitants (Openstreetmap i Idescat).
- hotels_1000hab: número d’hotels al municipi per cada 1000 habitants
  (Openstreetmap i Idescat).
- poblacio: Població del municipi el 2022 (Idescat).
- renda_capita: renda neta mitjana per càpita al municipi el 2020 (INE).
- vab_relatiu_Agricultura: percentatge que suposa el VAB del sector
  primari en la comarca on s’ubica el municipi sobre el total el 2020
  (Idescat).
- vab_relatiu_Indústria: percentatge que suposa el VAB del sector
  industrial en la comarca on s’ubica el municipi sobre el total el 2020
  (Idescat).
- vab_relatiu_Construcció: percentatge que suposa el VAB del sector de
  la construcció en la comarca on s’ubica el municipi sobre el total el
  2020 (Idescat).
- vab_relatiu_Serveis: percentatge que suposa el VAB del sector serveis
  en la comarca on s’ubica el municipi sobre el total el 2020 (Idescat).
  vab_absolut_Agricultura: VAB del sector primari en milions d’euros a
  la comarca on s’ubica el municipi el 2020 (Idescat).
  -vab_absolut_Indústria: VAB del sector industrial en milions d’euros a
  la comarca on s’ubica el municipi el 2020 (Idescat).
  -vab_absolut_Construcció: VAB del sector de la construcció en milions
  d’euros a la comarca on s’ubica el municipi el 2020 (Idescat).
  -vab_absolut_Serveis: VAB del sector serveis en milions d’euros a la
  comarca on s’ubica el municipi el 2020 (Idescat). -su_cases_agrupades:
  superfície del sòl urbanitzable en clau R5 (cases agrupades) en
  hectàrees el 2022 (Generalitat). -su_cases_aïllades: superfície del
  sòl urbanitzable en clau R6 (cases aïllades o adossades) en hectàrees
  el 2022 (Generalitat). -pct_su_cases_agrupades: percentatge que suposa
  la superfície del sòl urbanitzable en clau R5 sobre la superfície
  municipal total (Generalitat). -pct_su_cases_aillades; percentatge que
  suposa la superfície del sòl urbanitzable en clau R6 sobre la
  superfície municipal total (Generalitat). -geom: geometria vectorial
  del municipi.

## Funcions

El paquet té quatre funcions orientades a generar els continguts de
l’app (un gràfic de correlacions, una sèrie de mapes coropleta que
representin les variables escollides, un model de regressió i gràfics de
diagnòstic del model) i una funció destinada a inicialitzar-la en local.
