# banxico-encuesta-especialistas

Proyecto en R para automatizar la descarga, procesamiento y generación de insumos analíticos a partir de la Encuesta sobre las Expectativas de los Especialistas en Economía del Sector Privado (Banco de México).

## Objetivo

Construir un flujo reproducible que permita:
- descargar los microdatos de la encuesta
- limpiarlos y estructurarlos
- generar cuadros y visualizaciones para análisis

## Estructura del proyecto

├─ R/
│ └─ scripts/
├─ inputs/
│ └─ datos/
├─ outputs/
│ └─ cuadros_graficos/
├─ banxico-encuesta-especialistas.Rproj
├─ .gitignore
├─ README.md


## Principios

- Los datos crudos (`inputs/datos/`) no se versionan
- Los outputs (`outputs/`) son reproducibles y no se versionan
- El repositorio contiene únicamente código y estructura

## Uso

1. Ejecutar los scripts de descarga en `R/scripts/`
2. Ejecutar los scripts de limpieza y transformación
3. Generar outputs a partir de los datos procesados

## Requisitos

- R >= 4.x
- tidyverse (u otros paquetes utilizados en los scripts)

## Notas

Este proyecto está diseñado bajo un enfoque de reproducibilidad: cualquier output debe poder generarse a partir de los scripts y datos descargados.


