source("R/funciones.R")

# Crear el dataframe por semanas
semanas <- get_calendar() %>%
  tibble(fecha = .) %>%
  mutate(
    fecha = lubridate::ymd(fecha),
    semana = lubridate::isoweek(lubridate::ymd(fecha)),
    dia_semana = lubridate::wday(fecha, label = TRUE, abbr = FALSE, locale = "es_ES")
  ) %>%
  arrange(semana)

# Unir las semanas al dataframe de jugadores
semanas_df <- players_all %>%
  mutate(date_id = lubridate::ymd(date_id)) %>%
  left_join(semanas, join_by(date_id == fecha))


# Filtrar y resumir los datos de los jugadores españoles por semana
spain_df_semanas <- semanas_df %>%
  filter(athlete_display_name %in% spain_players) %>%
  group_by(semana, athlete_display_name) %>%
  summarise(
    gm = sum(ifelse(!did_not_play, 1, 0), na.rm = TRUE),
    across(minutes:points, ~ round(mean(.x, na.rm = TRUE), 1)),
    .groups = "drop"
  ) %>%
  arrange(semana, desc(points)) %>%
  drop_na() %>%
  purrr::set_names(
    nm = c(
      "wk", "jug", "par", "min", "fgm", "fga", "tpm", "tpa", "ftm", "fta",
      "ore", "dre", "reb", "asi", "rob", "tap", "per", "fal", "pts"
    )
  )

# Unir los datos de los jugadores con su información personal
spain_df_semanas_final <- semanas_df %>%
  select(
    jug = athlete_display_name, pos = athlete_position_abbreviation,
    team_display_name, team_logo, athlete_headshot_href
  ) %>%
  unique() %>%
  drop_na() %>%
  inner_join(spain_df_semanas, join_by(jug)) %>%
  arrange(desc(pts)) %>%
  rename(
    equipo = team_display_name,
    logo_equipo = team_logo,
    foto_jugador = athlete_headshot_href
  )

