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
_⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠈⠟⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠿⠿⠿⠿⠛⠋⠁⡀⢸
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠠⢀⠐⡠⡀⢈⡄⡂⠥⢌⠤⡐⡔⡐⢢⠒⡰⡀⢿
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⢂⡐⢠⡁⠆⡄⠊⢖⡡⠙⣤⢓⡐⠴⣉⢎⡒⠥⢱⠈⡴⢡⡙⢤⢂⣿
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠈⡄⡑⢤⠈⢢⠐⡕⠌⠦⣘⠡⢎⡱⢄⣊⠦⠐⢕⣢⠨⡕⡴⣩⠪⢖⣑⢨⠊⡼⡑⣸⣿
⡷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠠⢂⡐⢅⠎⡪⠂⣧⠘⡪⣢⢕⠄⠢⠈⠙⢖⣡⠫⡜⠬⡒⢵⡙⡮⣢⢱⠄⢮⡺⣔⣝⠦⣪⠒⣕⢱⢁⣿⣿
⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⣀⠢⢢⡘⣑⠴⠨⠪⢆⢑⠁⠘⢁⡀⠀⣀⣀⣄⡀⠠⣤⡀⠴⢒⡇⡽⢪⡱⣗⢭⡫⣆⢹⣕⣮⡪⣗⢕⡇⣺⡊⢼⣿⣿
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⢀⡔⢨⠑⠥⢢⡉⢖⠔⡨⠨⣓⢌⡬⡪⣃⠸⣿⣿⣦⡑⢼⡢⡻⣄⡘⣿⣷⣦⣉⠛⠵⢿⣬⣳⢟⣵⠸⣣⣟⢝⣮⡫⣇⢹⠤⣿⣿⣿
⠀⠀⠀⠀⠀⠀⠀⠀⠠⠀⢀⠀⢂⡡⢘⠔⣣⠘⡠⠋⡲⢅⡴⡩⣎⢝⢅⡣⡸⢆⢝⡼⡂⢿⣿⣿⣿⣦⡙⠗⣋⣁⡌⢹⣿⣿⣿⣷⣶⣬⣉⣋⠛⢘⢏⣯⡻⣝⣝⢯⠼⢱⢿⣿⣿
⠀⠀⠀⠀⠀⠀⡀⠂⢌⠐⡤⢈⣓⢜⡠⢏⡤⠋⠀⣜⢡⢣⢞⣜⢬⡣⡳⣌⢗⠮⡳⣝⢞⠘⣿⣿⣟⣽⣿⣦⣝⠫⡿⣢⠙⠿⣛⣭⣿⣿⠟⠁⠞⠨⠙⢉⢜⡿⡫⣿⠁⣾⣿⣿⣿
⠀⠀⠀⠀⠀⠀⢌⡰⠢⣍⢚⠠⢎⡳⢆⠈⠀⡤⢦⢱⣋⢞⡺⡴⣯⣙⢾⡱⣎⢳⠘⣯⡳⣧⠸⣿⣿⣿⣿⣿⠿⢗⣨⣄⡒⠌⠛⠛⠉⠀⢀⣤⣤⢀⣠⡿⣻⣿⢞⡿⢠⢿⣿⣿⣷
⠀⠀⠀⠀⠀⢐⡦⠙⣜⠬⡹⢰⠨⠏⡠⡄⢹⣕⣫⠖⣭⡶⣹⢽⣺⡽⣟⣿⢞⣶⠱⡈⢿⣿⣧⡹⣿⣟⣫⡶⠟⠛⠋⠁⢀⣀⣠⡤⠀⢀⣾⣿⣷⠐⣿⣿⢾⡷⣷⢣⢏⣾⣿⣿⣿
⠀⠀⠀⠀⠀⢨⢒⠩⡔⣪⢹⡀⠀⣾⣱⢯⠀⠣⠗⣻⡈⢚⣱⢳⣽⣻⢾⣳⣿⣾⣧⡐⠘⢿⣿⣦⡙⣷⡖⢀⣠⣤⣀⠢⠙⠛⠭⠕⣡⣾⣿⣿⣿⢨⣿⠼⣷⣿⢊⠎⣼⣿⣿⣿⣿
⣤⣴⣶⣶⣶⠈⡖⡥⣚⢖⡻⡄⠸⣮⡽⣺⡆⢦⠹⣷⣳⡈⠻⣯⢾⣷⣿⣿⣾⣿⣽⣿⣦⠀⠻⣿⣷⣄⢶⣿⣿⣿⣿⣿⣶⣒⣦⣽⣿⣿⢿⣿⡟⢀⢻⣇⠺⠃⣠⢄⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⠈⣧⢣⢸⠾⣭⢧⢸⡗⣿⡼⡇⢸⣷⠈⢛⣣⡀⡌⠩⠬⣻⣷⣿⣿⣿⣿⣿⣷⣄⢢⣙⠿⣦⡻⢿⣿⣿⣿⣿⣿⡿⣿⣇⣿⡎⣿⡇⣾⡘⣿⠄⡸⣯⣌⡓⡿⢿⠻⡗
⣿⣿⣿⣿⣿⠀⣟⢮⡜⣖⡻⣼⡘⣷⣫⢷⠇⠺⠿⠶⠘⠋⠁⠁⠀⠀⠉⠛⢻⣿⣿⣿⣿⣿⣿⣮⠻⣶⡏⣥⣬⣽⣏⣿⣿⢹⣧⢿⣿⢹⣷⢿⢁⣽⣷⠛⠀⣇⣻⣽⣷⣷⡾⣲⣷
⣿⣿⡿⣻⣿⡇⣻⣯⡖⠸⣷⣻⣇⢹⣿⠻⠃⠉⠀⢠⣤⣀⠀⠄⠘⢛⣂⢀⡙⠿⣿⣿⣿⣿⣿⣿⣷⣬⠃⣿⣧⢿⣿⢸⣿⢸⣿⡘⣿⡎⣿⢂⣾⡿⢋⣾⢸⣿⢏⣿⣿⣻⣽⢿⡽
⣛⣛⠱⢿⣿⣇⢸⣿⡧⢩⣟⣽⡿⡄⢶⣦⠠⣶⣀⠨⣟⣿⣿⣦⡀⢄⠓⣯⣿⣷⣮⣭⠛⠿⢿⣿⣿⣿⡗⣬⣛⠸⣿⡜⣿⣇⣿⣧⢻⣷⠉⢞⣡⠼⣿⡇⣾⣿⣾⣿⣿⣿⣿⠏⣴
⣿⣿⠿⢢⣿⣿⡀⣿⣿⠄⡌⣷⣿⣷⠘⡇⣈⢻⡿⣦⡘⢿⣿⣿⣿⣶⣄⣙⡻⣿⣿⢱⡇⣿⣶⣶⣭⣭⣭⣭⣭⣥⣤⣅⣿⣿⣿⣿⣎⣥⣶⣿⣿⡟⣿⢱⣿⣿⣿⣿⣿⠟⣥⢞⣻
⣋⣥⣾⣿⣿⣿⣇⠸⣷⣷⠸⣞⣷⣿⣧⠀⣿⡆⠹⣷⣟⣆⠹⡿⣿⢹⣿⢻⣿⣿⣿⣀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠄⢂⣿⣿⣿⡿⢋⡁⢸⣟⢾⣻
⣿⣿⣿⣿⣿⣿⣿⡌⢿⣾⣧⠹⣾⣾⣿⣧⠸⡏⣤⠹⣻⡾⣇⠁⣿⡞⣿⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢣⣾⠿⣋⡅⣰⡟⠀⣸⢧⣿⣿
⣭⡿⠍⣿⣿⣿⣿⣷⡘⣿⣯⣦⡙⣿⣏⢻⣧⡁⣿⣧⠹⣿⣽⣧⠹⣷⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⠿⠋⣐⣫⣵⡾⣫⣾⡟⢀⠁⡿⢮⣮⣵
⣧⣶⣶⣶⡖⣿⠻⣿⣷⡘⣷⣿⣧⣘⠿⣷⡙⢷⡘⢿⡆⢻⡷⣯⣦⠘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⠿⠿⠿⠟⣋⣤⣆⠦⠍⣻⣿⣷⣶⣿⣿⣿⡿⢋⣾⣿⠋⠐⠄⣨⡿⣕⣵⣮
⠉⣿⣿⣿⣿⢹⠀⢻⣿⣷⡸⣻⣿⣿⣷⡈⠿⢶⡽⣦⡛⠘⣿⣷⣟⣇⢢⡙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣦⣴⣶⣶⣶⣾⣿⣿⣿⣿⣿⠟⢉⣴⣿⠟⠁⢠⠪⢀⣵⢽⡮⣮⣵
⠀⣿⣿⣿⣿⠀⣇⠘⣿⣿⣷⡌⢻⢿⣿⣿⣌⠲⢠⣤⣭⡀⢈⣛⣨⣼⣺⣿⣦⡌⠙⠻⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⢁⣴⣿⡿⠋⢠⠊⣄⠁⡞⡩⡾⣝⢷⡮
⠀⢸⡿⠋⣠⣤⠘⣶⣿⣿⣿⣿⣦⡘⢻⣿⣿⣷⣄⢿⣿⣷⠘⣿⢽⣳⡇⣟⣽⣿⠀⡐⢄⠀⠀⠉⠉⠛⠛⠿⢿⣿⣿⣿⣿⣿⠟⠉⠀⠀⠀⠉⠛⠁⡈⠆⠡⠀⡸⢁⡟⣵⢫⣏⣼
⡆⠀⣠⣾⣿⠟⢋⣿⣿⣿⣿⣿⣿⣿⣦⣝⠿⣿⣿⣷⣍⠻⠄⣿⢫⡷⡇⣿⣾⠼⠆⠐⢢⢀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠀⠀⢠⢃⡟⢜⠦⡫⠲⡜
⣷⠀⢹⠟⠁⣠⡟⢉⡀⠐⣿⣿⣿⣿⣿⣿⣷⣮⣭⣛⣛⠿⠦⠬⠍⢋⡡⡷⡯⣿⠂⠀⠡⡂⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠒⣈⠔⡐⠠⢃⠎⡰⡩⣚⢍⢗⡩
⣿⣧⢀⣤⣾⣿⣷⠟⠁⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⣞⣻⠇⡗⣿⢿⣽⠀⢉⠄⠐⡡⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠄⡡⢀⢎⠔⡡⣑⢎⢌⡱⡃⠜        
                        Made by: g3kzzz
            Repo: https://github.com/g3kzzz/dotfiles            
"

# -------------------------
# UI HELPERS
# -------------------------
show_banner() {
  clear
  echo -e "$BANNER"
  echo
}

# Imprime un mensaje limpiando antes (mantiene banner arriba)
print_step() {
  show_banner
  echo -e " $1"
}

# -------------------------
# SUDO FUNCTION (password reuse)
# -------------------------
run_sudo() {
  echo "$SUDO_PASS" | sudo -S "$@"
}

# ============================================================
# STEP 1 - CONFIRMATION
# ============================================================
show_banner
read -p " Do you want to continue with the installation? (Y/n): " confirm
confirm=${confirm,,}

if [[ -z "$confirm" || "$confirm" == "y" || "$confirm" == "yes" ]]; then
  print_step "[+] Continuing installation..."
  sleep 0.8
else
  print_step "[!] Installation cancelled."
  exit 0
fi

# ============================================================
# STEP 2 - PASSWORD
# ============================================================
while true; do
  print_step "🔑 Enter your sudo password: "
  read -s SUDO_PASS
  echo
  if echo "$SUDO_PASS" | sudo -S -v &>/dev/null; then
    print_step "✅ Password accepted"
    sleep 0.8
    break
  else
    print_step "❌ Wrong password, try again."
    sleep 1
  fi
done

# ============================================================
# TEMPORARY SUDO RULE
# ============================================================
echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/pacman, /usr/bin/makepkg, /usr/bin/chsh" | \
sudo tee "$TMP_SUDOERS" >/dev/null

# ============================================================
# INSTALL PACKAGE FUNCTIONS (WITH CLEAR PER ITEM)
# ============================================================
install_pacman() {
  for pkg in "$@"; do
    print_step "[+] Installing $pkg..."
    if pacman -Qi "$pkg" &>/dev/null; then
      print_step "[✓] $pkg already installed"
    else
      if echo "$SUDO_PASS" | sudo -S pacman -S --needed --noconfirm "$pkg" &>/dev/null; then
        print_step "[✓] $pkg installed"
      else
        print_step "[!] Failed to install $pkg"
      fi
    fi
    sleep 0.2
  done
}

install_yay() {
  for pkg in "$@"; do
    print_step "[+] Installing $pkg..."
    if yay -Qi "$pkg" &>/dev/null; then
      print_step "[✓] $pkg already installed"
    else
      if yay -S --needed --noconfirm "$pkg" &>/dev/null; then
        print_step "[✓] $pkg installed"
      else
        print_step "[!] Failed to install $pkg"
      fi
    fi
    sleep 0.2
  done
}

# ============================================================
# STEP 5 - YAY INSTALLATION
# ============================================================
print_step "[+] Checking YAY..."
if ! command -v yay &>/dev/null; then
  print_step "[+] Installing yay..."
  cd /tmp
  git clone https://aur.archlinux.org/yay.git &>/dev/null || true
  cd yay && makepkg -si --noconfirm <<<"$SUDO_PASS" &>/dev/null || true
  cd ~
  print_step "[✓] yay installed"
else
  print_step "[✓] yay already installed"
fi
sleep 0.8

# ============================================================
# STEP 6 - INSTALL PACKAGES
# ============================================================
PACMAN_TOOLS=(
  xorg xorg-xinit bspwm lxdm sxhkd picom feh
  ttf-fira-code adobe-source-code-pro-fonts ttf-inconsolata ttf-hack
  ttf-cascadia-code ttf-ibm-plex kitty zsh tmux eza bat xclip
  brightnessctl pamixer rofi thunar gvfs gvfs-mtp tumbler
  ffmpegthumbnailer ttf-jetbrains-mono neovim ttf-jetbrains-mono-nerd
  papirus-icon-theme picom gnome-themes-extra dunst libnotify flameshot
  nodejs npm firefox
)

YAY_TOOLS=( eww bash-language-server xautolock i3lock-color )

print_step "[+] Installing PACMAN tools..."
install_pacman "${PACMAN_TOOLS[@]}"

print_step "[+] Installing YAY tools..."
install_yay "${YAY_TOOLS[@]}"

# ============================================================
# STEP 7 - SERVICES & CONFIG
# ============================================================
print_step "[+] Enabling services..."
run_sudo systemctl enable lxdm.service || true
run_sudo systemctl enable NetworkManager || true
run_sudo systemctl start NetworkManager || true
echo "exec bspwm" > ~/.xinitrc
run_sudo chsh -s /bin/zsh "$USER"
sleep 0.5

# ============================================================
# STEP 8 - ZSH & PLUGINS
# ============================================================
print_step "[+] Installing Oh My Zsh and plugins..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" 2>/dev/null || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" 2>/dev/null || true
sleep 0.5

# ============================================================
# STEP 9 - DOTFILES & USER FOLDERS
# ============================================================
print_step "[+] Creating folders and applying dotfiles..."
mkdir -p "$HOME"/{Documents,CTF,Downloads,Pictures/Clipboard}
git clone https://github.com/g3kzzz/dotfiles &>/dev/null || true
cp -r dotfiles/config/* ~/.config/ 2>/dev/null || true
cp -r dotfiles/home/.mozilla ~/ 2>/dev/null || true
cp -f dotfiles/home/.zshrc ~/.zshrc 2>/dev/null || true
sleep 0.5

# ============================================================
# STEP 10 - ROOT CONFIG SYNC
# ============================================================
print_step "[+] Applying configuration for root..."
run_sudo chsh -s /bin/zsh root || true
run_sudo cp -r ~/.oh-my-zsh /root/ 2>/dev/null || true
run_sudo cp -r ~/.zshrc /root/ 2>/dev/null || true
run_sudo cp -r ~/.config /root/ 2>/dev/null || true
sleep 0.5

# ============================================================
# STEP 11 - SSH KEY SETUP (Default or Secure Mode)
# ============================================================
print_step "[+] SSH Key Setup"
sleep 0.4

DEFAULT_USER="g3kzzz"

print_step "Choose SSH key generation mode:\n  1) Default — NO passphrase (automatic, less secure)\n  2) Secure  — Enter passphrase (recommended)"
read -p "Select option [1]: " mode_choice
if [[ "$mode_choice" != "2" ]]; then
  mode_choice=1
  print_step "[*] Default mode selected"
else
  print_step "[*] Secure mode selected"
fi
sleep 0.3

read -p "SSH key label (comment) [${DEFAULT_USER}]: " SSH_USER
SSH_USER=${SSH_USER:-$DEFAULT_USER}

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

PASSPHRASE_RSA=""
PASSPHRASE_ED25519=""

if [[ "$mode_choice" == "2" ]]; then
  # Ask for RSA passphrase
  while true; do
    print_step "RSA key passphrase (will be hidden):"
    read -s -p "RSA key passphrase: " p1; echo
    read -s -p "Confirm rsa passphrase: " p2; echo
    if [[ "$p1" == "$p2" ]]; then
      PASSPHRASE_RSA="$p1"
      break
    else
      print_step "Passphrases do not match. Try again."
      sleep 0.6
    fi
  done

  print_step "ED25519 passphrase (press ENTER to reuse RSA passphrase)"
  read -s -p "ED25519 passphrase: " q1; echo
  if [[ -z "$q1" ]]; then
    PASSPHRASE_ED25519="$PASSPHRASE_RSA"
  else
    while true; do
      read -s -p "Confirm ED25519 passphrase: " q2; echo
      if [[ "$q1" == "$q2" ]]; then
        PASSPHRASE_ED25519="$q1"
        break
      else
        print_step "Passphrases do not match. Try again."
        sleep 0.6
      fi
    done
  fi
fi

generate_key() {
  local keypath="$1"
  local type="$2"
  local bits="$3"
  local pass="$4"

  if [[ -f "$keypath" ]]; then
    print_step "[!] $keypath already exists."
    read -p "Overwrite? [y/N]: " resp
    if [[ "${resp,,}" != "y" ]]; then
      print_step "[i] Keeping existing key."
      return
    fi
    cp "$keypath" "${keypath}.backup" 2>/dev/null || true
    cp "${keypath}.pub" "${keypath}.pub.backup" 2>/dev/null || true
    rm -f "$keypath" "${keypath}.pub" 2>/dev/null || true
  fi

  print_step "[+] Generating $type key..."
  if [[ "$type" == "rsa" ]]; then
    # -q for quiet, -N for passphrase
    ssh-keygen -t rsa -b "$bits" -C "${SSH_USER}@$(hostname)" -f "$keypath" -N "$pass" -q
  else
    ssh-keygen -t ed25519 -C "${SSH_USER}@$(hostname)" -f "$keypath" -N "$pass" -q
  fi

  chmod 600 "$keypath" 2>/dev/null || true
  chmod 644 "${keypath}.pub" 2>/dev/null || true
  print_step "[✓] $type key created: $keypath"
  sleep 0.5
}

# Generate keys (RSA + ED25519)
generate_key "$HOME/.ssh/id_rsa" "rsa" 4096 "$PASSPHRASE_RSA"
generate_key "$HOME/.ssh/id_ed25519" "ed25519" "" "$PASSPHRASE_ED25519"

# Show public keys (cleared UI each time)
if [[ -f "$HOME/.ssh/id_rsa.pub" ]]; then
  show_banner
  echo -e "\n--- id_rsa.pub ---"
  cat "$HOME/.ssh/id_rsa.pub"
  echo
  read -p "Press ENTER to continue..." _dummy
fi

if [[ -f "$HOME/.ssh/id_ed25519.pub" ]]; then
  show_banner
  echo -e "\n--- id_ed25519.pub ---"
  cat "$HOME/.ssh/id_ed25519.pub"
  echo
  read -p "Press ENTER to continue..." _dummy
fi

print_step "[✓] SSH setup complete. Keys ready to add to GitHub/GitLab/etc."
sleep 0.8

# ============================================================
# STEP 12 - CLEANUP
# ============================================================
print_step "[+] Cleaning up sudoers..."
run_sudo rm -f "$TMP_SUDOERS" || true
sleep 0.6

# ============================================================
# DONE
# ============================================================
print_step " ✅ DONE — your Arch is now clean AF."
echo " Enjoy your system, $USER 🤙"

