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

IS_MAC=false
[[ "$(uname -s)" == Darwin ]] && IS_MAC=true

# --- Linux bootstrap (e.g. the MSI Coder devbox, where only $HOME persists) ---

if ! $IS_MAC; then
    # Must run before anything creates ~/.oh-my-zsh: the installer refuses an existing dir.
    if [ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
        echo "Installing oh-my-zsh..."
        RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
            "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    ZSH_SYNTAX_DIR="$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    if [ ! -d "$ZSH_SYNTAX_DIR" ]; then
        echo "Installing zsh-syntax-highlighting..."
        git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX_DIR"
    fi

    # Neovim isn't in the devbox image and apt installs don't survive restarts, so
    # install the release tarball under ~/.local.
    if ! command -v nvim &>/dev/null && [ ! -x "$HOME/.local/bin/nvim" ]; then
        case "$(uname -m)" in
            x86_64) NVIM_ARCH=x86_64 ;;
            aarch64 | arm64) NVIM_ARCH=arm64 ;;
            *) echo "Unsupported arch for neovim: $(uname -m)" >&2; exit 1 ;;
        esac
        echo "Installing neovim to ~/.local/nvim..."
        rm -rf "$HOME/.local/nvim"
        mkdir -p "$HOME/.local/nvim" "$HOME/.local/bin"
        curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz" \
            | tar -xz -C "$HOME/.local/nvim" --strip-components=1
        ln -sf "$HOME/.local/nvim/bin/nvim" "$HOME/.local/bin/nvim"
    fi

    # Login shells start bash and `chsh` doesn't survive a restart, so hand
    # interactive bash sessions (but not `bash -c ...`) to zsh from ~/.bashrc.
    BASHRC_MARKER="# dotfiles: hand interactive shells to zsh"
    if ! grep -qF "$BASHRC_MARKER" "$HOME/.bashrc" 2>/dev/null; then
        echo "Adding zsh handoff to ~/.bashrc..."
        cat >> "$HOME/.bashrc" <<EOF

$BASHRC_MARKER
if [[ \$- == *i* ]] && [ -t 1 ] && [ -z "\${BASH_EXECUTION_STRING:-}" ] \\
    && [ -z "\${ZSH_VERSION:-}" ] && command -v zsh >/dev/null 2>&1; then
    exec zsh -l
fi
EOF
    fi

    # Shared env (e.g. KUBECONFIG) for every bash and zsh, interactive or not. Prepend to
    # ~/.bashrc so it runs before any "non-interactive? return" guard in a stock bashrc.
    ENV_MARKER="# dotfiles: shared shell environment"
    ENV_HOOK="[ -f \"$DOTFILES_DIR/shell/coder-env.sh\" ] && . \"$DOTFILES_DIR/shell/coder-env.sh\""
    if ! grep -qF "$ENV_MARKER" "$HOME/.bashrc" 2>/dev/null; then
        echo "Adding shared env hook to top of ~/.bashrc..."
        BASHRC_TMP="$(mktemp)"
        { printf '%s\n%s\n\n' "$ENV_MARKER" "$ENV_HOOK"; cat "$HOME/.bashrc" 2>/dev/null || true; } > "$BASHRC_TMP"
        cat "$BASHRC_TMP" > "$HOME/.bashrc"
        rm -f "$BASHRC_TMP"
    fi
    if ! grep -qF "$ENV_MARKER" "$HOME/.zshenv" 2>/dev/null; then
        echo "Adding shared env hook to ~/.zshenv..."
        printf '\n%s\n%s\n' "$ENV_MARKER" "$ENV_HOOK" >> "$HOME/.zshenv"
    fi
    echo ""
fi

# --- Create parent directories ---

echo "Creating directories..."
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.claude"
mkdir -p "$HOME/.oh-my-zsh/custom"
if $IS_MAC; then
    mkdir -p "$HOME/.hammerspoon"
    mkdir -p "$HOME/Library/Application Support/Code/User"
fi
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

# Hammerspoon (macOS)
if $IS_MAC; then
    link_file "$DOTFILES_DIR/hammerspoon/init.lua"      "$HOME/.hammerspoon/init.lua"
fi

# Neovim (directory symlink)
link_file "$DOTFILES_DIR/nvim"                          "$HOME/.config/nvim"

# VS Code settings (macOS). On a remote host, VS Code uses the laptop's user settings.
if $IS_MAC; then
    link_file "$DOTFILES_DIR/vscode-settings.json"      "$HOME/Library/Application Support/Code/User/settings.json"
fi

# Claude settings
link_file "$DOTFILES_DIR/claude/settings.json"          "$HOME/.claude/settings.json"

echo ""
echo "Done! All symlinks created."
echo ""

# Vim/Neovim plugins (nvim shares ~/.vim via nvim/init.vim). Ex mode, because the
# colorscheme errors until its plugin exists and would otherwise wait for Enter;
# that startup error also makes vim exit non-zero, so check the result instead.
if [ ! -d "$HOME/.vim/plugged" ]; then
    echo "Installing vim plugins..."
    vim -es -u "$HOME/.vimrc" -i NONE -c 'PlugInstall --sync' -c 'qa' || true
    if [ ! -d "$HOME/.vim/plugged/neovim-qt-colors-solarized-truecolor-only" ]; then
        echo "⚠  vim plugins missing; run :PlugInstall in vim"
    fi
    echo ""
fi

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
