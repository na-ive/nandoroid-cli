# NAnDoroid-cli

The primary command-line interface for the **Nandoroid Shell** ecosystem.

> [!NOTE]  
> **Status: v1.0.0 (Release)**  
> This CLI serves as the unified terminal interface for managing shell lifecycle, panels, styling, and system maintenance.

## Features

Nandoroid CLI provides a modular Bash-based interface to replace complex IPC calls with intuitive commands.

### Shell Lifecycle & Panels

| Feature | Command | Description |
| :--- | :--- | :--- |
| **Run Shell** | `nandoroid run` | Start the Nandoroid Shell environment |
| **Reload** | `nandoroid reload` | Send a reload signal to Quickshell |
| **Debug** | `nandoroid debug` | Run shell in debug mode with verbose output |
| **Logs** | `nandoroid logs` | Stream real-time Quickshell logs |
| **App Launcher** | `nandoroid launcher` | Toggle the App Launcher panel |
| **Spotlight** | `nandoroid spotlight` | Toggle Spotlight search |
| **Notifications** | `nandoroid notifications` | Toggle Notification Center |
| **Quick Settings** | `nandoroid quicksettings` | Toggle Quick Settings panel |
| **System Monitor** | `nandoroid systemmonitor` | Toggle System Monitor |
| **Dashboard** | `nandoroid dashboard` | Toggle the Dashboard |
| **Overview** | `nandoroid overview` | Toggle the Overview panel |
| **Session** | `nandoroid session` | Toggle the Session (Power) menu |

### Spotlight Modes

| Mode | Command | Description |
| :--- | :--- | :--- |
| **Files** | `nandoroid spotlight files` | Open Spotlight in File search mode |
| **Apps** | `nandoroid spotlight apps` | Open Spotlight in App launcher mode |
| **Commands** | `nandoroid spotlight commands` | Open Spotlight in Quick Command mode |
| **Clipboard** | `nandoroid spotlight clipboard` | Open Spotlight in Clipboard history mode |
| **Emoji** | `nandoroid spotlight emoji` | Open Spotlight in Emoji picker mode |

### Region Tools (Screenshots & Recording)

| Action | Command | Description |
| :--- | :--- | :--- |
| **Screenshot** | `nandoroid region screenshot` | Capture a selected screen region |
| **Visual Search** | `nandoroid region search` | Perform a visual search from region |
| **OCR** | `nandoroid region ocr` | Extract text from selected region |
| **Record** | `nandoroid region record` | Record selected region |
| **Record w/ Audio** | `nandoroid region record-audio` | Record region with system audio |

### Styling & Theme

| Feature | Command | Description |
| :--- | :--- | :--- |
| **Wallpaper** | `nandoroid wallpaper` | Open the wallpaper selection panel |
| **Auto-Cycle** | `nandoroid wallpaper cycle {on\|off}` | Toggle wallpaper auto-cycling |
| **Colorscheme** | `nandoroid colorscheme` | Regenerate Material 3 colors from wallpaper |
| **Theme Mode** | `nandoroid theme {dark\|light\|toggle}` | Switch between Dark and Light mode |

### System & Maintenance

| Action | Command | Description |
| :--- | :--- | :--- |
| **Status** | `nandoroid status` | Show current shell and CLI status |
| **Doctor** | `nandoroid doctor` | Check system health and dependencies |
| **Config** | `nandoroid config edit` | Open `config.json` in your default editor |
| **Install Shell** | `nandoroid install` | Full interactive Nandoroid Shell setup |
| **Install Deps** | `nandoroid install deps` | Install all required system dependencies |
| **Update Shell** | `nandoroid update shell` | Update Nandoroid Shell (Stable/Canary) |
| **Update CLI** | `nandoroid update cli` | Update this CLI tool to the latest version |
| **Lock Screen** | `nandoroid lock` | Secure the session using Nandoroid Lock |
| **Reboot** | `nandoroid reboot` | Reboot the system |
| **Poweroff** | `nandoroid poweroff` | Shut down the system |

## Installation

### Method 1: Quick Install (Recommended)

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/na-ive/nandoroid-cli/main/install.sh)"
```

### Method 2: Manual Clone

```bash
git clone https://github.com/na-ive/nandoroid-cli.git
cd nandoroid-cli
./install.sh
```

## Dependencies

- **Bash**: Core execution.
- **Python 3**: JSON configuration management.
- **Git & Curl**: Updates and installation.
- **Quickshell & Matugen**: Required for shell runtime features.

---

_Part of the Nandoroid Ecosystem._
