

# Configuración del manejador de curl con User-Agent y cookies
ua <- "Mozilla/5.0 (...) Safari/537.36"
h <- new_handle()
handle_setheaders(h,
                  "User-Agent" = ua,
                  "Referer" = "https://basketball.realgm.com/"
)
handle_setopt(h, cookiefile = "", cookiejar = "cookies.txt", http_version = 2L)

# Función para obtener y parsear una página de RealGM
get_realgm <- function(url) {
  curl_fetch_memory("https://basketball.realgm.com/", handle = h)
  res <- curl_fetch_memory(url, handle = h)
  read_html(res$content)
}



# Descargar la tabla de jugadores españoles en NCAA
spain_players <-
  get_realgm(
    "https://basketball.realgm.com/national/countries/9/Spain/ncaa-players"
  ) %>%
  html_node("table") %>%
  html_table() %>%
  mutate(Player = gsub("\\s+", " ", Player)) %>%
  pull(Player)

write_csv(spain_players, "data/spain_players.csv")

spain_players_games <-
  get_realgm(
    "https://basketball.realgm.com/national/countries/9/Spain/ncaa-players"
  ) %>%
  html_node("table") %>%
  html_table() %>%
  mutate(Player = gsub("\\s+", " ", Player)) %>%
  select(Player, gm = GP)

write_csv(spain_players_games, "data/spain_players_games.csv")
