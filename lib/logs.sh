#!/bin/bash

# Log management for Nandoroid Shell

cmd_logs() {
    info "Fetching Quickshell logs..."
    if command -v journalctl &> /dev/null; then
        substep "Streaming logs from journalctl (Ctrl+C to stop)..."
        journalctl -f -o cat --user-unit quickshell
    else
        error "journalctl not found."
    fi
}
