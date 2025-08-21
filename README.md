# G3K Dotfiles 🚀  

**G3K Dotfiles** is a curated collection of configurations and scripts designed to provide a highly efficient, minimal, and visually appealing environment on **Arch Linux**.  

It includes an **automated installer** that sets up a complete workflow ecosystem powered by **bspwm**, **zsh**, and a carefully chosen set of tools to boost productivity and maintain simplicity.  

---

## 📦 Main Components

The environment automatically configures:  

- **Window Manager:** [bspwm](https://github.com/baskerville/bspwm)  
- **Notifications:** [dunst](https://github.com/dunst-project/dunst)  
- **Widgets & Panels:** [eww](https://github.com/elkowar/eww)  
- **Text Editor:** [neovim](https://neovim.io/)  
- **Compositor:** [picom](https://github.com/yshui/picom)  
- **Application Launcher:** [rofi](https://github.com/davatorium/rofi)  
- **Terminal:** [alacritty](https://github.com/alacritty/alacritty)  
- **Terminal Multiplexer:** [tmux](https://github.com/tmux/tmux)  
- **Keybinding Manager:** [sxhkd](https://github.com/baskerville/sxhkd)  

Additional setup includes:  
- **Oh My Zsh** with plugins (`zsh-autosuggestions`, `zsh-syntax-highlighting`)  
- **NetworkManager** and essential services  
- **LY Display Manager**  
- **Node.js + bash-language-server**  

---

## 🎨 Aesthetic & Customization  

This setup combines **lightweight performance** with a **modern and clean look**.  
Features include:  
- Custom configurations for terminal, notifications, and panels  
- Preconfigured wallpapers  
- Shell aliases and tweaks in `.zshrc` for a faster workflow  

<p align="center">
  <img src="cap.png" alt="G3K Dotfiles" width="800"/>
</p>

---

## ⚡ Installation

1. Clone the repository:  
   ```bash
   git clone https://github.com/g333k/g3kpwm.git
   cd g3kpwm

    Make the installer executable:

chmod +x G333K.sh

Run the installer:

    ./G333K.sh
''
    Follow the on-screen instructions.
''
    ⚠️ Do not run the script as root. Use a normal user with sudo privileges.

📌 Notes
''
    Optimized for Arch Linux and derivatives.
''
    It can be adapted to other window managers, but it is specifically optimized for bspwm.
''
    All configurations can be freely customized in ~/.config/ and ~/.zshrc.

🤝 Contributing

Contributions, suggestions, and improvements are welcome!
Feel free to open an issue or a pull request.
👤 Author

Created with 💻 by Genaro (aka G333k)
