#!/bin/bash
# =============================================================
#       🐺 LibreWolf Setup: Zoom, Fuente & Dark Reader
# =============================================================

# 🧠 Detectar perfil activo real de LibreWolf
PROFILE=$(find ~/.librewolf -maxdepth 1 -type d -name "*.default*" | head -n 1)

if [ ! -d "$PROFILE" ]; then
    echo "❌ No se encontró perfil de LibreWolf en ~/.librewolf/"
    exit 1
fi

echo "✅ Perfil detectado: $PROFILE"

# 📁 Crear user.js con zoom y fuente configurados
cat > "$PROFILE/user.js" <<'EOF'
user_pref("zoom.defaultPercent", 120);
user_pref("zoom.minPercent", 30);
user_pref("zoom.maxPercent", 300);
user_pref("browser.zoom.siteSpecific", false);

user_pref("font.minimum-size.x-western", 18);
user_pref("font.size.variable.x-western", 18);
user_pref("font.name.sans-serif.x-western", "Ubuntu");
EOF

echo "✅ Archivo user.js creado con zoom 120% y fuente Ubuntu 18px"

# 🧼 Limpiar archivos conflictivos
rm -f "$PROFILE/prefs.js" "$PROFILE/compatibility.ini"
echo "🧼 prefs.js y compatibility.ini eliminados"

# 🔒 Bloquear prefs.js
touch "$PROFILE/prefs.js"
chmod u-w "$PROFILE/prefs.js"
echo "🔒 prefs.js bloqueado contra cambios (chmod u+w para revertir)"

# 🧩 Instalar Dark Reader
EXT_DIR="$PROFILE/extensions"
mkdir -p "$EXT_DIR"
XPI_PATH="$EXT_DIR/darkreader@darkreader.org.xpi"

if [ -f "$XPI_PATH" ]; then
    echo "✅ Dark Reader ya está instalado en $XPI_PATH"
else
    echo "🌐 Buscando .xpi de Dark Reader en ~/Descargas..."
    LOCAL_XPI=$(find ~/Descargas -iname "darkreader*.xpi" | head -n 1)

    if [ -f "$LOCAL_XPI" ]; then
        cp "$LOCAL_XPI" "$XPI_PATH"
        echo "✅ Dark Reader instalado desde Descargas"
    else
        echo "🌐 Descargando Dark Reader desde Mozilla..."
        curl -L "https://addons.mozilla.org/firefox/downloads/latest/darkreader/addon-1865-latest.xpi" -o "$XPI_PATH"
        if [ $? -ne 0 ]; then
            echo "❌ No se pudo descargar Dark Reader. Descárgalo manualmente desde:"
            echo "👉 https://addons.mozilla.org/en-US/firefox/addon/darkreader/"
            exit 1
        fi
        echo "✅ Dark Reader descargado correctamente"
    fi
fi

# ⚙️ Activar extensión en extensions.json (NO garantiza activación real)
cat > "$PROFILE/extensions.json" <<EOF
{
  "schemaVersion": 32,
  "addons": [
    {
      "id": "darkreader@darkreader.org",
      "active": true,
      "userDisabled": false,
      "path": "$XPI_PATH",
      "type": "extension"
    }
  ]
}
EOF
echo "✅ Registro en extensions.json generado (puede no activarse sin firma)"

# 📌 Pinear el ícono de Dark Reader en la barra (xulstore.json)
cat > "$PROFILE/xulstore.json" <<EOF
{
  "chrome://browser/content/browser.xhtml": {
    "navigator-toolbox": {
      "ordermap": ["nav-bar"]
    },
    "nav-bar": {
      "currentset": "unified-extensions-button",
      "visible": true
    },
    "unified-extensions-button": {
      "pinned": true
    }
  }
}
EOF
echo "📌 Icono de Dark Reader pineado en la barra de herramientas"

echo -e "\n🚀 ¡LibreWolf está listo con Dark Reader, zoom y fuente personalizados!"
