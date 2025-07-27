#!/bin/sh
# ===============================================
#       ⠀⠀⢀⣴⣿⣷⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#       ⠀⢠⣿⣿⢿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#       ⢀⡾⠋⠀⣰⣿⣿⠻⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#       ⠘⠀⠀⢠⣿⣿⠃⠀⠈⠻⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#       ⠀⠀⠀⢸⣿⡇⠀⠀⠀⣼⣉⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⠀
#       ⠀⠀⠀⢹⣿⡇⠀⠀⠀⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠟⣿⠉⠁
#       ⠀⠀⠀⠸⣿⣿⣄⠀⠀⠘⢿⣿⡵⠋⠙⢿⣦⡀⠀⠀⣤⣠⠀⣠⣿⡅⠀⣿⠀⠀
#       ⠀⠀⠀⠀⠈⠻⢿⣿⣶⣤⣄⣀⠀⠀⠀⠈⠻⣷⣄⣠⣿⣿⡼⠋⠛⣡⡼⠋⠀⠀
#       ⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠛⠻⠿⠿⠷⠶⠶⠾⣿⡿⠋⠻⣟⠉⠁⠀⠀⠀⠀⠀
#       ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⠶⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
# Author: g3k
# Rep: https://github.com/IamGenarov/blackbspwm
# ===============================================

VPN_CONFIG="$HOME/.config/bspwm/scripts/htb.ovpn"
LOGFILE="$HOME/htb-vpn.log"
ICON_VPN_ON="🔐"
ICON_VPN_OFF="📴"

if pgrep -x openvpn >/dev/null; then
    notify-send "HTB VPN" "$ICON_VPN_OFF Desconectando..."
    sudo pkill openvpn
    sleep 2
    if ip a | grep -q tun0; then
        notify-send "HTB VPN" "❌ Falló la desconexión"
    else
        notify-send "HTB VPN" "$ICON_VPN_OFF VPN desconectada"
    fi
else
    notify-send "HTB VPN" "$ICON_VPN_ON Conectando..."
    sudo openvpn --config "$VPN_CONFIG" --daemon --log "$LOGFILE"
    sleep 5
    if ip a | grep -q tun0; then
        notify-send "HTB VPN" "$ICON_VPN_ON Conectado correctamente"
    else
        notify-send "HTB VPN" "❌ Error al conectar, revisa $LOGFILE"
    fi
fi

