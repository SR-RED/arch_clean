#!/bin/bash
# Autor: Geng4r
# Fecha: 2023-10-06
# Descripción: Este script realiza mantenimiento del sistema archlinux.

# Colores ANSI
rojo='\033[0;31m'
verde='\033[0;32m'
amarillo='\033[1;33m'
reset='\033[0m'

echo -e "${amarillo}Iniciando el script de mantenimiento profundo...${reset}"

# Actualizar el sistema
echo -e "${verde}Actualizando el sistema...${reset}"
sudo pacman -Syu --noconfirm

# Limpiar la caché de paquetes
echo -e "${verde}Limpiando la caché de paquetes...${reset}"
sudo pacman -Sc --noconfirm

# Limpiar el caché de Pacman
echo -e "${verde}Limpiando el caché de Pacman...${reset}"
sudo pacman -Scc --noconfirm

# Eliminar paquetes huérfanos
echo -e "${verde}Eliminando paquetes huérfanos...${reset}"
sudo pacman -Rns $(pacman -Qdtq) --noconfirm

# Limpiar el historial del shell (bash)
history -c
history -w

# Limpiar registros antiguos
echo -e "${verde}Limpiando registros antiguos...${reset}"
sudo journalctl --vacuum-time=7d

# Limpiar cachés y temporales
echo -e "${verde}Limpiando cachés y temporales...${reset}"
sudo rm -rf /tmp/*
sudo rm -rf ~/.cache/*

# Desfragmentar el sistema de archivos (solo si estás usando ext4)
if [[ $(stat -f -c %T /) == "ext4" ]]; then
  echo -e "${verde}Desfragmentando el sistema de archivos (ext4)...${reset}"
  sudo e4defrag /
fi

# Btrfs: desfragmentar y equilibrar
if [[ $(stat -f -c %T /) == "btrfs" ]]; then
  echo -e "${verde}Desfragmentando y equilibrando el sistema de archivos (Btrfs)...${reset}"
  sudo btrfs filesystem defragment -r /
  sudo btrfs balance start /
fi

# Actualizar la base de datos de locate
echo -e "${verde}Actualizando la base de datos de locate...${reset}"
sudo updatedb

# Reiniciar servicios
echo -e "${verde}Reiniciando servicios...${reset}"
sudo systemctl restart NetworkManager

echo -e "${amarillo}Mantenimiento profundo completado.${reset}"
