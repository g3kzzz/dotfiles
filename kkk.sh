#!/bin/bash
set -e

# ⚙️ COLORES
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
CYAN=$(tput setaf 6)
RESET=$(tput sgr0)

# 📦 INSTALAR PAQUETES BASE
BASE_PKGS=(
  tree samba wget net-tools arp-scan
  nmap wireshark-qt john aircrack-ng hydra
  tcpdump metasploit gobuster hashcat sqlmap
  ettercap-gtk netcat hping tshark whois dnsutils
  openvpn zmap ngrep ipscan
)

echo "${CYAN}🔧 Instalando herramientas básicas desde pacman...${RESET}"
for pkg in "${BASE_PKGS[@]}"; do
  echo "${CYAN}Instalando ${pkg}...${RESET}"
  sudo pacman -S --noconfirm --needed "$pkg" || echo "${RED}❌ No se pudo instalar $pkg${RESET}"
done

# ☕️ INSTALAR JAVA 17 (Requerido por BurpSuite)
echo "${CYAN}☕ Instalando Java 17...${RESET}"
sudo pacman -S --noconfirm --needed jdk17-openjdk
sudo archlinux-java set java-17-openjdk

# 🐧 HERRAMIENTAS DESDE YAY
YAY_PKGS=(
  burpsuite dirb ffuf zaproxy
)

echo "${CYAN}📦 Instalando herramientas desde AUR (yay)...${RESET}"
for pkg in "${YAY_PKGS[@]}"; do
  echo "${CYAN}Instalando ${pkg}...${RESET}"
  yay -S --noconfirm "$pkg" || echo "${RED}❌ No se pudo instalar $pkg${RESET}"
done

# 🗂️ SECLISTS
echo "${CYAN}📚 Clonando SecLists...${RESET}"
cd /usr/share
if [ ! -d "SecLists" ]; then
  sudo git clone https://github.com/danielmiessler/SecLists.git
else
  echo "${GREEN}SecLists ya existe. Omitido.${RESET}"
fi

# 📁 EXPLOIT-DB Y SEARCHSPLOIT
echo "${CYAN}📂 Clonando Exploit-DB...${RESET}"
if [ ! -d /opt/exploitdb ]; then
  sudo git clone https://gitlab.com/exploit-database/exploitdb.git /opt/exploitdb
  sudo ln -sf /opt/exploitdb/searchsploit /usr/local/bin/searchsploit
else
  echo "${GREEN}Exploit-DB ya existe. Omitido.${RESET}"
fi

# 🧪 EXTRA OPCIONAL: HERRAMIENTAS ÚTILES EN OSCP
EXTRA_PKGS=(
  rlwrap enum4linux smbclient nbtscan
  xclip xsel amass rustscan
  crackmapexec rsync
)

echo "${CYAN}🧰 Instalando herramientas extra...${RESET}"
for pkg in "${EXTRA_PKGS[@]}"; do
  echo "${CYAN}Instalando ${pkg}...${RESET}"
  yay -S --noconfirm "$pkg" || echo "${RED}❌ No se pudo instalar $pkg${RESET}"
done

echo ""
echo "${GREEN}✅ Instalación completa.${RESET}"
