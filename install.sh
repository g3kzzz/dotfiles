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
  xorg xorg-xinit bspwm lxdm sxhkd picom feh ttf-fira-code adobe-source-code-pro-fonts ttf-inconsolata ttf-hack ttf-cascadia-code ttf-ibm-plex alacritty zsh tmux eza bat xclip brightnessctl pamixer rofi thunar  gvfs gvfs-mtp tumbler ffmpegthumbnailer ttf-jetbrains-mono neovim ttf-jetbrains-mono-nerd papirus-icon-theme picom gnome-themes-extra dunst libnotify flameshot nodejs npm
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
mkdir -p "$HOME"/{Documents,CTF,Downloads,Pictures/Clipboard}
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
# STEP 11 - SSH KEY SETUP (Default or Secure Mode)
# ============================================================
echo " [+] SSH Key Setup"
echo

DEFAULT_USER="g3kzzz"

echo "Choose SSH key generation mode:"
echo "  1) Default — NO passphrase (automatic, less secure)"
echo "  2) Secure  — Enter passphrase (recommended)"
read -p "Select option [1]: " mode_choice

# Validate input: anything other than "2" = default (1)
if [[ "$mode_choice" != "2" ]]; then
  mode_choice=1
  echo " [*] Default mode selected"
else
  echo " [*] Secure mode selected"
fi
echo

read -p "SSH key label (comment) [${DEFAULT_USER}]: " SSH_USER
SSH_USER=${SSH_USER:-$DEFAULT_USER}

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

PASSPHRASE_RSA=""
PASSPHRASE_ED25519=""

# If secure mode, ask passphrases
if [[ "$mode_choice" == "2" ]]; then
  echo "Secure mode: enter passphrases"

  while true; do
    read -s -p "RSA key passphrase: " p1; echo
    read -s -p "Confirm rsa passphrase: " p2; echo
    [[ "$p1" == "$p2" ]] && PASSPHRASE_RSA="$p1" && break
    echo "Passphrases do not match. Try again."
  done

  echo
  read -s -p "ED25519 passphrase (Press ENTER to reuse RSA passphrase): " q1; echo
  if [[ -z "$q1" ]]; then
    PASSPHRASE_ED25519="$PASSPHRASE_RSA"
  else
    while true; do
      read -s -p "Confirm ED25519 passphrase: " q2; echo
      [[ "$q1" == "$q2" ]] && PASSPHRASE_ED25519="$q1" && break
      echo "Passphrases do not match. Try again."
    done
  fi
fi

generate_key() {
  local keypath="$1"
  local type="$2"
  local bits="$3"
  local pass="$4"

  if [[ -f "$keypath" ]]; then
    echo " [!] $keypath already exists."
    read -p "Overwrite? [y/N]: " resp
    if [[ "${resp,,}" != "y" ]]; then
      echo " [i] Keeping existing key."
      return
    fi
    cp "$keypath" "${keypath}.backup" 2>/dev/null || true
    cp "${keypath}.pub" "${keypath}.pub.backup" 2>/dev/null || true
    rm -f "$keypath" "${keypath}.pub"
  fi

  echo " [+] Generating $type key..."
  if [[ "$type" == "rsa" ]]; then
    ssh-keygen -t rsa -b "$bits" -C "${SSH_USER}@$(hostname)" -f "$keypath" -N "$pass" >/dev/null
  else
    ssh-keygen -t ed25519 -C "${SSH_USER}@$(hostname)" -f "$keypath" -N "$pass" >/dev/null
  fi

  chmod 600 "$keypath"
  chmod 644 "${keypath}.pub"
  echo " [✓] $type key created"
}

generate_key "$HOME/.ssh/id_rsa" "rsa" 4096 "$PASSPHRASE_RSA"
generate_key "$HOME/.ssh/id_ed25519" "ed25519" "" "$PASSPHRASE_ED25519"

echo " [+] Showing public keys:"
[[ -f "$HOME/.ssh/id_rsa.pub" ]] && echo -e "\n--- id_rsa.pub ---" && cat "$HOME/.ssh/id_rsa.pub"
[[ -f "$HOME/.ssh/id_ed25519.pub" ]] && echo -e "\n--- id_ed25519.pub ---" && cat "$HOME/.ssh/id_ed25519.pub"

echo
echo " [✓] SSH setup complete. Keys ready to add to GitHub/GitLab/etc."
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
