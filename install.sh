#!/bin/bash
set -e

# ============================================================
#                    G3K INSTALLER (v2)
#                Author: g3kzzz | Arch Linux
# ============================================================

# -------------------------
# ROOT RESTRICTION
# -------------------------
if [[ $EUID -eq 0 ]]; then
  echo "[!] Do not run this script directly as root."
  echo "[!] Run it as a normal user."
  exit 1
fi

# -------------------------
# GLOBAL VARIABLES
# -------------------------
TMP_SUDOERS="/etc/sudoers.d/99_g3k_tmp"
MUSIC_DIR="$HOME/.config/music"
BANNER="
 
 _____  _______ _______ _______ _______ _____   _______ _______ 
|     \|       |_     _|    ___|_     _|     |_|    ___|     __|
|  --  |   -   | |   | |    ___|_|   |_|       |    ___|__     |
|_____/|_______| |___| |___|   |_______|_______|_______|_______|
                                                                                 
                        Made by: g3kzzz
            Repo: https://github.com/g3kzzz/dotfiles            
"

# -------------------------
# DISPLAY BANNER (persistent)
# -------------------------
show_banner() {
  clear
  echo -e "$BANNER"
  echo
}

# -------------------------
# CLEAR BELOW LOGO ONLY
# -------------------------
clear_below_logo() {
  tput cup 15 0  # Mueve el cursor a la línea 15
  tput ed         # Limpia desde esa posición hacia abajo
}

# -------------------------
# SLOW PRINT FUNCTION
# -------------------------
slow_print() {
  local text="$1"
  for ((i=0; i<${#text}; i++)); do
    echo -n "${text:$i:1}"
    sleep 0.000
  done
  echo
}

# -------------------------
# SUDO FUNCTION (password reuse)
# -------------------------
run_sudo() {
  echo "$SUDO_PASS" | sudo -S "$@"
}

# -------------------------
# PAUSE & CLEAN BELOW LOGO
# -------------------------
pause_and_clear() {
  sleep 1.5
  clear_below_logo
}

# ============================================================
# STEP 1 - SHOW LOGO AND ASK CONFIRMATION
# ============================================================
show_banner
echo
read -p " Do you want to continue with the installation? (Y/n): " confirm
confirm=${confirm,,}  # lowercase

if [[ -z "$confirm" || "$confirm" == "y" || "$confirm" == "yes" ]]; then
  echo " [+] Continuing installation..."
  sleep 1
else
  echo " [!] Installation cancelled by user."
  exit 0
fi

clear_below_logo

# ============================================================
# STEP 2 - PASSWORD HANDLING
# ============================================================
while true; do
  echo -n "🔑 Enter your sudo password: "
  read -s SUDO_PASS
  echo
  if echo "$SUDO_PASS" | sudo -S -v &>/dev/null; then
    echo "✅ Password accepted"
    break
  else
    echo "❌ Wrong password, try again."
  fi
done
pause_and_clear

# ============================================================
# STEP 3 - TEMPORARY SUDOERS FOR INSTALLATION
# ============================================================
echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/pacman, /usr/bin/makepkg, /usr/bin/chsh" | sudo tee "$TMP_SUDOERS" >/dev/null

# ============================================================
# STEP 4 - PACKAGE INSTALL FUNCTIONS
# ============================================================
install_pacman() {
  for pkg in "$@"; do
    if pacman -Qi "$pkg" &>/dev/null; then
      echo " [✓] $pkg already installed"
    else
      echo " [+] Installing $pkg..."
      if echo "$SUDO_PASS" | sudo -S pacman -S --needed --noconfirm "$pkg" &>/dev/null; then
        echo " [✓] $pkg installed"
      else
        echo " [!] Failed to install $pkg"
      fi
    fi
  done
}

install_yay() {
  for pkg in "$@"; do
    if yay -Qi "$pkg" &>/dev/null; then
      echo " [✓] $pkg already installed"
    else
      echo " [+] Installing $pkg..."
      if yay -S --needed --noconfirm "$pkg" &>/dev/null; then
        echo " [✓] $pkg installed"
      else
        echo " [!] Failed to install $pkg"
      fi
    fi
  done
}

# ============================================================
# STEP 5 - YAY INSTALLATION
# ============================================================
echo " [+] Checking YAY..."
if ! command -v yay &>/dev/null; then
  echo " [+] Installing yay..."
  cd /tmp
  git clone https://aur.archlinux.org/yay.git &>/dev/null
  cd yay && makepkg -si --noconfirm <<<"$SUDO_PASS" &>/dev/null
  cd ~
  echo " [✓] yay installed"
else
  echo " [✓] yay already installed"
fi
pause_and_clear

# ============================================================
# STEP 6 - INSTALL PACKAGES
# ============================================================
PACMAN_TOOLS=(
  xorg xorg-xinit bspwm lxdm sxhkd picom feh ttf-fira-code adobe-source-code-pro-fonts ttf-inconsolata ttf-hack ttf-cascadia-code ttf-ibm-plex alacritty zsh tmux eza bat xclip brightnessctl pamixer rofi thunar  gvfs gvfs-mtp tumbler ffmpegthumbnailer ttf-jetbrains-mono ttf-jetbrains-mono-nerd papirus-icon-theme picom gnome-themes-extra dunst libnotify flameshot
)

YAY_TOOLS=( eww bash-language-server xautolock i3lock-color librewolf-bin )

echo " [+] Installing PACMAN tools..."
install_pacman "${PACMAN_TOOLS[@]}"
pause_and_clear

echo " [+] Installing YAY tools..."
install_yay "${YAY_TOOLS[@]}"
pause_and_clear

# ============================================================
# STEP 7 - SERVICES & CONFIG
# ============================================================
run_sudo systemctl enable lxdm.service || true
run_sudo systemctl enable NetworkManager || true
run_sudo systemctl start NetworkManager || true
echo "exec bspwm" > ~/.xinitrc
run_sudo chsh -s /bin/zsh "$USER"
pause_and_clear

# ============================================================
# STEP 8 - ZSH & PLUGINS
# ============================================================
echo " [+] Installing Oh My Zsh and plugins..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" 2>/dev/null || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" 2>/dev/null || true
pause_and_clear

# ============================================================
# STEP 9 - DOTFILES & USER FOLDERS
# ============================================================
echo " [+] Creating folders and applying dotfiles..."
mkdir -p "$HOME"/{Documents,Desktop,CTF,Downloads,Pictures/Clipboard}
git clone https://github.com/g3kzzz/dotfiles || true
cp -r dotfiles/config/* ~/.config/ || true
cp -r dotfiles/home/.librewolf ~/ || true 
cp -f dotfiles/home/.zshrc ~/.zshrc 
source "$HOME/.zshrc" || true
pause_and_clear

# ============================================================
# STEP 10 - ROOT CONFIG SYNC
# ============================================================
echo " [+] Applying configuration for root..."
run_sudo chsh -s /bin/zsh root
run_sudo cp -r ~/.oh-my-zsh /root/ || true
run_sudo cp -r ~/.zshrc /root/ || true
run_sudo cp -r ~/.config /root/ || true
pause_and_clear

# ============================================================
# STEP 12 - CLEANUP
# ============================================================
echo " [+] Cleaning up sudoers..."
run_sudo rm -f "$TMP_SUDOERS" || true
pause_and_clear

# ============================================================
# DONE
# ============================================================
echo " ============================================================"
echo " [✓] All done."
echo " [✓] The environment has been configured."
echo "============================================================"
