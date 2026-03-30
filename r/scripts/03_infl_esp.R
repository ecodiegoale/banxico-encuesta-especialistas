rm(list = ls())
options(scipen=999) #para desactivar la notación científica

# Encuesta de especialistas Banco de México

# 02_infl_esp.R
# Objetivo: replicar el gráfico de inflación esperada del Reporte de la
# Encuesta sobre las Expectativas de los Especialistas en Economía
# del Sector Privado (Banco de México)
# GitHub: @ecodiegoale

# Librerías ---------------------------------------------------------------

if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")

pacman::p_load(
  tidyverse,
  writexl,
  readr,
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

# infgent
# Inflación general al cierre del año en curso (año t)

# infgentmas1
# Inflación general al cierre del siguiente año (año t+1)


datos_inf <- datos %>% 
  filter(NombreRelativoCorto %in% c("infgent",
                                    "infgentmas1")
         ) %>% 
  mutate(
    Dato = Dato/100
  )

datos_inf <- datos_inf %>% 
  group_by(FechaEncuesta, NombreRelativoCorto) %>% 
  summarise(
    media = mean(Dato, na.rm = TRUE),
    mediana = median(Dato, na.rm = TRUE),
    q25 = quantile(Dato, 0.25, na.rm = TRUE),
    q75 = quantile(Dato, 0.75, na.rm = TRUE),
    iqr = IQR(Dato, na.rm = TRUE)
  ) %>% 
  ungroup() %>% 
  mutate(
    inf_label = case_when(
      NombreRelativoCorto == "infgent" ~ "Al cierre del año en turno",
      NombreRelativoCorto == "infgentmas1" ~ "Al cierre del siguiente año"
    )
  )



ggplot(
  datos_inf %>% 
    filter(FechaEncuesta > as.Date("2024-12-01")), 
  aes(x = FechaEncuesta)
  ) +
  geom_ribbon(
    aes(ymin = q25, ymax = q75, fill = "Rango intercuantil"),
    alpha = 0.5
  ) +
  geom_line(
    aes(y = media, color = "Media"),
    linewidth = 0.8
  ) +
  geom_line(
    aes(y = mediana, color = "Mediana"),
    linetype = "dashed",
    linewidth = 0.8
  ) +
  scale_color_manual(
    values = c("Media" = "#134E8E", 
               "Mediana" = "#C00707")
  ) +
  scale_fill_manual(
    values = c("Rango intercuantil" = "#FFB33F")
  ) +
  labs(
    x = NULL,
    y = NULL,
    title = "Encuesta sobre las Expectativas de los Especialistas\nen Economía del Sector Privado",
    subtitle = "Inflación general esperada",
    color = NULL,
    fill = NULL,
    caption = "Elaboración propia con información de Banco de México\ngithub.com/ecodiegoale"
  ) +
  scale_y_continuous(
    labels = scales::percent,
    position = "right",
    limits = c(0.03, NA),
    expand = expansion(mult = c(0, 0.05))
  ) +
  scale_x_date(
    date_breaks = "2 months",
    date_labels = "%m/%y",
    expand = expansion(mult = c(0, 0))
  ) +
  guides(color = guide_legend(
    override.aes = list(linewidth = 3)
    )) +
  theme_gray(base_size = 12) +
  theme(
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5),
    plot.caption = element_text(hjust = 0.5),
    text = element_text(color = "black", family = "Dubai"),
    axis.text.x = element_text(hjust = 0.5, 
                               vjust = 0.5, 
                               angle = 90,
                               color = "black"),
    axis.text.y = element_text(color = "black"),
    plot.margin = margin(t = 5, r = 10, b = 5, l = 20),
    legend.position = "bottom",
    legend.background = element_blank(),
    legend.key = element_blank()
  ) +
  facet_wrap(~ inf_label)

ggsave("outputs/infgenexp.png",
       height = 10,
       width = 14,
       units = "cm")


