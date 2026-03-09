#!/bin/bash

# Maintenance commands for Nandoroid Shell

SHELL_STATE_FILE="$HOME/.config/nandoroid/install_state.json"
CLI_STATE_FILE="$HOME/.config/nandoroid/cli_state.json"

get_shell_install_dir() {
    if [[ -f "$SHELL_STATE_FILE" ]]; then
        grep -oP '"install_dir": "\K[^"]*' "$SHELL_STATE_FILE" || echo ""
    else
        echo ""
    fi
}

get_cli_source_dir() {
    if [[ -f "$CLI_STATE_FILE" ]]; then
        grep -oP '"source_dir": "\K[^"]*' "$CLI_STATE_FILE" || echo ""
    else
        echo ""
    fi
}

cmd_update() {
    local target="$1"
    local channel="$2"

    if [[ "$target" == "cli" ]]; then
        info "Updating nandoroid-cli..."
        local source_dir=$(get_cli_source_dir)
        
        if [[ -n "$source_dir" && -f "$source_dir/update.sh" ]]; then
            substep "Found CLI source at $source_dir"
            bash "$source_dir/update.sh"
        else
            error "CLI source directory not found. Please re-run the installer via curl."
        fi
        return
    fi

    # Default to shell update if no target or target is 'shell'
    if [[ "$target" == "shell" || -z "$target" ]]; then
        info "Checking for shell updates..."
        local install_dir=$(get_shell_install_dir)
        if [[ -z "$install_dir" ]]; then
            error "Nandoroid Shell installation directory not found. Please run 'nandoroid install' first."
        fi
        
        if [[ -f "$install_dir/update.sh" ]]; then
            info "Running update script from $install_dir..."
            bash "$install_dir/update.sh" all "$channel"
        else
            error "Update script not found in $install_dir."
        fi
        success "Shell update process completed."
    else
        echo "Usage: nandoroid update {shell|cli} [stable|canary]"
    fi
}

cmd_install_shell() {
    info "Installing/Setting up Nandoroid Shell..."
    if command -v curl &> /dev/null; then
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/na-ive/nandoroid-shell/main/install.sh)"
    else
        error "curl is required to download the installer."
    fi
}

cmd_install_shell_deps() {
    source_lib "deps"
    execute_deps_install
}
