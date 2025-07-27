#!/bin/sh
# ===============================================
#	⠀⠀⢀⣴⣿⣷⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#	⠀⢠⣿⣿⢿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#	⢀⡾⠋⠀⣰⣿⣿⠻⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#	⠘⠀⠀⢠⣿⣿⠃⠀⠈⠻⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
#	⠀⠀⠀⢸⣿⡇⠀⠀⠀⣼⣉⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⠀
#	⠀⠀⠀⢹⣿⡇⠀⠀⠀⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠟⣿⠉⠁
#	⠀⠀⠀⠸⣿⣿⣄⠀⠀⠘⢿⣿⡵⠋⠙⢿⣦⡀⠀⠀⣤⣠⠀⣠⣿⡅⠀⣿⠀⠀
#	⠀⠀⠀⠀⠈⠻⢿⣿⣶⣤⣄⣀⠀⠀⠀⠈⠻⣷⣄⣠⣿⣿⡼⠋⠛⣡⡼⠋⠀⠀
#	⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠛⠻⠿⠿⠷⠶⠶⠾⣿⡿⠋⠻⣟⠉⠁⠀⠀⠀⠀⠀
#	⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⠶⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
# Author: g3k
# Rep: https://github.com/IamGenarov/blackbspwm
# ===============================================

# Load theme configuration
. "$HOME"/.config/eww/theme-config.bash

# Load theme configuration
. "$HOME"/.config/eww/theme-config.bash

# Function to wait for processes to finish correctly
wait_for_termination() {
    process_name="$1"
    while pgrep -f "$process_name" >/dev/null; do
        sleep 0.2
    done
}

kill_processes() {
    # Kill polybar or eww bars when you switch from the current theme to another
    if pgrep -x polybar >/dev/null; then
		polybar-msg cmd quit >/dev/null
		wait_for_termination "polybar"
	elif pgrep -f "eww.*bar" >/dev/null; then
		pkill -f "eww.*bar"
		wait_for_termination "eww.*bar"
	fi

	# Kill the fix for eww in fullscreen, we don't need it in themes with polybar
	if pgrep -f "bspc subscribe node_state" >/dev/null; then
		pkill -f "bspc subscribe node_state"
		wait_for_termination "bspc subscribe node_state"
	fi

    # Kill animated wallpaper if is active
    if pgrep -x xwinwrap >/dev/null; then
        pkill xwinwrap
        wait_for_termination "xwinwrap"
	fi

    if [ -f /tmp/wall_refresh.pid ]; then
        kill $(cat /tmp/wall_refresh.pid) 2>/dev/null
        rm -f /tmp/wall_refresh.pid
    fi
}

# Set bspwm configuration
apply_bspwm_config() {
	bspc config border_width ${BORDER_WIDTH}
	bspc config top_padding ${TOP_PADDING}
	bspc config bottom_padding ${BOTTOM_PADDING}
	bspc config left_padding ${LEFT_PADDING}
	bspc config right_padding ${RIGHT_PADDING}
	bspc config normal_border_color "${NORMAL_BC}"
	bspc config focused_border_color "${FOCUSED_BC}"
	bspc config presel_feedback_color "${blue}"
}

#Set eww colors
apply_eww_colors() {
	cat >"$HOME"/.config/bspwm/eww/colors.scss <<-EOF
		\$bg: ${bg};
		\$bg-alt: ${accent_color};
		\$fg: ${fg};
		\$black: ${blackb};
		\$red: ${red};
		\$green: ${green};
		\$yellow: ${yellow};
		\$blue: ${blue};
		\$magenta: ${magenta};
		\$cyan: ${cyan};
		\$archicon: ${arch_icon};
	EOF
}

# Apply wallpaper engine

apply_wallpaper () {
    feh --bg-scale "$HOME/Pictures/.wallpapers/fp3.png"
}


# Launch bars
apply_bar() {
	. "$HOME"/.config/eww/Bar.bash
}
#Apply Configurations




kill_processes
apply_bspwm_config
apply_term_config
apply_eww_colors
apply_wallpaper
apply_bar
