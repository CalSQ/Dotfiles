hyprctl dispatch workspace 10

if ! pgrep -x "coolercontrol" > /dev/null; then
  coolercontrol &
fi

if ! pgrep -f "alacritty.*btop" > /dev/null; then
    alacritty --title "btop" -e btop &
fi

if ! pgrep -f "alacritty.*nvtop" > /dev/null; then
    alacritty --title "nvtop" -e nvtop &
fi

sleep 0.5

hyprctl dispatch focuswindow title:btop
