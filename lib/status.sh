#!/bin/bash

# Status reporting for Nandoroid Shell

cmd_status() {
    info "Nandoroid Shell Status"
    
    # 1. Quickshell status
    local qs_pid=$(pgrep -f "quickshell -p $HOME/.config/quickshell/nandoroid" || echo "")
    if [[ -n "$qs_pid" ]]; then
        substep "Quickshell: \e[32mRunning\e[0m (PID: $qs_pid)"
    else
        substep "Quickshell: \e[31mNot Running\e[0m"
    fi

    # 2. Config status
    local config_file="$HOME/.config/nandoroid/config.json"
    if [[ -f "$config_file" ]]; then
        local theme=$(python3 -c "import json; print('Dark' if json.load(open('$config_file'))['appearance']['background']['darkmode'] else 'Light')")
        local auto_cycle=$(python3 -c "import json; print('On' if json.load(open('$config_file'))['appearance']['background']['autoCycleEnabled'] else 'Off')")
        local wallpaper=$(python3 -c "import json; print(json.load(open('$config_file'))['appearance']['background']['wallpaperPath'])")
        
        substep "Theme: $theme"
        substep "Auto-cycle: $auto_cycle"
        substep "Wallpaper: $wallpaper"
    else
        substep "Config: \e[31mNot found\e[0m"
    fi

    # 3. Versions
    substep "CLI Version: $VERSION"
    success "Status check complete."
}
