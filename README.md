
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
donen suport a l’app de shiny APP AQUÍ QUAN ESTIGUI LLESTA que permet
visualitzar aquestes anàlisis. D’una banda, permet crear mapes i gràfics
de dispersió per a comparar diferents variables d’interès i de l’altra,
construir models de regressió per a analitzar-ne l’impacte.

L'app s'ha desenvolupat amb el framework [golem](https://thinkr-open.github.io/golem/) i està inspirada en les apps següents: [Interactive-Modelling-With-Shiny](https://github.com/amitvkulkarni/Interactive-Modelling-with-Shiny) i [shiny-regression](https://github.com/altaf-ali/shiny-regression).

## Instal·lació

Us podeu instal·lar el paquet de la manera següent.

``` r
devtools::install_github("marcboschmatas/consumaigua")
```

## Dades

El paquet conté tres objectes de dades. Podeu consultar les dades en brut [aquí](https://doi.org/10.6084/m9.figshare.c.6712686.v1) i el script utilitzat per a descarregar-les, netejar-les i preparar-les és [aquest](https://github.com/marcboschmatas/consumaigua/blob/master/R/01_data_obtention_treatment.R)

### basemap
`basemap` és un objecte `stars` amb un mapa base de Catalunya
obtingut d’openstreetmap. Serveix per a contextualitzar els mapes de
coropleta. No s'utilitza en la primera versió de l'app fins que no es pugui resoldre el llarg temps de càrrega.

### cat

L’objecte `cat` és un objecte `sf` consistent en un polígon que
representa els límits de Catalunya. Serveix també per a contextualitzar
els mapes de coropleta.

### munis_consum

`munis_consum` és uun objecte `sf` que representa els 532 municipis de
les conques internes de Catalunya amb dades de consum d’aigua per, com a
mínim, 9 dels dotze mesos amb dades (juny de 2022 fins a maig de 2023).
Conté les variables següents.

**Variables d'identificació**
- municipi: codi de sis xifres del municipi (Idescat)
- codiine: codi de cinc xifres del municipi (Idescat)
- nom_muni: nom del municipi (Idescat)

**Variables d'outcome**
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
  
**Variables predictores**
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
- vab_absolut_Agricultura: VAB del sector primari en milions d’euros a
  la comarca on s’ubica el municipi el 2020 (Idescat).
- vab_absolut_Indústria: VAB del sector industrial en milions d’euros a
  la comarca on s’ubica el municipi el 2020 (Idescat).
- vab_absolut_Construcció: VAB del sector de la construcció en milions
  d’euros a la comarca on s’ubica el municipi el 2020 (Idescat).
- vab_absolut_Serveis: VAB del sector serveis en milions d’euros a la
  comarca on s’ubica el municipi el 2020 (Idescat).
- su_cases_agrupades:
  superfície del sòl urbanitzable en clau R5 (cases agrupades) en
  hectàrees el 2022 (Generalitat).
- su_cases_aïllades: superfície del
  sòl urbanitzable en clau R6 (cases aïllades o adossades) en hectàrees
  el 2022 (Generalitat).
- pct_su_cases_agrupades: percentatge que suposa
  la superfície del sòl urbanitzable en clau R5 sobre la superfície
  municipal total (Generalitat).
- pct_su_cases_aillades; percentatge que
  suposa la superfície del sòl urbanitzable en clau R6 sobre la
  superfície municipal total (Generalitat).
- geom: geometria vectorial
  del municipi.

## Funcions

El paquet compta amb tres funcions que després s'implementen en l'app de shiny.

- make_corrplot: elabora un gràfic de correlació amb les variables seleccionades.
- make_plots: elabora mapes coropleta dels municipis amb dades de totes les variables seleccionades. PENDENT DE REVISAR PER A OPTIMITZAR-NE LA VELOCITAT.
- make_regression: elabora un model de regressió linear o logística.

## app

EN PROCÉS
L'app permet consultar les correlacions entre les variables estudiades i els resultats del model de relació: coeficient i principals estadístics de diagnòstics. Està desenvolupada en els arxius ```R/ui.R``` i ```R/server.R```

