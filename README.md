# G3K Dotfiles 🚀  

**G3K Dotfiles** es una colección de configuraciones y scripts diseñados para crear un entorno altamente eficiente, minimalista y estéticamente cuidado sobre **Arch Linux**.  

Incluye un **instalador automatizado** que despliega un ecosistema de trabajo completo, basado en **bspwm**, **zsh** y un conjunto de herramientas seleccionadas para optimizar productividad y fluidez.  

---

## 📦 Componentes principales

El entorno configura y gestiona automáticamente:  

- **Gestor de ventanas:** [bspwm](https://github.com/baskerville/bspwm)  
- **Notificaciones:** [dunst](https://github.com/dunst-project/dunst)  
- **Widgets y paneles:** [eww](https://github.com/elkowar/eww)  
- **Editor de texto:** [neovim](https://neovim.io/)  
- **Compositor gráfico:** [picom](https://github.com/yshui/picom)  
- **Lanzador de aplicaciones:** [rofi](https://github.com/davatorium/rofi)  
- **Terminal:** [alacritty](https://github.com/alacritty/alacritty)  
- **Multiplexor de terminal:** [tmux](https://github.com/tmux/tmux)  
- **Gestor de atajos de teclado:** [sxhkd](https://github.com/baskerville/sxhkd)  

Además de configuraciones personalizadas para:  
- **Oh My Zsh** con plugins (`zsh-autosuggestions`, `zsh-syntax-highlighting`)  
- **NetworkManager** y servicios esenciales  
- **LY Display Manager**  
- **Entorno Node.js + bash-language-server**  

---

## 🖼️ Estética y personalización  

Este entorno busca combinar **ligereza** y **productividad** con un diseño **limpio y moderno**.  
Incluye:  
- Configuraciones de terminal, notificaciones y paneles  
- Wallpapers preconfigurados  
- Alias y ajustes en `.zshrc` para flujo de trabajo rápido  

<p align="center">
  <img src="cap.png" alt="G3K Dotfiles" width="800"/>
</p>

---

## ⚡ Instalación

1. Clona el repositorio:  
   ```bash
   git clone https://github.com/g333k/g3kpwm.git
   cd g3kpwm

    Da permisos de ejecución al instalador:

chmod +x G333K.sh

Ejecuta el instalador:

    ./G333K.sh

    Sigue las instrucciones en pantalla.

    ⚠️ El script no debe ejecutarse como root. Usa un usuario normal con privilegios sudo.

📂 Estructura del repositorio

g3kpwm/
│── G333K.sh          # Instalador principal
│── config/           # Configuraciones de aplicaciones
│   ├── alacritty
│   ├── bspwm
│   ├── dunst
│   ├── eww
│   ├── nvim
│   ├── picom
│   ├── rofi
│   ├── sxhkd
│   └── tmux
│── home/             # Archivos en $HOME (ej. .zshrc)
│── wallpapers/       # Fondos de pantalla
│── cap.png           # Captura de ejemplo

📌 Notas adicionales

    Optimizado para Arch Linux y derivados.

    Puede adaptarse a otros gestores de ventanas, pero está diseñado específicamente para bspwm.

    Todas las configuraciones pueden personalizarse libremente en ~/.config/ y ~/.zshrc.

🤝 Contribuciones

Si tienes ideas o mejoras, puedes abrir un issue o un pull request en el repositorio.
👤 Autor

Creado con 💻 por Genaro (aka G333k)
