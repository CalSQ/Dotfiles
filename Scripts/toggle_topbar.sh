#!/bin/bash
# Toggle topbar script

if pidof $1 > /dev/null; then
	killall $1
	if [ $? -eq 0 ]; then
		echo "$1 killed successfully."
	else
		notify-send "Failed to kill $1."
	fi
else
	$1 &
	if [ $? -eq 0 ]; then
		echo "$1 launched successfully."
	else
		notify-send "Failed to launch $1."
	fi
fi
