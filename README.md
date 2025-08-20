# WhipLaunch
Linux program launcher using whiptail

## Description

WhipLaunch is a user-friendly start menu for the Linux shell, allowing you to quickly access frequently used programs and commands. The menu can be customised using a folder structure with human-readable text files, making it adaptable to any Linux system. It is ideal for beginners, helping them to overcome their fear of entering commands, and for those who prefer to restrict certain processes to a specific working environment. However, it is not intended to replace command input or a complete graphical user interface.

## Installation

Clone the repository and make `whiplaunch.sh` executable. 

```
chmod +x ./whiplaunch.sh
```

TODO: Create installation script.

## Usage

When called, WhipLaunch searches for menu files in the directory `$HOME/.config/whiplaunch/menu` or in its own directory. There are some sample folders and files in the repository that should be found immediately. A menu file consists of configuration sections separated by a blank line. Each configuration section can contain the following fields: 

* Name: Display name of the program or command (not the actual command)
* Description: Short description, displayed to the right.
* Command: The actual command that is called  from the menu entry.
* Arguments: Any type of fixed or dynamic command options. The text between `<` and `>` is recognized as a template and the menu prompts for user input when the command is called.

**Note**: The field names above can be translated into any language. If WhipLaunch is being used in a language other than English, the field names must also be specified in that language, provided they have been translated in the relevant language file. 

## Example

Here is a menu file with some system commands.

```
Name: Top
Description: System monitor
Command: top

Name: Uptime
Description: Display system uptime
Command: uptime

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

## Development

Copyright (C) 2025 Steffen Schultz, released under the terms of the MIT license. 
