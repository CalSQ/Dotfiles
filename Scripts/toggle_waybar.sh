#!/bin/bash
# Toggle waybar script

if pidof waybar > /dev/null; then
	killall waybar
	if [ $? -eq 0 ]; then
		notify-send "Waybar killed successfully."
	else
		notify-send "Failed to kill waybar."
	fi
else
	waybar &
	if [ $? -eq 0 ]; then
		notify-send "Waybar launched successfully."
	else
		notify-send "Failed to launch waybar."
	fi
fi
