# --- R
# Script para crear mapa de calor de disponibiliad de datos del CHIRPS para cada estación y cada día
# DALM
# Última modificación: 26 de octibre de 2026

setwd("~/Pico_PhD")
inpath <- ("./03_OUTPUTS/02_CHIRPS/")
library(ggplot2)
library(dplyr)
library(readr)
library(tidyr)


precip <- read.csv2(paste0(inpath, "02_CHIRPS_BD_precip.csv"))
precip$date <- as.Date(precip$date)

#armado de precipitacion
precip_long <- precip %>%
  pivot_longer(
    cols = -date, 
    names_to = "Estacion", 
    values_to = "Valor"
  ) %>%
  mutate(
    Estado = ifelse(is.na(Valor), "Faltante", "Disponible")
  )


ggplot(precip_long, aes(x = date, y = Estacion, fill = Estado)) +
  geom_tile() +
  scale_fill_manual(
    values = c("Disponible" = "#00568f", "Faltante" = "#ff7300")
  ) +
  labs(
    title = "Disponibilidad de datos de Precipitación (CHIRPS)",
    x = "Fecha",
    y = "Estación",
    fill = "Estado"
  ) +
  theme_gray() +
  theme(
    axis.text.y = element_text(size = 8), 
    panel.grid = element_blank()   
  )

  ggsave(paste0(inpath, "1_MapaCalor_dispo_CHIRPS_precip.png"), get_last_plot(), width = 8, height = 11, units = "in", dpi = 300)
