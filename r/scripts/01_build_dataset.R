# 01_build_dataset.R
# Objetivo: descargar, consolidar y guardar los microdatos de la
# Encuesta sobre las Expectativas de los Especialistas en Economía
# del Sector Privado (Banco de México)
# GitHub: @ecodiegoale

# entorno del proyecto ----------------------------------------------------

source("R/utils/utils_eeeesp.R")

# librerías ---------------------------------------------------------------

if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")

pacman::p_load(
  readr,
  dplyr,
  tictoc,
  beepr
)

# construcción de la base -------------------------------------------------

build_eeeesp <- function() {
  
  tictoc::tic("Construcción de base EEEESP")
  
  data <- readr::read_csv(
    download_eeeesp(),
    locale = readr::locale(encoding = "LATIN1"),
    show_col_types = FALSE
  )
  
  fecha_inicial <- min(data$FechaEncuesta, na.rm = TRUE)
  fecha_final   <- max(data$FechaEncuesta, na.rm = TRUE)
  
  mensaje_toc <- paste0(
    "[eeeesp::build] Base construida: ",
    format(fecha_inicial, "%Y-%m"),
    " a ",
    format(fecha_final, "%Y-%m"),
    " | ",
    format(nrow(data), big.mark = ","),
    " observaciones"
  )
  
  tictoc::toc()
  message(mensaje_toc)
  beepr::beep(1)
  
  return(list(
    data = data,
    fecha_inicial = fecha_inicial,
    fecha_final = fecha_final
  ))
}

res <- build_eeeesp()

data <- res$data
fecha_inicial <- res$fecha_inicial
fecha_final <- res$fecha_final

# guardado ---------------------------------------------------------------

if (!dir.exists("inputs/datos")) dir.create("inputs/datos", recursive = TRUE)

# borrar versiones previas del dataset
archivos_previos <- list.files(
  "inputs/datos",
  pattern = "^eeeesp_.*\\.rds$",
  full.names = TRUE
)

if (length(archivos_previos) > 0) file.remove(archivos_previos)

# guardar solo la versión vigente
nombre_salida <- file.path(
  "inputs/datos",
  paste0("eeeesp_", format(fecha_final, "%Y_%m"), ".rds")
)

saveRDS(data, nombre_salida)

message("[eeeesp::build] Archivo guardado en: ", nombre_salida)

