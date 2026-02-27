#!/bin/bash
#
# Dotfiles install script
# Symlinks dotfiles from this repo to their expected locations.
# Backs up any existing files before overwriting.
#
# Usage: ./install.sh
#

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

echo "Dotfiles directory: $DOTFILES_DIR"
echo "Backup directory:   $BACKUP_DIR"
echo ""

# --- Helper functions ---

link_file() {
    local src="$1"
    local dest="$2"

    # Create parent directory if needed
    mkdir -p "$(dirname "$dest")"

    # Back up existing file/directory (skip if already a symlink to us)
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        mkdir -p "$BACKUP_DIR"
        echo "  Backing up $dest → $BACKUP_DIR/"
        cp -R "$dest" "$BACKUP_DIR/$(basename "$dest").backup"
    fi

    # Remove existing file/symlink/directory
    rm -rf "$dest"

    ln -sf "$src" "$dest"
    echo "  Linked $dest → $src"
}

# --- Create parent directories ---

echo "Creating directories..."
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.claude"
mkdir -p "$HOME/.hammerspoon"
mkdir -p "$HOME/.oh-my-zsh/custom"
mkdir -p "$HOME/Library/Application Support/Code/User"
echo ""

# --- Create symlinks ---

echo "Creating symlinks..."

# Shell
link_file "$DOTFILES_DIR/zshrc"                        "$HOME/.zshrc"

# Oh-My-Zsh custom aliases
link_file "$DOTFILES_DIR/oh-my-zsh-custom/aliases.zsh"  "$HOME/.oh-my-zsh/custom/aliases.zsh"

# Vim
link_file "$DOTFILES_DIR/vimrc"                         "$HOME/.vimrc"

# Tmux
link_file "$DOTFILES_DIR/tmux_conf"                     "$HOME/.tmux.conf"

# Hammerspoon
link_file "$DOTFILES_DIR/hammerspoon/init.lua"          "$HOME/.hammerspoon/init.lua"

# Neovim (directory symlink)
link_file "$DOTFILES_DIR/nvim"                          "$HOME/.config/nvim"

# VS Code settings (macOS)
link_file "$DOTFILES_DIR/vscode-settings.json"          "$HOME/Library/Application Support/Code/User/settings.json"

# Claude settings
link_file "$DOTFILES_DIR/claude/settings.json"          "$HOME/.claude/settings.json"

echo ""
echo "Done! All symlinks created."
echo ""

# --- Reminders ---

if [ ! -f "$HOME/.secrets.zsh" ]; then
    echo "⚠  NOTE: ~/.secrets.zsh not found."
    echo "   Create it with your secret tokens (not tracked in dotfiles):"
    echo ""
    echo '   export NEPTUNE_API_TOKEN="..."'
    echo '   export NEPTUNE_API_KEY=$NEPTUNE_API_TOKEN'
    echo ""
    echo "   Then run: chmod 600 ~/.secrets.zsh"
    echo ""
else
    echo "✓  ~/.secrets.zsh exists (tokens loaded via .zshrc)"
fi

echo ""
echo "Skipped (contain credentials or are machine-specific):"
echo "  - ~/.kube/config"
echo "  - ~/.yolo/config"
echo "  - ~/.claude/settings.local.json"
