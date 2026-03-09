#!/bin/bash

# Dependency management for Nandoroid Shell
# Targets Arch Linux based distributions

CORE_DEPS=(
    "hyprland" "quickshell-git" "qt6-declarative" "qt6-svg" "qt6-wayland"
    "pipewire" "networkmanager" "bluez" "bluez-utils" "libnotify" "polkit"
    "xdg-desktop-portal-hyprland" "xdg-desktop-portal-gtk" "python3"
    "python-virtualenv" "adw-gtk3" "dgop" "brightnessctl" "ddcutil"
    "playerctl" "matugen-bin" "grim" "slurp" "wf-recorder" "imagemagick"
    "ffmpeg" "songrec" "cava" "easyeffects" "hyprpicker" "hyprlock"
    "hyprsunset" "fd" "libqalculate" "jq" "xdg-utils" "wl-clipboard"
    "cliphist" "zenity"
)

FONT_DEPS=(
    "ttf-material-symbols-variable-git"
    "ttf-jetbrains-mono-nerd"
    "noto-fonts-emoji"
)

install_package_manager() {
    if ! command -v paru &> /dev/null && ! command -v yay &> /dev/null; then
        info "Installing paru (AUR helper)..."
        sudo pacman -S --needed --noconfirm base-devel git
        git clone https://aur.archlinux.org/paru.git /tmp/paru
        cd /tmp/paru && makepkg -si --noconfirm
        cd - && rm -rf /tmp/paru
    fi
}

get_aur_helper() {
    if command -v paru &> /dev/null; then
        echo "paru"
    elif command -v yay &> /dev/null; then
        echo "yay"
    else
        echo ""
    fi
}

setup_python_venv() {
    local venv_path="$HOME/.local/share/nandoroid/venv"
    info "Setting up Python venv in $venv_path..."
    mkdir -p "$(dirname "$venv_path")"
    python3 -m venv "$venv_path"
    "$venv_path/bin/pip" install --upgrade pip
    "$venv_path/bin/pip" install "materialyoucolor<3.0.0" kde-material-you-colors
    success "Python venv ready."
}

install_google_sans() {
    if ! fc-list | grep -qi "Google Sans Flex"; then
        info "Installing Google Sans Flex..."
        local font_src="/tmp/google-sans-flex"
        local font_target="$HOME/.local/share/fonts/nandoroid-google-sans-flex"
        rm -rf "$font_src"
        git clone --depth 1 https://github.com/end-4/google-sans-flex.git "$font_src"
        mkdir -p "$font_target"
        cp -r "$font_src"/* "$font_target"/
        rm -rf "$font_src"
        fc-cache -fv
        success "Google Sans Flex installed."
    else
        substep "Google Sans Flex already installed."
    fi
}

execute_deps_install() {
    install_package_manager
    local helper=$(get_aur_helper)
    
    if [[ -z "$helper" ]]; then
        error "No AUR helper found. Please install paru or yay manually."
    fi

    info "Installing core dependencies via $helper..."
    $helper -S --needed --noconfirm "${CORE_DEPS[@]}"
    
    info "Installing font dependencies..."
    $helper -S --needed --noconfirm "${FONT_DEPS[@]}"
    install_google_sans
    
    setup_python_venv
    
    success "All dependencies installed successfully."
}
