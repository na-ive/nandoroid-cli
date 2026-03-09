#!/bin/bash

# Nandoroid CLI Installer
set -e
trap 'echo -ne "\033[0m"' EXIT

# --- UI Colors ---
C_MAIN='\033[38;2;202;169;224m'
C_ACCENT='\033[38;2;145;177;240m'
C_DIM='\033[38;2;129;122;150m'
C_GREEN='\033[38;2;166;209;137m'
C_YELLOW='\033[38;2;229;200;144m'
C_RED='\033[38;2;231;130;132m'
C_WHITE='\033[38;2;205;214;244m'
C_BOLD='\033[1m'
C_RST='\033[0m'

# --- UI Helpers ---
banner() {
    echo -e "${C_MAIN}${C_BOLD}"
    echo ' _   _                 _                 _     _'
    echo '| \ | | __ _ _ __   __| | ___  _ __ ___ (_) __| |'
    echo '|  \| |/ _` | '"'"'_ \ / _` |/ _ \| '"'"'__/ _ \| |/ _` |'
    echo '| |\  | (_| | | | | (_| | (_) | | | (_) | | (_| |'
    echo '|_| \_|\__,_|_| |_|\__,_|\___/|_|  \___/|_|\__,_| - CLI'
    echo -e "${C_RST}"
    echo -e " ${C_MAIN}${C_BOLD}╭──────────────────────────────────────────╮${C_RST}"
    echo -e " ${C_MAIN}${C_BOLD}│            * CLI INSTALLER *             │${C_RST}"
    echo -e " ${C_MAIN}${C_BOLD}╰──────────────────────────────────────────╯${C_RST}"
    echo ""
}

info() { echo -e "${C_MAIN}${C_BOLD} ╭─ $1${C_RST}"; }
substep() { echo -e "${C_MAIN}${C_BOLD} │  ${C_DIM}> ${C_RST}$1"; }
success() { echo -e "${C_MAIN}${C_BOLD} ╰─ ${C_GREEN}+ ${C_RST}$1\n"; }
error() { echo -e "${C_MAIN}${C_BOLD} ╰─ ${C_RED}x ${C_RST}$1\n"; exit 1; }
ask() { echo -ne "${C_MAIN}${C_BOLD} ╰─ ${C_YELLOW}? ${C_RST}$1 "; }

banner

# Initial Paths
BIN_DIR="$HOME/.local/bin"
STATE_DIR="$HOME/.config/nandoroid"
STATE_FILE="$STATE_DIR/cli_state.json"
CURRENT_DIR="$(dirname "$(realpath "$0")")"

# 1. Path Selection
info "Installation path..."
ask "Where to store CLI source? (default: ~/.local/share/nandoroid-cli)"
echo ""
read -rp "     > " TARGET_DIR < /dev/tty
TARGET_DIR="${TARGET_DIR:-$HOME/.local/share/nandoroid-cli}"
TARGET_DIR="${TARGET_DIR/#\~/$HOME}"
substep "Target: ${C_ACCENT}$TARGET_DIR${C_RST}"

# 2. Cloning/Moving Source
if [[ "$CURRENT_DIR" != "$(realpath "$TARGET_DIR" 2>/dev/null)" ]]; then
    if [[ -d "$TARGET_DIR" ]]; then
        info "Source already exists at target."
        ask "Update it now? (Y/n)"
        read -r update_choice < /dev/tty
        if [[ ${update_choice:-y} =~ ^[Yy] ]]; then
            substep "Pulling updates..."
            cd "$TARGET_DIR" && git pull origin main > /dev/null 2>&1
        fi
    else
        info "Setting up source at target..."
        if [[ -f "$CURRENT_DIR/bin/nandoroid" ]]; then
            # If run from a local clone, we copy it
            substep "Copying current source to $TARGET_DIR..."
            mkdir -p "$TARGET_DIR"
            cp -r "$CURRENT_DIR/"* "$TARGET_DIR/"
        else
            # If run via curl, we clone it
            substep "Cloning repository to $TARGET_DIR..."
            git clone --depth 1 https://github.com/na-ive/nandoroid-cli.git "$TARGET_DIR" > /dev/null 2>&1
        fi
    fi
    REPO_DIR="$TARGET_DIR"
else
    # We are already in the target directory
    REPO_DIR="$CURRENT_DIR"
fi

# 3. Dependency Check
info "Checking CLI dependencies..."
for dep in python3 git curl; do
    if ! command -v "$dep" &> /dev/null; then error "Missing dependency: $dep"; fi
done
success "Dependencies verified."

# 4. Installation
info "Installing Nandoroid CLI..."
mkdir -p "$BIN_DIR" "$STATE_DIR"

substep "Installing binary to $BIN_DIR..."
cp "$REPO_DIR/bin/nandoroid" "$BIN_DIR/nandoroid"
chmod +x "$BIN_DIR/nandoroid"

# Patch LIB_DIR to point to the REPO_DIR/lib
substep "Configuring library paths..."
sed -i "s|LIB_DIR=.*|LIB_DIR=\"$REPO_DIR/lib\"|" "$BIN_DIR/nandoroid"

# Save CLI State
substep "Saving installation state to $STATE_FILE..."
cat > "$STATE_FILE" << EOF
{
  "source_dir": "$(realpath "$REPO_DIR")",
  "install_date": "$(date +%Y-%m-%d)"
}
EOF

# Completions
substep "Setting up shell completions..."
COMP_SRC="$REPO_DIR/completions"
[[ -d "$HOME/.config/fish/completions" ]] && ln -sf "$COMP_SRC/nandoroid.fish" "$HOME/.config/fish/completions/nandoroid.fish"
[[ -d "$HOME/.zsh/completions" ]] && ln -sf "$COMP_SRC/_nandoroid" "$HOME/.zsh/completions/_nandoroid"

success "Installation complete! Use 'nandoroid help' to start."
