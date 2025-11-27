# Este script descarga y consolida todos los archivos CSV diarios 
# de tu repositorio privado de GitHub (ncaa-boxscore).

# --- CONFIGURACIÓN DE SEGURIDAD ---
# 1. Obtener el Personal Access Token (PAT) de GitHub
#    El token debe estar guardado en tu archivo .Renviron como GITHUB_PAT.
GITHUB_TOKEN <- Sys.getenv("GITHUB_PAT")

if (GITHUB_TOKEN == "") {
  stop("ERROR: La variable de entorno GITHUB_PAT no está configurada. \n
       Por favor, configura tu token de GitHub en el archivo .Renviron para acceder al repositorio privado.")
}


# --- PARÁMETROS DEL REPOSITORIO ---
REPO_OWNER <- "IvoVillanueva"
REPO_NAME <- "ncaa-boxscore"
BRANCH <- "refs/heads/main" # Usamos la rama principal
DATA_PATH <- "data/players/" # Ruta dentro del repositorio

# Define el rango de fechas de la temporada que deseas cargar (Ej: desde Noviembre 2025)
START_DATE <- as.Date("2025-11-03")
END_DATE <- Sys.Date() - 1 # Hasta ayer

# Genera la secuencia de fechas
all_dates <- seq(START_DATE, END_DATE, by = "day")
date_strings <- format(all_dates, "%Y%m%d")


# --- CONSTRUCCIÓN DE URLs ---
base_url <- paste0(
  "https://raw.githubusercontent.com/",
  REPO_OWNER, "/", REPO_NAME, "/", BRANCH, "/", DATA_PATH
)

# Construye la URL completa con el token de acceso
all_urls <- purrr::map_chr(date_strings, ~ {
  paste0(base_url, "players_", .x, ".csv?token=", GITHUB_TOKEN)
})


# --- DESCARGA Y CONSOLIDACIÓN DE DATOS (En Paralelo) ---
library(tidyverse)
library(purrr)
library(httr)

# Función segura para leer un archivo desde una URL
read_csv_secure <- function(url) {
  # Usamos tryCatch para que si un día falta (ej. Navidad, no hay juegos), 
  # el script no se rompa, sino que devuelva NULL.
  tryCatch({
    # Usamos content() y read_csv() para manejar la descarga correctamente.
    response <- httr::GET(url)
    if (httr::status_code(response) == 404) {
      warning(paste("Archivo no encontrado (404) o token inválido para:", url))
      return(NULL)
    }
    
    csv_text <- httr::content(response, as = "text", encoding = "UTF-8")
    
    # readr::read_csv es más rápido y robusto que read.csv
    readr::read_csv(csv_text, show_col_types = FALSE)
    
  }, error = function(e) {
    warning(paste("Error al procesar la URL:", url, "\nMensaje:", e$message))
    return(NULL)
  })
}

message(paste("Iniciando descarga de", length(all_urls), "archivos..."))

# Descarga y une todos los archivos en un solo dataframe
# Usamos map_dfr para unirlos por filas (row bind)
df_ncaa_completo <- purrr::map_dfr(all_urls, read_csv_secure)

message(paste("Descarga finalizada. Filas totales:", nrow(df_ncaa_completo)))

# Muestra el resultado
head(df_ncaa_completo)