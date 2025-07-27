#!/bin/sh

# Variables necesarias
export XDG_CURRENT_DESKTOP="bspwm"
export _JAVA_AWT_WM_NONREPARENTING=1

# Ejecutar demonios necesarios
pgrep -x sxhkd  > /dev/null || sxhkd &
pgrep -x picom  > /dev/null || picom --config ~/.config/picom/picom.conf &
pgrep -x dunst  > /dev/null || dunst &
pgrep -x xsettingsd > /dev/null || xsettingsd &

# Esperar a que el entorno se estabilice
sleep 1

# Ejecutar barra de EWW
~/.config/eww/bar/reload-eww.sh &
