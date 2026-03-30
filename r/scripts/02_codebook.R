rm(list = ls())
options(scipen=999) #para desactivar la notación científica

# Encuesta de especialistas Banco de México
# Descriptor de variables

# Librerías ---------------------------------------------------------------

if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")

pacman::p_load(
  dplyr,
  writexl,
  readr
)

# datos -------------------------------------------------------------------

archivo_datos <- list.files(
  "inputs/datos",
  pattern = "^eeeesp_.*\\.rds$",
  full.names = TRUE
)

datos <- readRDS(archivo_datos)

codebook <- datos %>% 
  filter(
    FechaEncuesta %in% c(
      max(FechaEncuesta, na.rm = TRUE),
      max(FechaEncuesta, na.rm = TRUE) %m-% months(1)
    )
  ) %>% 
  select(starts_with("NombreRelativo")) %>% 
  distinct() 

# asegurar carpeta de salida ---------------------------------------------

if (!dir.exists("outputs")) dir.create("outputs", recursive = TRUE)

saveRDS(codebook, "outputs/codebook.rds")
write_xlsx(codebook, "outputs/codebook.xlsx")