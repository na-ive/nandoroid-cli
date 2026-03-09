#!/bin/bash

# Nandoroid CLI Updater
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
info() { echo -e "${C_MAIN}${C_BOLD} ╭─ $1${C_RST}"; }
substep() { echo -e "${C_MAIN}${C_BOLD} │  ${C_DIM}> ${C_RST}$1"; }
success() { echo -e "${C_MAIN}${C_BOLD} ╰─ ${C_GREEN}+ ${C_RST}$1\n"; }
error() { echo -e "${C_MAIN}${C_BOLD} ╰─ ${C_RED}x ${C_RST}$1\n"; exit 1; }

REPO_DIR="$(dirname "$(realpath "$0")")"
cd "$REPO_DIR"

info "Checking for nandoroid-cli updates..."
substep "Fetching latest changes from origin..."
git fetch origin > /dev/null 2>&1

BRANCH=$(git rev-parse --abbrev-ref HEAD)
substep "Pulling latest changes for branch $BRANCH..."
git pull origin "$BRANCH" > /dev/null 2>&1

substep "Re-installing with updated files..."
bash install.sh > /dev/null

success "nandoroid-cli updated successfully!"
