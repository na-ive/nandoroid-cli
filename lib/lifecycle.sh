#!/bin/bash

# Lifecycle management for Nandoroid Shell

SHELL_DIR="$HOME/.config/quickshell/nandoroid"

# Find which binary to use
get_qs_bin() {
    if command -v qs &> /dev/null; then
        echo "qs"
    else
        echo "quickshell"
    fi
}

is_shell_running() {
    pgrep -x "quickshell" > /dev/null || pgrep -x "qs" > /dev/null
}

stop_existing_shell() {
    if is_shell_running; then
        substep "Stopping existing Quickshell instance..."
        pkill -x "quickshell" || true
        pkill -x "qs" || true
        sleep 0.5
    fi
}

cmd_run() {
    info "Starting Nandoroid Shell..."
    if [[ ! -d "$SHELL_DIR" ]]; then
        error "Nandoroid Shell not found. Run 'nandoroid install' first."
    fi
    
    stop_existing_shell
    
    local bin=$(get_qs_bin)
    # Run in background
    $bin -p "$SHELL_DIR" > /dev/null 2>&1 &
    disown
    success "Shell started in background using $bin."
}

cmd_reload() {
    info "Reloading Nandoroid Shell..."
    if is_shell_running; then
        local bin=$(get_qs_bin)
        $bin --reload
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
    
    local bin=$(get_qs_bin)
    substep "Logs will appear below using $bin. Press Ctrl+C to stop."
    $bin -d -p "$SHELL_DIR"
}

cmd_exit() {
    info "Exiting Nandoroid Shell..."
    if is_shell_running; then
        pkill -x "quickshell" || true
        pkill -x "qs" || true
        success "Quickshell stopped."
    else
        info "Quickshell is not currently running."
    fi
}
