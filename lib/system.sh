#!/bin/bash

# System actions for Nandoroid Shell

cmd_reboot() {
    info "Rebooting system..."
    systemctl reboot
}

cmd_lock() {
    info "Locking screen via Nandoroid Shell..."
    if ! command -v quickshell &> /dev/null; then
        error "quickshell not found."
    fi
    # Use IPC call to the lock handler defined in Lock.qml
    quickshell -c nandoroid ipc call lock activate
    success "Lock command sent."
}

cmd_poweroff() {
    info "Shutting down system..."
    systemctl poweroff
}
