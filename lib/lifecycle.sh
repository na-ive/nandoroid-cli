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
    pgrep -f "quickshell" > /dev/null || pgrep -f "\bqs\b" > /dev/null
}

stop_existing_shell() {
    if is_shell_running; then
        substep "Killing all existing Quickshell/qs processes..."
        pkill -9 -f "quickshell" || true
        pkill -9 -f "\bqs\b" || true
        sleep 1
    fi
}

cmd_run() {
    info "Starting Nandoroid Shell..."
    if [[ ! -d "$SHELL_DIR" ]]; then
        error "Nandoroid Shell not found. Run 'nandoroid install' first."
    fi
    
    stop_existing_shell
    
    local bin=$(get_qs_bin)
    substep "Launching $bin in background..."
    # We use -d here because run is intended to be backgrounded/daemonized
    $bin -d -p "$SHELL_DIR" > /dev/null 2>&1
    
    sleep 1
    if is_shell_running; then
        success "Shell started successfully."
    else
        error "Shell failed to start. Try 'nandoroid debug' to see why."
    fi
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
    echo "------------------------------------------------------------"
    # IMPORTANT: Use -vv for verbose logs and NO -d so it stays in foreground
    exec $bin -vv -p "$SHELL_DIR"
}

cmd_exit() {
    info "Exiting Nandoroid Shell..."
    if is_shell_running; then
        pkill -f "quickshell" || true
        pkill -f "\bqs\b" || true
        success "Quickshell stopped."
    else
        info "Quickshell is not currently running."
    fi
}
