# Matar cualquier instancia previa
pkill -x eww 2>/dev/null || true

# Iniciar daemon
eww daemon --config "${HOME}/.config/eww" &

# Esperar a que el daemon esté listo (poll loop)
for i in $(seq 1 10); do
    if eww state >/dev/null 2>&1; then
        break
    fi
    sleep 0.3
done

# Abrir la barra
MONITOR=$(bspc query -M --names | head -n 1)
eww open bar --config "${HOME}/.config/eww" --arg monitor="$MONITOR" &

