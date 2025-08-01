#!/bin/bash

set -euo pipefail

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo "[*] Eliminando historial corrupto de Zsh..."
rm -f "$HOME/.zsh_history"
touch "$HOME/.zsh_history"
chmod 600 "$HOME/.zsh_history"

echo "[*] Eliminando plugins rotos o vacíos..."
rm -rf "$ZSH_CUSTOM/plugins/exampl" || true
rm -rf "$ZSH_CUSTOM/plugins/zsh-autosuggestions" || true
rm -rf "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" || true

echo "[*] Clonando zsh-autosuggestions..."
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

echo "[*] Clonando zsh-syntax-highlighting..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

echo "[✓] Reparación completada. Recarga con: exec zsh"
