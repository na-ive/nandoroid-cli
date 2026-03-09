#!/bin/bash

# Config management for Nandoroid Shell

CONFIG_FILE="$HOME/.config/nandoroid/config.json"

cmd_config() {
    local action="$1"
    
    if [[ "$action" == "edit" ]]; then
        info "Opening config file in your editor..."
        local editor="${EDITOR:-nano}"
        $editor "$CONFIG_FILE"
        success "Config updated."
    else
        info "Config path: $CONFIG_FILE"
        echo "Usage: nandoroid config edit"
    fi
}
