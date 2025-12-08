source("R/helper.R")
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



# Función para crear la tabla por semana
samanas_df <- function(semana) {
  # Crear la tabla gt
  spain_df_semanas_final %>%
    filter(wk == semana & pts > 2) %>%
    head(10) %>%
    mutate(
      name = word(jug, 1),
      surname = word(jug, 2, -1),
      combo_img = add_photo_frame(logo_equipo, foto_jugador),
      combo_img = map(combo_img, gt::html),
      combo = label_html(name, surname, equipo),
      combo = map(combo, gt::html),
    ) %>%
    select(combo_img, combo, pos, par:pts, -wk) %>%
    gt() %>%
    cols_align(
      align = "right",
      columns = c(min:fal)
    ) %>%
    cols_align(
      align = "center",
      columns = c(pts, pos, par)
    ) %>%
    cols_width(
      colums = c(combo) ~ (290),
      columns = c(combo_img) ~ (110),
      columns = c(par, pos) ~ (55),
      columns = everything() ~ px(75)
    ) |>
    cols_label(
      combo_img = "",
      combo = "",
      pos = "POS",
      par = "PJ",
      min = "MIN",
      fgm = "FGM",
      fga = "FGA",
      tpm = "3PM",
      tpa = "3PA",
      ftm = "FTM",
      fta = "FTA",
      ore = "OREB",
      dre = "DREB",
      reb = "REB",
      asi = "AST",
      rob = "STL",
      tap = "BLK",
      per = "PER",
      fal = "PF",
      pts = "PTS"
    ) %>%
    tab_options(
      heading.align = "left",
      heading.border.bottom.style = "none",
      table.border.top.style = "black", # transparent
      table.border.bottom.style = "none",
      column_labels.border.top.style = "none",
      column_labels.border.bottom.color = "black",
      row_group.border.top.style = "none",
      row_group.border.top.color = "black",
      data_row.padding = px(0), # 🔥 quita el espacio vertical
      column_labels.padding = px(0),
      table.font.size = 30,
      footnotes.font.size = 15,
      heading.title.font.weight = "bold",
      column_labels.font.size = 20,
      column_labels.font.weight = "bold",
      source_notes.font.size = 20,
      table_body.hlines.color = "gray90",
      table.font.names = "Oswald",
      table.additional_css = ".gt_table {
                margin-bottom: 40px;
                @import url('https://fonts.googleapis.com/css2?family=Oswald:wght@400;600;700&display=swap');
                @import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/fontawesome.min.css');
                @import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/brands.min.css');
              }"
    ) %>%
    gt_color_rows(pts, palette = c("white", "#009CDE")) %>%
    tab_header(
      title = md(glue("<div style='display: flex; align-items: center;
    justify-content: left; height: 58px; text-align: center; font-weight: 600;
    font-size: 75px;'>
               <span style='text-align:left;'>Españoles en la NCAA Semana {semana}</div>")),
      subtitle = md(paste0(
        "<span style='display:block;text-align:left;font-weight:400;color:#8C8C8C;
                     font-size:40px;
      '>Filtrados por puntos por partido | temporada 25-26</span>"
      ))
    ) %>%
    tab_source_note(source_note = md(caption)) |>
    gtsave(glue("png/ncaaspain_semana_{semana}.png"), vwidth = 3700, vheight = 1500, expand = 300)
}

map(unique(semanas_df$semana), samanas_df)
