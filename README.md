# ATMIRAL
Accessible text-based menu interface for running applications on Linux

## Description

ATMIRAL (short for "Accessible text-based menu interface for running applications on Linux") is a user-friendly start menu for the Linux shell, allowing you to quickly access frequently used programs and commands. The menu can be customised using a folder structure with human-readable text files, making it adaptable to any Linux system. It is ideal for beginners, helping them to overcome their fear of entering commands, and for those who prefer to restrict certain processes to a specific working environment. However, it is not intended to replace command input or a complete graphical user interface.

## Installation

Clone the repository and make `install.sh` executable. 

```
chmod +x ./install.sh
```

The following installation options are available: 

* `./install.sh --user`: install for current user.
* `sudo ./install.sh --system`: install system-wide, requires root permissions. 
* `sudo ./install.sh --both`: install system-wide and for current user, requires root permissions. 
* `sudo ./install.sh --uninstall`: uninstall ATMIRAL, could require root permissions. 

You can also run ATMIRAL by calling `./atmiral.sh`  in the script's directory. 

## Usage

### Menu directories

Menu files are found in the following directories, descending priority: 

* Userdefined: call `atmiral <Pfad>`
* In your home folder: `$HOME/.local/share/atmiral/menu/`
* System-wide: `/usr/local/share/atmiral/menu/`
* In the script's directory (last fallback): `./menu/`

### Creating menus

A menu file consists of configuration sections separated by a blank line. Each configuration section can contain the following fields: 

* Name: Display name of the program or command (not the actual command)
* Description: Short description, displayed to the right.
* Command: The actual command that is called  from the menu entry.
* Arguments: Any type of fixed or dynamic command options. The text between `<` and `>` is recognized as a placeholder and the menu prompts for user input when the command is called.

The following placeholders are available to open special dialog boxes: 

* `<File>`: Opens a file selection dialog.
* `<Directory>`: Opens a directory selection.
* `<Password>`: Input box for passwords.

**Note**: The field names and placeholders above can be translated into any language. If ATMIRAL is being used in a language other than English, the field names and placeholders must also be specified in that language, provided they have been translated in the relevant language file. 

### Example

Here is a menu file with some system commands.

```
Name: Top
Description: System monitor
Command: top

# Here we use dialog to print system uptime as a nice message box
Name: Uptime
Description: Display system uptime
Command: dialog --no-lines --title "uptime" --msgbox "$(uptime)" 10 70

Name: Updates
Description: Search for updates
Command: sudo apt update && sudo apt upgrade

# In the following example <Text> is stored as an argument template and will be queried when called.
Name: TTS
Description: Speak entered text
Command: espeak-ng
Arguments: -v en -a 100 -s 300 "<Text>"

# Multiple placeholders are also possible, which are then queried one after the other before the command is called
Name: Service control
Description: Service control
Command: sudo systemctl
Arguments: <Action> <Service>
```

### The user interface

Once you have started ATMIRAL, the files and subfolders that have been created in the appropriate menu directory will be displayed as a two-column list containing the file names and descriptions. You can navigate through these lists using the up and down arrow keys, confirming your selection by pressing Enter. There is an option to return to the parent menu at the top of each list. While ATMIRAL is open, all commands are executed in its environment. This means that, after each command has been executed, you always return to the current menu. Pressing Escape exits the ATMIRAL interface and returns to the normal shell environment.

### Configuration

Some configuration options are available in the file `atmiral.conf`: 

* `ATMIRAL_LANG`: Interface language (language file name without file extension, e.g. `en`). 
* `COMMAND_DEBUG`: Set 1 to turn on command output.

If you prefer the menu to have a dark colour scheme, you will find a sample `.dialogrc` file in this folder which you can copy into your home directory. It contains the colours for dark mode and also sets the `visit_items` option to `ON` to enable better keyboard operation. However, this option is already set in the script when the menu is defined.

## Development

Copyright (C) 2025 Steffen Schultz, released under the terms of the MIT license. 
