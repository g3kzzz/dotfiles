#!/bin/sh

MONITOR=$(xrandr | grep " connected" | cut -d" " -f1)

# Iniciar daemon si no está corriendo
pgrep -x eww > /dev/null || eww -c ~/.config/eww/bar daemon &

# Dar tiempo a que se inicie
sleep 1


# Recargar widgets y abrir barra
eww -c ~/.config/eww/bar reload
eww -c ~/.config/eww/bar open bar --arg monitor="$MONITOR"
