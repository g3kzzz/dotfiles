#!/bin/bash
set -euo pipefail

GREEN='\033[1;32m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
RESET='\033[0m'

echo -e "${GREEN}[+] Instalando open-vm-tools...${RESET}"
sudo pacman -S --noconfirm --needed open-vm-tools

echo -e "${GREEN}[+] Activando servicios necesarios...${RESET}"
sudo systemctl enable --now vmtoolsd.service
sudo systemctl enable --now vmware-vmblock-fuse.service

BSPWMRC="$HOME/.config/bspwm/bspwmrc"
echo -e "${GREEN}[+] Añadiendo comandos al inicio de BSPWM...${RESET}"

# Agrega vmware-user si no está
if ! grep -q "vmware-user &" "$BSPWMRC"; then
    echo "vmware-user &" >> "$BSPWMRC"
    echo -e "${BLUE}--> Añadido: vmware-user &${RESET}"
else
    echo -e "${YELLOW}[!] vmware-user ya estaba añadido${RESET}"
fi

# Detecta la salida de video
OUTPUT=$(xrandr | grep " connected" | awk '{ print $1 }')
echo -e "${BLUE}--> Salida de video detectada: $OUTPUT${RESET}"

# Agrega xrandr --output ... si no está
if ! grep -q "xrandr --output $OUTPUT --mode 1920x1080" "$BSPWMRC"; then
    echo "xrandr --output $OUTPUT --mode 1920x1080" >> "$BSPWMRC"
    echo -e "${BLUE}--> Añadido: xrandr --output $OUTPUT --mode 1920x1080${RESET}"
else
    echo -e "${YELLOW}[!] Resolución ya estaba configurada en bspwmrc${RESET}"
fi

# Aplica resolución inmediatamente (si posible)
echo -e "${GREEN}[+] Aplicando resolución ahora...${RESET}"
if xrandr --output "$OUTPUT" --mode 1920x1080 2>/dev/null; then
    echo -e "${GREEN}[✓] Resolución aplicada exitosamente${RESET}"
else
    echo -e "${RED}[!] No se pudo aplicar resolución 1920x1080 en $OUTPUT${RESET}"
fi

chmod +x "$BSPWMRC"

echo -e "\n${GREEN}[✓] Configuración completa. Reinicia tu sesión para que se aplique todo.${RESET}"
