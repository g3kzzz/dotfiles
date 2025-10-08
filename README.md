![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![bspwm](https://img.shields.io/badge/bspwm-1e1e2e?style=for-the-badge&logo=bspwm&logoColor=white)
![Arch Linux](https://img.shields.io/badge/Arch%20Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
# G3K Dotfiles 🚀

**G3K Dotfiles** is a curated collection of configurations and scripts designed to provide a highly efficient, minimal, and visually appealing environment on **Arch Linux** 🏔️🐧.

It includes an automated installer that sets up a complete workflow ecosystem powered by **bspwm** 🖥️, **zsh** 🐚, and a carefully chosen set of tools to boost productivity and maintain simplicity.
<p align="center">
  <img src="c.png" alt="Captura"/>
</p>


---


## 📦 Main Components

The environment automatically configures:

- 🖥️ **Window Manager:** bspwm  
- 🔔 **Notifications:** dunst  
- 📊 **Widgets & Panels:** eww  
- 📝 **Text Editor:** neovim  
- ✨ **Compositor:** picom  
- 🚀 **Application Launcher:** rofi  
- 🖋️ **Terminal:** alacritty  
- 🔀 **Terminal Multiplexer:** tmux  
- 🎹 **Keybinding Manager:** sxhkd  

Additional setup includes:

- 🐚 **Oh My Zsh** with plugins (**zsh-autosuggestions**, **zsh-syntax-highlighting**)  
- 🌐 **NetworkManager** and essential services  
- 🖥️ **LY Display Manager**  
- 🟢 **Node.js + bash-language-server**

---

## 🎨 Aesthetic & Customization

This setup combines lightweight performance with a modern and clean look. Features include:

- 🎨 Custom configurations for terminal, notifications, and panels  
- 🖼️ Preconfigured wallpapers  
- ⚡ Shell aliases and tweaks in `.zshrc` for a faster workflow  

---

## ⚡ Installation

You can install the environment directly from the remote script. Choose **one** of the following methods:

### Using curl

```bash
curl -fsSL https://raw.githubusercontent.com/g333k/dotfiles/refs/heads/main/install.sh -o install.sh
chmod +x install.sh
./install.sh
```

### Using wget
```bash
wget https://raw.githubusercontent.com/g333k/dotfiles/refs/heads/main/install.sh -O install.sh
chmod +x install.sh
./install.sh
```

### Alternative one-liner (curl)
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/g333k/dotfiles/refs/heads/main/install.sh)
```


⚠️ Do not run the script as root. Use a normal user with sudo privileges.
Follow the on-screen instructions during installation.

📌 Notes

    🏔️ Optimized for Arch Linux and derivatives

    🖥️ Can be adapted to other window managers, but specifically optimized for bspwm

    🔧 All configurations can be freely customized in ~/.config/ and ~/.zshrc

🤝 Contributing
```bash
Contributions, suggestions, and improvements are welcome! Feel free to open an issue or a pull request.
```

👤 Author
```bash
Created with 💻 by Genaro (aka G333k)
```
