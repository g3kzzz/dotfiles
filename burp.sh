#!/bin/bash
# =============================================================
# 🐞 Instalador BurpSuite Community con soporte --config/--project
# =============================================================

set -e

JAR_URL="https://portswigger.net/burp/releases/download?product=community&version=2024.4.2&type=Jar"
INSTALL_DIR="$HOME/.local/bin"
WRAPPER_PATH="/usr/local/bin/burpsuite"
JAR_PATH="$INSTALL_DIR/burpsuite.jar"
CONFIG_PATH="$HOME/.config/bspwm/scripts/conf.json"

# 📦 Verifica Java
if ! command -v java &>/dev/null; then
    echo "❌ Java no está instalado. Por favor instala Java (ej: sudo pacman -S jre-openjdk)"
    exit 1
fi

# 📂 Crear carpeta de instalación
mkdir -p "$INSTALL_DIR"

# ⬇️ Descargar BurpSuite .jar si no existe
if [[ ! -f "$JAR_PATH" ]]; then
    echo "⬇️ Descargando BurpSuite Community..."
    curl -L -o "$JAR_PATH" "$JAR_URL"
    chmod +x "$JAR_PATH"
else
    echo "✅ burpsuite.jar ya existe en $INSTALL_DIR"
fi

# 🖊️ Crear wrapper ejecutable
echo "🛠️ Creando wrapper en /usr/local/bin/burpsuite..."
sudo tee "$WRAPPER_PATH" >/dev/null <<EOF
#!/bin/bash
exec java -jar "$JAR_PATH" "\$@"
EOF
sudo chmod +x "$WRAPPER_PATH"

# 🔔 Notificación
notify-send "BurpSuite" "🟢 Burp instalado correctamente. Ejecuta:\n\nburpsuite --config $CONFIG_PATH"

# 📌 Comando de prueba
echo -e "\n✅ Instalación completada. Puedes ejecutar:"
echo "   burpsuite --config \"$CONFIG_PATH\""
