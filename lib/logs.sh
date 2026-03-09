#!/bin/bash

# Log management for Nandoroid Shell

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
    
    # Quickshell has a built-in 'log' subcommand that tails the latest log
    # We filter for 'nandoroid' if possible, or just show the latest.
    # Most users only run one config, so 'qs log' is very reliable.
    $bin log
}
