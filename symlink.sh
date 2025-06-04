#!/bin/bash
# Run with -y flag to skip prompt

# Symbolic Link Directories
declare -A DIRS=(
    ["Configs"]="$HOME/.config"
    ["Scripts"]="$HOME/.local/share/bin"
    ["Bash"]="$HOME"
    ["Themes"]="$HOME/.themes"
    ["Icons"]="$HOME/.icons"
)

# Variable definitions
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

DOTFILES_DIR=$(pwd)
LOGFILE="$DOTFILES_DIR/symlink.log"
AUTO_YES=false
VERBOSE=false

# Check for flags
while getopts "yv" opt; do
    case $opt in
        y) AUTO_YES=true ;;
        v) VERBOSE=true ;;
        *) echo "Running with flags: $0 [-y] [-v]"; exit 1 ;;
    esac
done

# Check directories exist
for dir in "${!DIRS[@]}"; do
    mkdir -p "${DIRS[$dir]}"
done

# Create symbolic links
create_symlinks() {
    local src_dir="$1"
    local dest_dir="$2"

    for item in "$src_dir"/.* "$src_dir"/*; do
        # Skip non-existing or irrelevant files
        [ -e "$item" ] || continue

        local filename=$(basename "$item")
        local target="$dest_dir/$filename"
        local abs_target="$DOTFILES_DIR/$src_dir/$filename"

        # Prompt to overwrite if the file already exists
        if [ -e "$target" ] || [ -L "$target" ]; then
            if [ "$AUTO_YES" = true ]; then
                rm -rf "$target"
            else
                echo -en "${YELLOW}File $target already exists. Overwrite? (Y/n): ${RESET}"
                read -r choice
                if [[ -z "$choice" || "$choice" =~ ^[Yy]$ ]]; then
                    rm -rf "$target"
                elif [[ "$choice" =~ ^[Nn]$ ]]; then
                    echo "Skipping $target"
                    echo "Skipped: $target" >> "$LOGFILE"
                    if [ "$VERBOSE" = true ]; then
                        echo "[VERBOSE] Skipped existing file: $target"
                    fi
                    continue
                else
                    echo "Invalid choice, skipping $target"
                    echo "Skipped (invalid input): $target" >> "$LOGFILE"
                    if [ "$VERBOSE" = true ]; then
                        echo "[VERBOSE] Skipped existing file due to invalid input: $target"
                    fi 
                    continue
                fi
            fi
        fi

        # Create an absolute symlink from the Dotfiles directory
        ln -s "$abs_target" "$target"
        echo -e "${GREEN}Linked${RESET} $item ${GREEN}->${RESET} $target"
        echo "Linked: $target -> $abs_target" >> "$LOGFILE"

        # Send verbose confirmation
        if [ "$VERBOSE" = true ]; then
            echo "[VERBOSE] Symlink created: $target → $abs_target"
        fi
    done
}

# Create log / clear
: > "$LOGFILE"

# Create links for each directory
for dir in "${!DIRS[@]}"; do
    create_symlinks "./$dir" "${DIRS[$dir]}"
done

echo -e "${GREEN}Dotfiles linked successfully!${RESET}"
