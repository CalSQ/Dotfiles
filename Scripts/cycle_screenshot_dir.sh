#!/bin/bash

dir_names=("default" "drawing" "real")
dir_savefile="/tmp/screenshot_dir"

current=$(cat "$dir_savefile" 2>/dev/null || echo "default")

for i in "${!dir_names[@]}"; do
  if [[ "${dir_names[$i]}" == "$current" ]]; then
    current_index=$i
    break
  fi
done

next_index=$(( (current_index + 1) % ${#dir_names[@]} ))
next_dir="${dir_names[$next_index]}"

echo "$next_dir" > "$dir_savefile"
export screenshot_dir="$next_dir"

notify-send "Set screenshot directory to '$next_dir'"
