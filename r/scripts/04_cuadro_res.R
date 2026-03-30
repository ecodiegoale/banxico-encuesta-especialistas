rm(list = ls())
options(scipen=999) #para desactivar la notación científica

# Encuesta de especialistas Banco de México
# Cuadro resumen

# 04_cuadro_res.R
# Objetivo: realizar cuadro resumen como el del Reporte de la
# Encuesta sobre las Expectativas de los Especialistas en Economía
# del Sector Privado (Banco de México)
# GitHub: @ecodiegoale

# Librerías ---------------------------------------------------------------

if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")

pacman::p_load(
  tidyverse,
  writexl,
  readr,
  gt,
  extrafont
)

# font_import()
# y
loadfonts(device = "win")

# datos -------------------------------------------------------------------

codebook <- readRDS("outputs/codebook.rds")

archivo_datos <- list.files(
  "inputs/datos",
  pattern = "^eeeesp_.*\\.rds$",
  full.names = TRUE
)

datos <- readRDS(archivo_datos)


# Cuadro resumen ----------------------------------------------------------

# Ultimas dos encuestas

cuadro_res <- datos %>% 
  filter(
    FechaEncuesta %in% c(
      max(FechaEncuesta, na.rm = TRUE),
      max(FechaEncuesta, na.rm = TRUE) %m-% months(1)
    )
  )

niveles <- c(
  "infgent",
  "infgentmas1",
  "infsubt",
  "infsubtmas1",
  "varpibt",
  "varpibtmas1",
  "tccierret",
  "tcmestmas1", # es al cierre y promedio
  "fondeotmas3", # es al cierre del año t
  "fondeotmas7" # es al cierre del año t + 1
)

cuadro_res <- cuadro_res %>% 
  filter(NombreRelativoCorto %in% niveles) %>% 
  mutate(
    NombreRelativoCorto = factor(
      NombreRelativoCorto,
      levels = niveles
    )
  ) %>% 
  filter(
    NombreRelativoLargo != "Valor del tipo de cambio promedio durante el mes t+1"
  ) %>% 
  group_by(
    FechaEncuesta,
    NombreRelativoCorto,
    NombreRelativoLargo
  ) %>% 
  summarise(
    mediana = round(median(Dato, na.rm = TRUE), 2),
    media = round(mean(Dato, na.rm = TRUE), 2),
    .groups = "drop"
  ) %>% 
  arrange(FechaEncuesta)


# media
cuadro_mean <- cuadro_res %>% 
  select(-mediana) %>% 
  mutate(
    mes_encuesta = format(FechaEncuesta, "%Y-%m")
  ) %>% 
  select(-FechaEncuesta) %>% 
  tidyr::pivot_wider(
    names_from = mes_encuesta,
    values_from = media,
    names_prefix = "media_"
  )

# mediana
cuadro_mediana <- cuadro_res %>% 
  select(-media) %>% 
  mutate(
    mes_encuesta = format(FechaEncuesta, "%Y-%m")
  ) %>% 
  select(-FechaEncuesta) %>% 
  tidyr::pivot_wider(
    names_from = mes_encuesta,
    values_from = mediana,
    names_prefix = "mediana_"
  )

# join
cuadro_res <- cuadro_mean %>% 
  full_join(cuadro_mediana,
            by = c("NombreRelativoCorto",
                   "NombreRelativoLargo")
            )

writexl::write_xlsx(cuadro_res, "outputs/cuadro_res.xlsx")

# {gt} --------------------------------------------------------------------

cuadro_res <- cuadro_res %>% 
  mutate(
    bloque = case_when(
      NombreRelativoCorto %in% c("infgent", "infgentmas1") ~ "Inflación general",
      NombreRelativoCorto %in% c("infsubt", "infsubtmas1") ~ "Inflación subyacente",
      NombreRelativoCorto %in% c("varpibt", "varpibtmas1") ~ "PIB",
      NombreRelativoCorto %in% c("tccierret", "tcmestmas1") ~ "Tipo de cambio",
      NombreRelativoCorto %in% c("fondeotmas3", "fondeotmas7") ~ "Tasa de fondeo",
      TRUE ~ NA_character_
    ),
    concepto = case_when(
      NombreRelativoCorto %in% c("infgent", "infsubt", "varpibt", 
                                 "tccierret", "fondeotmas3") ~ 
        "Al cierre del año en curso",
      NombreRelativoCorto %in% c("infgentmas1", "infsubtmas1", "varpibtmas1", 
                                 "tcmestmas1", "fondeotmas7") ~ 
        "Al cierre del siguiente año",
      TRUE ~ NA_character_
    )
  )


gtabla <- cuadro_res %>%
  gt(
    rowname_col = "concepto",
    groupname_col = "bloque"
  )

gtabla <- gtabla %>% 
  cols_label(
    `media_2026-01` = "Ene 2026",
    `media_2026-02` = "Feb 2026",
    `mediana_2026-01` = "Ene 2026",
    `mediana_2026-02` = "Feb 2026"
  ) %>% 
  tab_spanner(
    label = "Media",
    columns = starts_with("media_")
  ) %>%
  tab_spanner(
    label = "Mediana",
    columns = starts_with("mediana_")
  ) %>% 
  cols_hide(
    columns = c(NombreRelativoCorto, NombreRelativoLargo)
  ) %>% 
  fmt_number(
    columns = c(starts_with("media_"), starts_with("mediana_")),
    decimals = 2
  ) %>% 
  tab_header(
    title = "Encuesta sobre las Expectativas de los Especialistas",
    subtitle = "Resultados recientes"
  ) %>% 
  tab_source_note(
    source_note = gt::html(
      "Elaboración propia con información de Banco de México<br>github.com/ecodiegoale"
    )
  )

gtabla <- gtabla %>%
  # fuente general
  tab_options(
    table.font.names = "Dubai"
  ) %>%
  
  # título
  tab_style(
    style = cell_text(weight = "bold", size = px(13)),
    locations = cells_title(groups = "title")
  ) %>%
  
  # subtítulo
  tab_style(
    style = cell_text(size = px(12), color = "gray30"),
    locations = cells_title(groups = "subtitle")
  ) %>%
  
  # encabezados de columnas
  tab_style(
    style = cell_text(size = px(12),
                      weight = "bold"),
    locations = cells_column_labels()
  ) %>%
  
  # spanners (Media / Mediana)
  tab_style(
    style = cell_text(size = px(12), 
                      weight = "bold", color = "#134E8E"),
    locations = cells_column_spanners(spanners = "Media")
  ) %>%
  tab_style(
    style = cell_text(size = px(12), 
                      weight = "bold", color = "#C00707"),
    locations = cells_column_spanners(spanners = "Mediana")
  ) %>%
  # cuerpo
  tab_style(
    style = cell_text(size = px(11)),
    locations = list(
      cells_body(),
      cells_stub()
    )
  ) %>% 
  tab_style(
    style = cell_text(size = px(12), weight = "bold"),
    locations = cells_row_groups()
  ) %>% 
  # caption (source note)
  tab_style(
    style = cell_text(color = "gray40", size = px(10)),
    locations = cells_source_notes()
  ) %>% 
  # interlineado
  tab_options(
    heading.padding = px(1.5),
    data_row.padding = px(1),
    column_labels.padding = px(1.5)
  )


gtabla

gtsave(gtabla, "outputs/cuadro_eeeesp.png")
