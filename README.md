# analisis_ncaa

Repositorio para analizar datos de la NCAA (National Collegiate Athletic Association).

## Solución para Comillas Anidadas

### Problema
Cuando tienes un string como `"Basketball Club "Bashkimi""` y quieres convertirlo a `"Basketball Club Bashkimi"` (sin las comillas internas).

### Solución en R

Usa la función `gsub()` para remover las comillas:

```r
# Remover todas las comillas
texto_limpio <- gsub('"', '', texto_original)

# Ejemplo:
texto <- 'Basketball Club "Bashkimi"'
texto_limpio <- gsub('"', '', texto)
# Resultado: "Basketball Club Bashkimi"
```

### Para un Data Frame

```r
# Si tienes un data frame con una columna que contiene comillas
df$columna <- gsub('"', '', df$columna)

# Ejemplo completo:
df <- data.frame(team = c('Basketball Club "Bashkimi"', 'Team "Alpha"'))
df$team <- gsub('"', '', df$team)
```

### Para un archivo CSV

```r
# Leer CSV
df <- read.csv("archivo.csv")

# Limpiar la columna
df$nombre_columna <- gsub('"', '', df$nombre_columna)

# Guardar el archivo limpio
write.csv(df, "archivo_limpio.csv", row.names = FALSE)
```

Ver el archivo `fix_nested_quotes.R` para más ejemplos.