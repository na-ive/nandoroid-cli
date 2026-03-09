#!/bin/bash

# Lifecycle management for Nandoroid Shell

SHELL_DIR="$HOME/.config/quickshell/nandoroid"

stop_existing_shell() {
    if pgrep -x "quickshell" > /dev/null; then
        substep "Stopping existing Quickshell instance..."
        pkill -x "quickshell" || true
        sleep 0.5
    fi
}

cmd_run() {
    info "Starting Nandoroid Shell..."
    if [[ ! -d "$SHELL_DIR" ]]; then
        error "Nandoroid Shell not found. Run 'nandoroid install' first."
    fi
    
    stop_existing_shell
    
    # Run in background
    quickshell -p "$SHELL_DIR" > /dev/null 2>&1 &
    disown
    success "Shell started in background."
}

cmd_reload() {
    info "Reloading Nandoroid Shell..."
    if pgrep -x "quickshell" > /dev/null; then
        quickshell --reload
        success "Reload signal sent."
    else
        error "No running Quickshell instance found to reload."
    fi
}

cmd_debug() {
    info "Starting Nandoroid Shell in DEBUG mode..."
    if [[ ! -d "$SHELL_DIR" ]]; then
        error "Nandoroid Shell not found."
    fi
    
    stop_existing_shell
    
    substep "Logs will appear below. Press Ctrl+C to stop."
    # Run in foreground WITHOUT disown/backgrounding
    quickshell -d -p "$SHELL_DIR"
}

cmd_exit() {
    info "Exiting Nandoroid Shell..."
    if pgrep -x "quickshell" > /dev/null; then
        pkill -x "quickshell"
        success "Quickshell stopped."
    else
        info "Quickshell is not currently running."
    fi
}
