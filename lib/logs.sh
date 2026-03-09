#!/bin/bash

# Log management for Nandoroid Shell

SHELL_DIR="$HOME/.config/quickshell/nandoroid"

get_qs_bin() {
    if command -v qs &> /dev/null; then echo "qs"; else echo "quickshell"; fi
}

cmd_logs() {
    local bin=$(get_qs_bin)
    info "Fetching $bin logs for nandoroid..."
    
    # Check if shell is even running
    if ! pgrep -f "quickshell" > /dev/null && ! pgrep -f "\bqs\b" > /dev/null; then
        error "Nandoroid Shell is not currently running."
    fi

    substep "Streaming logs from active instance (Ctrl+C to stop)..."
    echo "------------------------------------------------------------"
    
    # We must specify the path because we launch with -p in cmd_run/debug
    # Quickshell 0.5.0+ allows 'log -p <path>'
    $bin log -p "$SHELL_DIR"
}
