# =============================================================
# Tarea 0.11 - Lectura Robusta de Archivos y Limpieza de Datos
# Script: analisis.R
# =============================================================

cat(strrep("=", 60), "\n")
cat("  EJERCICIO 1 - Limpiando un inventario forestal\n")
cat(strrep("=", 60), "\n")

writeLines(c(
  "Especie,Latitud,Longitud",
  "Roble,4.6097,-74.0817",
  "Pino,4.6XYZ,-74.0900",
  "Cedro,4.6150,-74.0850",
  "Eucalipto,NULA,-74.0700",
  "Nogal,4.6200,-74.0650"
), "arboles_crudos.txt")
cat("  Archivo arboles_crudos.txt creado.\n")

limpiar_inventario <- function(entrada, salida) {
  con <- file(entrada, open = "r")
  on.exit(close(con), add = TRUE)
  lineas    <- readLines(con)
  validos   <- list()
  invalidos <- 0L

  for (linea in lineas[-1]) {
    partes  <- strsplit(trimws(linea), ",")[[1]]
    if (length(partes) != 3) next
    especie <- trimws(partes[1])
    lat_str <- trimws(partes[2])
    lon_str <- trimws(partes[3])

    resultado <- tryCatch({
      lat <- suppressWarnings(as.numeric(lat_str))
      lon <- suppressWarnings(as.numeric(lon_str))
      if (is.na(lat) || is.na(lon)) stop("NA")
      list(especie = especie, latitud = lat, longitud = lon)
    }, error = function(e) {
      cat(sprintf("  ADVERTENCIA: '%s' lat='%s' invalida. Omitido.\n", especie, lat_str))
      NULL
    })

    if (!is.null(resultado)) validos <- append(validos, list(resultado))
    else invalidos <- invalidos + 1L
  }

  df <- do.call(rbind, lapply(validos, as.data.frame))
  write.csv(df, salida, row.names = FALSE, quote = FALSE)
  cat(sprintf("\n  Registros validos  : %d\n", length(validos)))
  cat(sprintf("  Registros omitidos : %d\n", invalidos))
}

limpiar_inventario("arboles_crudos.txt", "arboles_limpios_r.csv")
cat("\nContenido de arboles_limpios_r.csv:\n")
cat(readLines("arboles_limpios_r.csv"), sep = "\n")

cat("\n", strrep("=", 60), "\n")
cat("  EJERCICIO 2 - Analizando datos estructurados\n")
cat(strrep("=", 60), "\n")

cargar_datos_espaciales <- function(archivo) {
  df <- read.csv(archivo, stringsAsFactors = FALSE)
  lapply(seq_len(nrow(df)), function(i)
    list(especie  = trimws(df$especie[i]),
         latitud  = as.numeric(df$latitud[i]),
         longitud = as.numeric(df$longitud[i])))
}

arboles_r   <- cargar_datos_espaciales("arboles_limpios_r.csv")
latitudes_r <- sapply(arboles_r, `[[`, "latitud")
norte_r     <- arboles_r[[which.max(latitudes_r)]]

cat("\nRegistros cargados en memoria:\n")
for (a in arboles_r)
  cat(sprintf("  %-12s lat=%.4f  lon=%.4f\n", a$especie, a$latitud, a$longitud))
cat(sprintf("\n  Latitud promedio : %.4f grados\n", mean(latitudes_r)))
cat(sprintf("  Arbol mas norte  : %s (lat=%.4f)\n", norte_r$especie, norte_r$latitud))
cat("\n  Script R completado exitosamente.\n")
