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
 
 _____  _______ _______ _______ _______ _____   _______ _______ 
|     \|       |_     _|    ___|_     _|     |_|    ___|     __|
|  --  |   -   | |   | |    ___|_|   |_|       |    ___|__     |
|_____/|_______| |___| |___|   |_______|_______|_______|_______|
                                                                                 
                        Made by: g3kzzz
            Repo: https://github.com/g3kzzz/dotfiles            
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
echo "   - Install additional packages from AUR with yay"
echo "   - Configure bspwm window manager and Xorg"
echo "   - Set up zsh, Oh My Zsh and plugins"
echo "   - Enable and start NetworkManager"
echo "   - Create standard user directories"
echo "   - Apply custom dotfiles and configs"
echo "   - Replicate zsh and configs for root"
echo "   - Configure eww workspace for your monitor"
echo
echo " ============================================================"
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
while true; do
    echo -n "🔑 Enter your sudo password: "
    read -s SUDO_PASS
    echo
    # Validate password
    if echo "$SUDO_PASS" | sudo -S -v &>/dev/null; then
        echo "✅ Password accepted"
        break
    else
        echo "❌ Wrong password, try again."
    fi
done



# =============================
# SUDOERS TEMPORAL PARA YAY
# =============================
TMP_SUDOERS="/etc/sudoers.d/99_g3k_tmp"
echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/pacman, /usr/bin/makepkg, /usr/bin/chsh" | sudo tee "$TMP_SUDOERS" >/dev/null

# Función sudo personalizada
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
  alsa-utils base-devel bat brightnessctl thunar tmux bspwm dbus dunst eza feh flameshot fzf alacritty git gnome-themes-extra jq lxappearance lxsession-gtk3 mpc mpd mpv neovim networkmanager ncmpcpp noto-fonts noto-fonts-emoji pamixer papirus-icon-theme picom playerctl polkit pipewire pipewire-pulse pavucontrol python-gobject qt5ct rofi rustup sxhkd tar ttf-font-awesome ttf-inconsolata ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-terminus-nerd ttf-ubuntu-mono-nerd unzip xclip xdg-user-dirs xdo zsh xdotool xorg xorg-xdpyinfo xorg-xinit xorg-xkill xorg-xprop xorg-xrandr xorg-xsetroot xorg-xwininfo xsettingsd libnotify nodejs npm xf86-input-libinput nodejs npm lightdm lightdm-gtk-greeter
)

YAY_TOOLS=(
  eww bash-language-server xautolock i3lock-color librewolf-bin
)
echo " [+] PACMAN TOOLS..."
install_pacman "${PACMAN_TOOLS[@]}"
pause_and_clear
echo " [+] YAY TOOLS..."
install_yay "${YAY_TOOLS[@]}"
echo " [✓] Tools installed"
pause_and_clear

# ----------------------------
#   INSTALL LightDM (DISPLAY MANAGER)
# ----------------------------
echo " [+] Enabling LightDM on startup..."
run_sudo systemctl enable lightdm.service || true
echo " [✓] LightDM installed and enabled"
pause_and_clear

# -------------------------
#     ENABLE SERVICES
# -------------------------
echo " [+] Configuring services..."
run_sudo systemctl enable NetworkManager || true
run_sudo systemctl start NetworkManager || true

echo "exec bspwm" > ~/.xinitrc


run_sudo chsh -s /bin/zsh "$USER"
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
mkdir -p "$HOME/Documents" "$HOME/Desktop" "$HOME/CTF" "$HOME/Downloads" "$HOME/Music" "$HOME/Videos" "$HOME/Pictures/Clipboard"

git clone https://github.com/g3kzzz/dotfiles || true
cp -r dotfiles/config/* ~/.config/ || true
cp -r dotfiles/home/.librewolf ~/ || true 
cp -f dotfiles/home/.zshrc ~/.zshrc 
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
#     CONFIGURE EWW WORKSPACE
# -------------------------

echo " [+] Configuring eww workspace..."

CONFIG="$HOME/.config/eww/workspaces.yuck"
WORKSPACE=$(xrandr --listmonitors | awk 'NR==2 {print $4}')

if [ -z "$WORKSPACE" ]; then
    WORKSPACE="eDP-1"
fi

sed -i "s/WORKSPACE/$WORKSPACE/g" "$CONFIG"

echo " [✓] Workspace set to: $WORKSPACE"
pause_and_clear


# ---------


# =============================
# LIMPIEZA DE SUDOERS
# =============================
echo " [+] Cleaning up sudoers rule..."
run_sudo rm -f /etc/sudoers.d/99_g3k_tmp
echo " [✓] Sudoers restored"


# -------------------------
#     FINAL
# -------------------------
echo " ============================================================"
echo " [✓] All done."
echo " [✓] The environment has been configured"
echo "============================================================"
pause_and_clear

