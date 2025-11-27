# Este script descarga y consolida todos los archivos CSV diarios 
# de mi repositorio privado de GitHub (ncaa-boxscore).
# pero en mi versión sin tantos pasos previos
library(httr2)
library(jsonlite)
library(tidyverse)

token <- Sys.getenv("NCAA_TOKEN")

res_branches <- request(
  "https://api.github.com/repos/IvoVillanueva/ncaa-boxscore/branches"
) |>
  req_headers(Authorization = paste("token", token)) |>
  req_perform() |>
  resp_body_json()


res_players <- list()

for (i in get_calendar()) {
  
  
  players <- request(
    glue::glue("https://raw.githubusercontent.com/IvoVillanueva/ncaa-boxscore/refs/heads/main/data/players/players_{i}.csv")
  ) |>
    req_headers(Authorization = paste("token", token)) |>
    req_perform() |>
    resp_body_string() |>
    readr::read_csv(show_col_types = FALSE) %>% 
    mutate(athlete_jersey = ifelse(athlete_jersey == as.numeric(athlete_jersey), as.character(athlete_jersey), athlete_jersey))
  
  res_players[[i]] <- players
  
  message("Descargado dia " , i)
}

players_all <- dplyr::bind_rows(res_players, .id = "date_id")
