#!/bin/bash

# Panel management for Nandoroid Shell

get_qs_bin() {
    if command -v qs &> /dev/null; then echo "qs"; else echo "quickshell"; fi
}

cmd_toggle_panel() {
    local panel="$1"
    local bin=$(get_qs_bin)
    info "Toggling $panel panel..."
    if ! command -v $bin &> /dev/null; then
        error "$bin not found. Please install it first."
    fi
    $bin -c nandoroid ipc call "$panel" toggle
    success "$panel toggled."
}

cmd_spotlight() {
    local action="$1"
    local bin=$(get_qs_bin)
    if ! command -v $bin &> /dev/null; then
        error "$bin not found."
    fi

    case "$action" in
        files|file)
            info "Opening Spotlight in File mode..."
            $bin -c nandoroid ipc call spotlight open
            hyprctl dispatch "quickshell:spotlightFiles" ""
            ;;
        apps|app)
            info "Opening Spotlight in App mode..."
            $bin -c nandoroid ipc call spotlight open
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
