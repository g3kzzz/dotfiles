#!/bin/bash
# =============================================================
# 🐞 Instalador Real BurpSuite Community con soporte --config
# =============================================================

VERSION="2024.4.2"
URL="https://portswigger.net/burp/releases/download?product=community&version=$VERSION&type=Linux"
INSTALLER="burpsuite_community_linux.sh"
INSTALL_PATH="/opt/BurpSuiteCommunity"
WRAPPER_PATH="/usr/local/bin/burpsuite"
CONF_PATH="$HOME/.config/bspwm/scripts/conf.json"

# 📦 Verificar dependencias
if ! command -v curl &>/dev/null; then
    echo "❌ Falta curl. Instálalo con: sudo pacman -S curl"
    exit 1
fi

# 📥 Descargar el instalador
echo "⬇️ Descargando instalador oficial de BurpSuite Community..."
curl -L "$URL" -o "$INSTALLER"
chmod +x "$INSTALLER"

# 🚀 Ejecutar el instalador
echo "⚙️ Ejecutando instalador..."
sudo ./"$INSTALLER" -q -dir "$INSTALL_PATH"

# 🧹 Limpiar
rm "$INSTALLER"

# 🛠️ Crear wrapper real que permite --config
echo "🛠️ Creando /usr/local/bin/burpsuite..."
sudo tee "$WRAPPER_PATH" >/dev/null <<EOF
#!/bin/bash
exec "$INSTALL_PATH/BurpSuiteCommunity" "\$@"
EOF
sudo chmod +x "$WRAPPER_PATH"

# 🔔 Notificación
notify-send "BurpSuite" "🟢 Burp instalado. Usa:\n\nburpsuite --config $CONF_PATH"

# ✅ Final
echo -e "\n✅ BurpSuite instalado en $INSTALL_PATH"
echo "   Puedes lanzarlo así:"
echo "   burpsuite --config \"$CONF_PATH\""
