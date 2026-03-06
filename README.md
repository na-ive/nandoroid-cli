# nandoroid-cli

The main control script for the **Nandoroid Shell** environment.

> [!NOTE]  
> **Status: UNDER DEVELOPMENT (Coming Soon with v1.1)**  
> This repository is currently in its early planning stages. The CLI will serve as the primary terminal interface for managing your shell lifecycle, themes, and system actions.

## Planned Features

A modular Bash-based interface to replace complex IPC calls with simple commands:

- **Lifecycle**: `nandoroid {run|reload|debug}`
- **Panels**: `nandoroid {spotlight|dashboard|settings}`
- **System**: `nandoroid {reboot|lock|poweroff}`
- **Maintenance**: `nandoroid {update|install-deps}`
- **Styling**: `nandoroid {wallpaper|colorscheme}`
- **Z-Shell/Fish/Bash**: Native shell completions for all commands.

## Tech Stack

- **Language**: Modular Bash (`.sh`)
- **Compatibility**: Designed strictly for Arch Linux-based distributions.
- **Integration**: Full synchronization with `nandoroid-shell` state and OTA update system.

---

_Part of the Nandoroid Ecosystem._
