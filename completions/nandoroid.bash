# Bash completion for nandoroid-cli

_nandoroid_completions() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="run reload debug spotlight dashboard settings launcher notifications quicksettings systemmonitor overview session region reboot lock poweroff update install wallpaper colorscheme version help"

    if [[ ${COMP_CWORD} -eq 1 ]]; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi

    case "${prev}" in
        update)
            COMPREPLY=( $(compgen -W "shell cli stable canary" -- ${cur}) )
            return 0
            ;;
        install)
            COMPREPLY=( $(compgen -W "deps" -- ${cur}) )
            return 0
            ;;
        wallpaper)
            COMPREPLY=( $(compgen -W "cycle" -- ${cur}) )
            return 0
            ;;
        cycle)
            COMPREPLY=( $(compgen -W "on off" -- ${cur}) )
            return 0
            ;;
        spotlight)
            COMPREPLY=( $(compgen -W "files apps commands clipboard emoji" -- ${cur}) )
            return 0
            ;;
        region)
            COMPREPLY=( $(compgen -W "screenshot search ocr record record-audio" -- ${cur}) )
            return 0
            ;;
    esac
}

complete -F _nandoroid_completions nandoroid
