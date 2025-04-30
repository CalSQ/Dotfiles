dir_name=$(cat /tmp/screenshot_dir 2>/dev/null)
[[ -z "$dir_name" ]] && dir_name="default"

save_dir="$HOME/Pictures/Screenshots/$dir_name"
mkdir -p "$save_dir"

filename="sc_$(date +'%d-%m-%y_%H-%M-%S-%3N').png"
filepath="$save_dir/$filename"

#grimblast copysave area "$filepath"
grim -g "$(slurp)" "$filepath" && wl-copy < "$filepath"
#notify-send "Screenshot saved to '$filepath'"
