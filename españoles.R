
library(rvest)

url_realgm <- "https://basketball.realgm.com/national/countries/9/Spain/ncaa-players"

# 1. Crear la solicitud con un User-Agent (simulando ser un navegador)
response <- request(url_realgm) %>%
  req_headers(`User-Agent` = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36") %>%
  req_perform()

# 2. Leer el contenido HTML del cuerpo de la respuesta
pagina_html <- response %>%
  resp_body_html()