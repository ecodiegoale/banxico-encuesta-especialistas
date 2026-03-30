# utils_eeeesp.R
# Proyecto: banxico-encuesta-especialistas
# github: @ecodiegoale
# Descripción: funcion auxiliar para descarga y procesamiento


download_eeeesp <- function(
    url = "https://www.banxico.org.mx/DataSetsWeb/dataset-1.zip",
    base_dir = "inputs",
    unzip_dir = file.path(base_dir, "eeeesp"),
    overwrite = TRUE,
    clean_unzip = TRUE
) {
  
  prefix <- "[eeeesp::download]"
  
  # asegurar carpetas
  if (!dir.exists(base_dir)) dir.create(base_dir, recursive = TRUE)
  
  # limpiar carpeta si se solicita
  if (dir.exists(unzip_dir) && clean_unzip) {
    unlink(unzip_dir, recursive = TRUE)
  }
  
  if (!dir.exists(unzip_dir)) dir.create(unzip_dir, recursive = TRUE)
  
  zip_path <- file.path(base_dir, basename(url))
  
  if (file.exists(zip_path) && !overwrite) {
    message(prefix, " Archivo ya existe. Saltando descarga.")
  } else {
    message(prefix, " Descargando archivo ZIP de Banxico...")
    download.file(url, destfile = zip_path, mode = "wb")
  }
  
  message(prefix, " Descomprimiendo archivos...")
  unzip(zip_path, exdir = unzip_dir)
  
  archivos <- list.files(
    unzip_dir,
    pattern = "Microdatos",
    full.names = TRUE,
    recursive = TRUE
  )
  
  message(prefix, " Archivos encontrados: ", length(archivos))
  
  return(archivos)
}
