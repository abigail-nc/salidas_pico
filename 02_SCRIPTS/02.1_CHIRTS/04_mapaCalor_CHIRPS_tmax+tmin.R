# --- R
# Script para crear mapa de calor de disponibiliad de datos del CHIRTS para cada estación y cada día
# DALM
# Última modificación: 26 de octibre de 2026

setwd("~/Pico_PhD")
inpath <- ("./03_OUTPUTS/02.1_CHIRTS/")
library(ggplot2)
library(dplyr)
library(readr)
library(tidyr)


tmax <- read.csv(paste0(inpath, "02.1_CHIRTS_BD_tmax.csv"))
tmax$date <- as.Date(tmax$date)

tmin <- read.csv(paste0(inpath, "00_SMN_BD_TMIN.csv"))
tmin$FECHA <- as.Date(tmax$FECHA)

#armado de tmax
tmax_long <- tmax %>%
  pivot_longer(
    cols = -date, 
    names_to = "Estacion", 
    values_to = "Valor"
  ) %>%
  mutate(
    Estado = ifelse(is.na(Valor), "Faltante", "Disponible")
  )


ggplot(tmax_long, aes(x = date, y = Estacion, fill = Estado)) +
  geom_tile() +
  scale_fill_manual(
    values = c("Disponible" = "#ff9945", "Faltante" = "#7f8081")
  ) +
  labs(
    title = "Disponibilidad de datos de Temp. Máxima (CHIRTS)",
    x = "Fecha",
    y = "Estación",
    fill = "Estado"
  ) +
  theme_gray() +
  theme(
    axis.text.y = element_text(size = 8), 
    panel.grid = element_blank()   
  )

  ggsave(paste0(inpath, "1_MapaCalor_dispo_CHIRTS_tmax.png"), get_last_plot(), width = 8, height = 11, units = "in", dpi = 300)


#armado de tmin
tmin_long <- tmin %>%
  pivot_longer(
    cols = -date, 
    names_to = "Estacion", 
    values_to = "Valor"
  ) %>%
  mutate(
    Estado = ifelse(is.na(Valor), "Faltante", "Disponible")
  )


ggplot(tmin_long, aes(x = FECHA, y = Estacion, fill = Estado)) +
  geom_tile() +
  scale_fill_manual(
    values = c("Disponible" = "#0078c9", "Faltante" = "#d2d7db")
  ) +
  labs(
    title = "Disponibilidad de datos de Precipitación (CHIRTS)",
    x = "Fecha",
    y = "Estación",
    fill = "Estado"
  ) +
  theme_gray() +
  theme(
    axis.text.y = element_text(size = 8), 
    panel.grid = element_blank()   
  )

  ggsave(paste0(inpath, "1_MapaCalor_dispo_CHIRTS_tmin.png"), get_last_plot(), width = 8, height = 11, units = "in", dpi = 300)
