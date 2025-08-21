#!/bin/bash
set -e


# --- ROOT RESTRICTION ---
if [[ $EUID -eq 0 ]]; then
  echo "[!] Do not run this script directly as root."
  echo "[!] Run it as a normal user."
  exit 1
fi



# =============================
#   G3K Installer
# =============================

# --- FUNCTION FOR ANIMATION ---
slow_print() {
  local text="$1"
  for ((i=0; i<${#text}; i++)); do
    echo -n "${text:$i:1}"
    sleep 0.000
  done
  echo
}

# --- ASCII BANNER ---
banner="
 
    █████████   ████████   ████████   ████████  █████   ████
   ███░░░░░███ ███░░░░███ ███░░░░███ ███░░░░███░░███   ███░ 
  ███     ░░░ ░░░    ░███░░░    ░███░░░    ░███ ░███  ███   
 ░███            ██████░    ██████░    ██████░  ░███████    
 ░███    █████  ░░░░░░███  ░░░░░░███  ░░░░░░███ ░███░░███   
 ░░███  ░░███  ███   ░███ ███   ░███ ███   ░███ ░███ ░░███  
  ░░█████████ ░░████████ ░░████████ ░░████████  █████ ░░████
   ░░░░░░░░░   ░░░░░░░░   ░░░░░░░░   ░░░░░░░░  ░░░░░   ░░░░ 
     
                      Made by: g333k
             Repo: https://github.com/g333k/g3kpwm
"

clear
slow_print "$banner"
sleep 1

echo " ============================================================"
echo "              Welcome to the G3K Installer"
echo " ============================================================"
echo
echo " [!] This script will perform the following changes:"
echo "   - Install essential packages with pacman"
echo "   - Install extra packages with yay (AUR)"
echo "   - Configure bspwm, zsh, oh-my-zsh and plugins"
echo "   - Configure LY display manager"
echo "   - Configure NetworkManager and services"
echo "   - Create standard user folders"
echo "   - Configure Node.js and bash-language-server"
echo "   - Replicate the configuration for root"
echo
echo "============================================================"
echo

read -p " Do you want to continue with the installation? (y/n): " confirm

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo " [!] Installation cancelled by the user."
  exit 0
fi

clear
echo " [+] Starting installation..."
sleep 2


# =============================
# PASSWORD HANDLING
# =============================
echo -n " [+] Enter your sudo password: "
read -s SUDO_PASS
echo

run_sudo() {
  echo "$SUDO_PASS" | sudo -S "$@"
}

# =============================
# AUXILIARY FUNCTIONS
# =============================

pause_and_clear() {
  sleep 2
  clear
}

install_pacman() {
  for pkg in "$@"; do
    if pacman -Qi "$pkg" &>/dev/null; then
      echo " [✓] $pkg already installed"
    else
      if echo "$SUDO_PASS" | sudo -S pacman -S --needed --noconfirm "$pkg" &>/dev/null; then
        echo " [✓] $pkg installed"
      else
        echo " [!] Failed to install $pkg with pacman"
      fi
    fi
  done
}

install_yay() {
  for pkg in "$@"; do
    if yay -Qi "$pkg" &>/dev/null; then
      echo " [✓] $pkg already installed"
    else
      if yay -S --needed --noconfirm "$pkg" &>/dev/null; then
        echo " [✓] $pkg installed"
      else
        echo " [!] Failed to install $pkg with yay"
      fi
    fi
  done
}

cd /home/$USER

# =============================
# YAY INSTALL
# =============================
echo " [+] Checking YAY..."
if ! command -v yay &>/dev/null; then
  echo " [+] Installing yay..."
  cd /tmp
  git clone https://aur.archlinux.org/yay.git &>/dev/null
  cd yay
  makepkg -si --noconfirm <<<"$SUDO_PASS" &>/dev/null
  cd ~
  echo " [✓] yay installed"
else
  echo " [✓] yay already installed"
fi
pause_and_clear

# =============================
# INSTALLING TOOLS
# =============================
echo " [+] Installing basic tools..."

PACMAN_TOOLS=(
  alsa-utils base-devel bat brightnessctl bspwm dbus dunst eza feh flameshot fzf alacritty git gnome-themes-extra jq lxappearance lxsession-gtk3 mpc mpd mpv neovim networkmanager ncmpcpp noto-fonts noto-fonts-emoji pamixer papirus-icon-theme picom playerctl polkit pipewire pipewire-pulse pavucontrol python-gobject qt5ct rofi rustup sxhkd tar ttf-font-awesome ttf-inconsolata ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-terminus-nerd ttf-ubuntu-mono-nerd unzip xclip xdg-user-dirs xdo zsh xdotool xorg firefox xorg-xdpyinfo xorg-xinit xorg-xkill xorg-xprop xorg-xrandr xorg-xsetroot xorg-xwininfo xsettingsd libnotify nodejs npm xf86-input-libinput nodejs npm
)

YAY_TOOLS=(
  eww bash-language-server ly
)

install_pacman "${PACMAN_TOOLS[@]}"
install_yay "${YAY_TOOLS[@]}"
echo " [✓] Tools installed"
pause_and_clear

# ----------------------------
#   INSTALL LY (DISPLAY MANAGER)
# ----------------------------
echo " [+] Enabling ly.service on startup..."
run_sudo systemctl enable ly.service || true
echo " [✓] LY installed and enabled"
pause_and_clear

# -------------------------
#     ENABLE SERVICES
# -------------------------
echo " [+] Configuring services..."
run_sudo systemctl enable NetworkManager || true
run_sudo systemctl start NetworkManager || true
echo "exec bspwm" > ~/.xinitrc
chsh -s /bin/zsh || true
echo " [✓] Services enabled"
pause_and_clear

# -------------------------
#     INSTALL OH-MY-ZSH
# -------------------------
echo " [+] Installing Oh My Zsh and plugins..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi
echo " [✓] Oh My Zsh configured"
pause_and_clear

# -------------------------
#     STANDARD FOLDERS
# -------------------------
echo " [+] Creating user folders..."
mkdir -p "$HOME/Documents" "$HOME/CTF" "$HOME/Downloads" "$HOME/Music" "$HOME/Videos" "$HOME/Pictures/Clipboard"

git clone https://github.com/g333k/g3kwm-dotfiles || true
cp -r g3kwm-dotfiles/config/* ~/.config/ || true
cd /home/$USER
cp -r g3kwm-dotfiles/home/* ~/ || true

if [ -f "$HOME/.zshrc" ]; then
    echo " [+] Reloading ZSH..."
    source "$HOME/.zshrc" || true
fi
echo " [✓] Folders and configs applied"
pause_and_clear

# -------------------------
#     CONFIGURE ROOT
# -------------------------
echo " [+] Applying configuration for root as well..."

run_sudo chsh -s /bin/zsh root

run_sudo cp -r ~/.oh-my-zsh /root/ || true
run_sudo cp -r ~/.zshrc /root/ || true
run_sudo cp -r ~/.config /root/ || true

if ! run_sudo test -d /root/.oh-my-zsh; then
    run_sudo sh -c "RUNZSH=no sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
fi

ROOT_ZSH_CUSTOM="/root/.oh-my-zsh/custom"
if ! run_sudo test -d "$ROOT_ZSH_CUSTOM/plugins/zsh-autosuggestions"; then
  run_sudo git clone https://github.com/zsh-users/zsh-autosuggestions "$ROOT_ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
if ! run_sudo test -d "$ROOT_ZSH_CUSTOM/plugins/zsh-syntax-highlighting"; then
  run_sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ROOT_ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

echo " [✓] Configuration replicated for root"
pause_and_clear




# -------------------------
#     FINAL
# -------------------------
echo " ============================================================"
echo " [✓] All done."
echo " [✓] The environment has been configured"
echo "============================================================"
pause_and_clear

