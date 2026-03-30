# Automatización y análisis de la Encuesta sobre las Expectativas de los Especialistas en Economía del Sector Privado de Banco de México

![R](https://img.shields.io/badge/Made%20with-R-276DC3?logo=r) ![Status](https://img.shields.io/badge/Status-Active-brightgreen)

------------------------------------------------------------------------

## 🗒️ Contenido

-   [Descripción](#descripción)
-   [Estructura del repositorio](#estructura-del-repositorio)
-   [Scripts](#scripts)
-   [Resultados / Outputs](#resultados--outputs)
-   [Autor y contacto](#autor-y-contacto)

------------------------------------------------------------------------

## 🧩 Descripción

Este proyecto automatiza la **descarga, construcción y análisis de los microdatos** de la **Encuesta sobre las Expectativas de los Especialistas en Economía del Sector Privado** publicada por **Banco de México**.

El objetivo principal es construir un flujo de trabajo reproducible en **R** para actualizar de manera ordenada la base de microdatos, explorar el catálogo de variables disponible y generar algunos productos analíticos básicos, como gráficos de expectativas y cuadros de resultados recientes.

El proyecto está diseñado como un pipeline compacto y transparente, orientado a facilitar el seguimiento de variables clave como:

-   inflación general esperada

-   inflación subyacente esperada

-   crecimiento esperado del PIB

-   tipo de cambio esperado

-   tasa de fondeo esperada

La lógica del repositorio separa la **construcción de la base** del **análisis**, de manera que el usuario pueda actualizar la información conforme Banco de México publique nuevas observaciones, sin reescribir manualmente rutas o nombres de archivos. La base consolidada se guarda en formato `.rds`, mientras que algunos productos auxiliares se exportan también en formatos como `.xlsx`.

El flujo de trabajo está completamente desarrollado en **R**, bajo una lógica *tidyverse*, e implementa procedimientos reproducibles para:

-   Descargar y descomprimir automáticamente los microdatos publicados por Banco de México.

-   Consolidar los archivos disponibles en una sola base de trabajo.

-   Generar un descriptor o *codebook* básico de variables a partir de las observaciones recientes.

-   Construir gráficos descriptivos de expectativas y cuadros resumen con medias y medianas.

-   Exportar resultados para uso posterior en análisis, presentaciones o notas técnicas.

------------------------------------------------------------------------

## 📁 Estructura del repositorio

banxico-encuesta-especialistas/

├── inputs/ \# Datos de entrada y base consolidada

├── outputs/ \# Resultados y cuadros exportados

├── r/ \# Scripts y utilidades en R

├── README.md \# Este archivo

└── .gitignore

------------------------------------------------------------------------

## ⚙️ Scripts

| Script | Descripción | Salidas principales |
|:----------------------|:-------------------|:----------------------------|
| `01_build_dataset.R` | Descarga, descomprime, consolida y guarda la base de microdatos | Base consolidada en `.rds` |
| `02_codebook.R` | Construye un descriptor básico de variables con observaciones recientes | `codebook.rds` y `codebook.xlsx` |
| `03_infl_esp.R` | Genera gráficos descriptivos de inflación esperada | Gráficos |
| `04_cuadro_res.R` | Construye cuadros de resultados recientes con medias y medianas | Tabla resumen |

------------------------------------------------------------------------

## 📊 Resultados / Outputs

-   Base consolidada de microdatos en formato `.rds`

-   Codebook de variables recientes en `.rds` y `.xlsx`

-   Gráficos de expectativas de inflación

-   Cuadros resumen listos para análisis o presentación

-   Carpeta `outputs/` con productos derivados del pipeline

------------------------------------------------------------------------

## 🪪 Autor y contacto

Diego Alejandro Sánchez Rodríguez

🐱 GitHub: @ecodiegoale

Elaboración propia con información de Banco de México.

Proyecto reproducible en R | @ecodiegoale