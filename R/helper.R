# Este script contiene funciones para descargar y consolidar datos de partidos
# de baloncesto universitario masculino desde una API pública de ESPN.

# Cargamos las librerías necesarias
library(tidyverse)
library(httr)
library(httr2)
library(lubridate)
library(jsonlite)
library(rvest)
library(curl)
library(gt)
library(gtExtras)
library(glue)


if (!dir.exists("png")) dir.create("png")

twitter <- "<span style='color:#b14f04'>&#x1D54F;</span>"
tweetelcheff <- "<span style='font-weight:bold;color: grey;'>*@elcheff*</span>"
insta <- "<span style='color:#E1306C;font-family: \"Font Awesome 6 Brands\"'>&#xE055;</span>"
instaelcheff <- "<span style='font-weight:bold;color: grey;'>*@sport_iv0*</span>"
github <- "<span style='color:#c8102e;font-family: \"Font Awesome 6 Brands\"'>&#xF092;</span>"
githubelcheff <- "<span style='font-weight:bold;color: grey;'>*IvoVillanueva*</span>"
caption <- glue::glue("**Datos**: *@NBA* | **Gráfico**: *Ivo Villanueva* • {twitter} {tweetelcheff} • {insta} {instaelcheff} • {github} {githubelcheff}")




# Descargar la tabla de jugadores españoles en NCAA
spain_players <-
  read_csv(
    "https://raw.githubusercontent.com/IvoVillanueva/NCAA-ANALISIS/refs/heads/main/data/spain_players.csv",
    show_col_types = FALSE
  ) %>%
  mutate(Player = gsub("\\s+", " ", Player),
         Player = ifelse( Player == "Ruben Dominguez", "Rubén Dominguez", Player
         )
  ) %>%
  pull(Player)




