#!/bin/bash

# Styling commands for Nandoroid Shell

cmd_wallpaper() {
    info "Opening wallpaper selection..."
    quickshell -c nandoroid ipc call wallpaper openDesktop
    success "Wallpaper panel opened."
}

cmd_colorscheme() {
    info "Regenerating colorscheme..."
    if ! command -v matugen &> /dev/null; then error "matugen not found."; fi
    
    local wallpaper=$(hyprctl hyprpaper listactive | head -n 1 | awk '{print $NF}')
    [[ -z "$wallpaper" ]] && command -v swww &> /dev/null && wallpaper=$(swww query | head -n 1 | awk '{print $NF}')
    
    if [[ -n "$wallpaper" && -f "$wallpaper" ]]; then
        info "Found active wallpaper: $wallpaper"
        matugen image "$wallpaper"
        success "Colorscheme regenerated."
    else
        error "Could not determine current wallpaper path."
    fi
}

cmd_wallpaper_cycle() {
    local action="$1"
    local config_file="$HOME/.config/nandoroid/config.json"
    [[ ! -f "$config_file" ]] && error "Config not found."

    case "$action" in
        on)
            python3 -c "import json; c=json.load(open('$config_file')); c['appearance']['background']['autoCycleEnabled']=True; json.dump(c, open('$config_file', 'w'), indent=4)"
            success "Auto-cycle turned ON."
            ;;
        off)
            python3 -c "import json; c=json.load(open('$config_file')); c['appearance']['background']['autoCycleEnabled']=False; json.dump(c, open('$config_file', 'w'), indent=4)"
            success "Auto-cycle turned OFF."
            ;;
        *)
            local status=$(python3 -c "import json; print(json.load(open('$config_file'))['appearance']['background']['autoCycleEnabled'])")
            info "Auto-cycle status: $status"
            ;;
    esac
}

cmd_theme() {
    local action="$1"
    local config_file="$HOME/.config/nandoroid/config.json"
    [[ ! -f "$config_file" ]] && error "Config not found."

    case "$action" in
        dark)
            python3 -c "import json; c=json.load(open('$config_file')); c['appearance']['background']['darkmode']=True; json.dump(c, open('$config_file', 'w'), indent=4)"
            success "Theme set to DARK."
            ;;
        light)
            python3 -c "import json; c=json.load(open('$config_file')); c['appearance']['background']['darkmode']=False; json.dump(c, open('$config_file', 'w'), indent=4)"
            success "Theme set to LIGHT."
            ;;
        toggle)
            python3 -c "import json; c=json.load(open('$config_file')); mode=not c['appearance']['background']['darkmode']; c['appearance']['background']['darkmode']=mode; json.dump(c, open('$config_file', 'w'), indent=4)"
            success "Theme toggled."
            ;;
        *)
            local status=$(python3 -c "import json; print('Dark' if json.load(open('$config_file'))['appearance']['background']['darkmode'] else 'Light')")
            info "Current theme: $status"
            ;;
    esac
    # After theme change, we usually need to re-apply colors
    # If the shell is running, it should pick up changes if it watches the file,
    # or we can send a reload signal.
    quickshell --reload
}
