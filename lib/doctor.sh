#!/bin/bash

# System health checks for Nandoroid Shell

cmd_doctor() {
    info "Running Nandoroid Health Check..."
    
    # 1. Binary checks
    info "Checking binaries..."
    local binaries=(quickshell matugen hyprctl git python3 paru yay)
    for bin in "${binaries[@]}"; do
        if command -v "$bin" &> /dev/null; then
            substep "$bin: \e[32mFound\e[0m"
        else
            substep "$bin: \e[31mNot Found\e[0m"
        fi
    done

    # 2. Font check
    info "Checking fonts..."
    if fc-list | grep -qi "Google Sans Flex"; then
        substep "Google Sans Flex: \e[32mInstalled\e[0m"
    else
        substep "Google Sans Flex: \e[31mNot Found\e[0m"
    fi

    # 3. Venv check
    info "Checking Python venv..."
    local venv_path="$HOME/.local/share/nandoroid/venv"
    if [[ -d "$venv_path" ]]; then
        substep "Venv: \e[32mFound\e[0m"
    else
        substep "Venv: \e[31mNot Found\e[0m"
    fi

    # 4. State file check
    info "Checking installation state..."
    local state_file="$HOME/.config/nandoroid/install_state.json"
    if [[ -f "$state_file" ]]; then
        substep "State file: \e[32mFound\e[0m"
    else
        substep "State file: \e[31mNot Found\e[0m"
    fi

    success "Health check complete. Use 'nandoroid install deps' to fix missing dependencies."
}
