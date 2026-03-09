#!/bin/bash

# Panel management for Nandoroid Shell

cmd_toggle_panel() {
    local panel="$1"
    info "Toggling $panel panel..."
    if ! command -v quickshell &> /dev/null; then
        error "quickshell not found. Please install it first."
    fi
    quickshell -c nandoroid ipc call "$panel" toggle
    success "$panel toggled."
}

cmd_spotlight() {
    local action="$1"
    if ! command -v quickshell &> /dev/null; then
        error "quickshell not found. Please install it first."
    fi

    case "$action" in
        files|file)
            info "Opening Spotlight in File mode..."
            quickshell -c nandoroid ipc call spotlight open
            # We need to set the query, but IPC might not support it directly if not defined in IpcHandler.
            # However, shell.qml defines GlobalShortcuts that set initialSpotlightQuery.
            # We can use 'quickshell --shortcut <name>' if supported, or rely on IPC if we can extend it.
            # Looking at shell.qml, the spotlight IpcHandler doesn't take arguments.
            # But the GlobalShortcuts do. Let's check if we can trigger them.
            # Actually, we can use 'hyprctl dispatch' for global shortcuts.
            hyprctl dispatch "quickshell:spotlightFiles" ""
            ;;
        apps|app)
            info "Opening Spotlight in App mode..."
            quickshell -c nandoroid ipc call spotlight open
            ;;
        commands|command|cmd)
            info "Opening Spotlight in Command mode..."
            hyprctl dispatch "quickshell:spotlightCommand" ""
            ;;
        clipboard|clip)
            info "Opening Spotlight in Clipboard mode..."
            hyprctl dispatch "quickshell:spotlightClipboard" ""
            ;;
        emoji)
            info "Opening Spotlight in Emoji mode..."
            hyprctl dispatch "quickshell:spotlightEmoji" ""
            ;;
        *)
            cmd_toggle_panel "spotlight"
            ;;
    esac
}

cmd_region() {
    local action="$1"
    case "$action" in
        screenshot) hyprctl dispatch "quickshell:regionScreenshot" "" ;;
        search)     hyprctl dispatch "quickshell:regionSearch" "" ;;
        ocr)        hyprctl dispatch "quickshell:regionOcr" "" ;;
        record)     hyprctl dispatch "quickshell:regionRecord" "" ;;
        record-audio) hyprctl dispatch "quickshell:regionRecordWithSound" "" ;;
        *)
            echo "Usage: nandoroid region {screenshot|search|ocr|record|record-audio}"
            ;;
    esac
}
