#!/bin/bash

# Lifecycle management for Nandoroid Shell

SHELL_DIR="$HOME/.config/quickshell/nandoroid"

cmd_run() {
    info "Starting Nandoroid Shell..."
    if [[ ! -d "$SHELL_DIR" ]]; then
        error "Nandoroid Shell not found in $SHELL_DIR. Please run install-deps first."
    fi
    quickshell -p "$SHELL_DIR" &
    disown
    success "Shell started."
}

cmd_reload() {
    info "Reloading Nandoroid Shell..."
    quickshell --reload
    success "Reload signal sent."
}

cmd_debug() {
    info "Starting Nandoroid Shell in debug mode..."
    if [[ ! -d "$SHELL_DIR" ]]; then
        error "Nandoroid Shell not found in $SHELL_DIR."
    fi
    quickshell -d -p "$SHELL_DIR"
}
