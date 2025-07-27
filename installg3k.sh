#!/bin/bash

set -euo pipefail

GREEN='\033[1;32m'
RESET='\033[0m'

# -------------------------
#     ANIMACIÓN TREN
# -------------------------

smoke_frames=(
"   (   )"
"   (    )"
"   (     )"
"   (    )"
"   (   )"
"   ."
"    "
)

print_train() {
    clear
    local pos=$1
    local frame=$2
    local space=$(printf "%${pos}s" "")
    echo "${space}${smoke_frames[$frame]}"
    cat <<EOF
${space}   ___     ____       
${space}  |_ _|   |__ /   _ _     __ _      _ _    ___
${space}   | |     |_ \  | ' \   / _\` |    | '_|  / _ \ 
${space}  |___|   |___/  |_||_|  \__,_|   _|_|_   \___/
${space} _|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|
${space} "\`-0-0-'"\`-0-0-'"\`-0-0-'"\`-0-0-'"\`-0-0-'"\`-0-0-' 
EOF
}

for i in {0..20}; do
    frame=$((i % ${#smoke_frames[@]}))
    print_train "$i" "$frame"
    sleep 0.1
done
for ((i=20; i>=0; i--)); do
    frame=$((i % ${#smoke_frames[@]}))
    print_train "$i" "$frame"
    sleep 0.1
done

clear
echo -e "${GREEN}[✔] Animación finalizada. Iniciando el script...${RESET}"

# -------------------------
#     INSTALAR YAY
# -------------------------

if ! command -v yay &> /dev/null; then
    echo "[+] Instalando yay desde AUR..."
    sudo pacman -S --noconfirm --needed git base-devel || true
    cd /tmp
    git clone https://aur.archlinux.org/yay.git || true
    cd yay
    makepkg -si --noconfirm || true
    cd ~
fi

# -------------------------
#     ELIMINAR i3 Y POLYBAR
# -------------------------

echo "[+] Eliminando i3 y polybar..."
sudo pacman -Rns --noconfirm i3-wm i3-gaps polybar || true

# -------------------------
#     INSTALAR PAQUETES
# -------------------------

echo "[+] Instalando paquetes con pacman..."
sudo pacman -S --noconfirm --needed \
alacritty \
alsa-utils \
base-devel \
bat \
brightnessctl \
bspwm \
clipcat \
dbus \
dunst \
eza \
feh \
flameshot \
fzf \
git \
gnome-themes-extra \
jq \
lxappearance \
lxsession-gtk3 \
mpc \
mpd \
mpv \
neovim \
networkmanager \
ncmpcpp \
noto-fonts \
noto-fonts-emoji \
pamixer \
papirus-icon-theme \
picom \
playerctl \
polkit \
pipewire \
pipewire-pulse \
pavucontrol \
python-gobject \
qt5ct \
rofi \
rustup \
sxhkd \
tar \
ttf-font-awesome \
ttf-inconsolata \
ttf-jetbrains-mono \
ttf-jetbrains-mono-nerd \
ttf-terminus-nerd \
ttf-ubuntu-mono-nerd \
unzip \
xclip \
xdg-user-dirs \
xdo \
xdotool \
xorg \
xorg-xdpyinfo \
xorg-xinit \
xorg-xkill \
xorg-xprop \
xorg-xrandr \
xorg-xsetroot \
xorg-xwininfo \
xsettingsd \
libnotify \
xf86-input-libinput \
zsh \
zsh-autosuggestions \
zsh-syntax-highlighting || true
# -------------------------
#     INSTALAR LIBREWOLF
# -------------------------

echo "[+] Instalando LibreWolf desde AUR..."
yay -S --noconfirm librewolf || true
echo "LibreWolf instalado correctamente"

# -------------------------
#     INSTALAR EWW (AUR)
# -------------------------

echo "[+] Instalando EWW desde AUR..."
yay -S --noconfirm eww || true
# ----------------------------
#   INSTALAR LY (DISPLAY MANAGER)
# ----------------------------

echo "[+] Instalando LY Display Manager..."
yay -S --noconfirm ly || true
echo "[+] Habilitando ly.service para el arranque..."
sudo systemctl enable ly.service || true
echo "Display Manager" "LY instalado y habilitado correctamente"

# -------------------------
#     HABILITAR SERVICIOS
# -------------------------

sudo systemctl enable NetworkManager || true
sudo systemctl start NetworkManager || true
echo "exec bspwm" > ~/.xinitrc
chsh -s /bin/zsh || true

# -------------------------
#     INSTALAR OH-MY-ZSH
# -------------------------

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "[+] Instalando Oh My Zsh..."
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
fi

git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions || true

git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting || true

# -------------------------
#     CONFIGURACIÓN DOTFILES
# -------------------------

CONFIG_DIR="$HOME/.config/i3naro_temp"
REPO_URL="https://github.com/g333k/blackbspwm.git"

echo "[+] Clonando repositorio $REPO_URL ..."
rm -rf "$CONFIG_DIR"
git clone "$REPO_URL" "$CONFIG_DIR" || true

echo "[+] Copiando configuraciones a ~/.config ..."

mkdir -p "$HOME/.config"
for dir in alacritty bspwm dunst eww nvim picom rofi sxhkd; do
    mkdir -p "$HOME/.config/$dir"
    cp -r "$CONFIG_DIR/config/$dir/"* "$HOME/.config/$dir/" 2>/dev/null || true
done

echo "[+] Copiando archivos personales a $HOME ..."
cp -f "$CONFIG_DIR/home/.zshrc" "$HOME/" || true

mkdir -p "$HOME/.bin"
cp -r "$CONFIG_DIR/home/.bin/"* "$HOME/.bin/" 2>/dev/null || true

mkdir -p "$HOME/Pictures/.wallpapers"
cp -r "$CONFIG_DIR/home/Pictures/.wallpapers/"* "$HOME/Pictures/.wallpapers/" 2>/dev/null || true

# -------------------------
#     CARPETAS ESTÁNDAR
# -------------------------

echo "[+] Creando carpetas de usuario..."
mkdir -p "$HOME/Documents" "$HOME/Downloads" "$HOME/Music" "$HOME/Videos" "$HOME/Pictures/Clipboard"

# -------------------------
#     LIMPIEZA Y FINAL
# -------------------------

echo "[+] Eliminando temporales..."
rm -rf "$CONFIG_DIR"

if [ -f "$HOME/.zshrc" ]; then
    echo "[+] Recargando ZSH..."
    source "$HOME/.zshrc" || true
fi
echo "[+] Configurando ZSH para el usuario root..."

sudo ln -sf /home/g3k/.zshrc /root/.zshrc
sudo ln -s /home/g3k/.oh-my-zsh /root/.oh-my-zsh

sudo mkdir -p /root/.oh-my-zsh/custom/plugins

sudo ln -s /home/g3k/.oh-my-zsh/custom/plugins/zsh-autosuggestions /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions
sudo ln -s /home/g3k/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

echo "[✓] ZSH configurado para root correctamente."

echo -e "${GREEN}[✔] Todo listo. El entorno ha sido configurado correctamente.${RESET}"
