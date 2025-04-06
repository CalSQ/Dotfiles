#!/bin/bash
# Run with -y flag to skip prompt

# Symbolic Link Directories
declare -A DIRS=(
    ["Configs"]="$HOME/.config"
    ["Scripts"]="$HOME/.local/share/bin"
    ["Bash"]="$HOME"
)

# Define variables
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

DOTFILES_DIR=$(pwd)

# Check for y flag
AUTO_YES=false
if [[ "$1" == "-y" ]]; then
    AUTO_YES=true
fi

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

        # Prompt to overwrite if the file already exists
        if [ -e "$target" ] || [ -L "$target" ]; then
            if [ "$AUTO_YES" = true ]; then
                rm -rf "$target"
            else
                echo -e "${YELLOW}File $target already exists. Overwrite? (y/n):${RESET}"
                read -p "" choice
                case "$choice" in
                    [Yy]*) rm -rf "$target" ;;
                    [Nn]*) echo "Skipping $target"; continue ;;
                    *) echo "Invalid choice, skipping $target"; continue ;;
                esac
            fi
        fi

        # Create an absolute symlink from the Dotfiles directory
        local abs_target="$DOTFILES_DIR/$src_dir/$filename"
        ln -s "$abs_target" "$target"
        echo -e "${GREEN}Linked${RESET} $item ${GREEN}->${RESET} $target"
    done
}

# Create links for each directory
for dir in "${!DIRS[@]}"; do
    create_symlinks "./$dir" "${DIRS[$dir]}"
done

echo -e "${GREEN}Dotfiles linked successfully!${RESET}"
