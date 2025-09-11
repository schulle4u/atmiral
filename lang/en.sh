#!/bin/bash
# ATMIRAL english language file

# Error messages
MSG_ERROR_DIALOG_MISSING="Error: dialog is not installed."
MSG_ERROR_DIALOG_INSTALL="Install using e.g.: sudo apt install dialog"
MSG_ERROR_MENUDIR_NOT_EXISTS="Error: Menu directory '%s' doesn't exist."
MSG_ERROR_MAIN_MENU_FAILED="Error while executing main menu."

# Warnings
MSG_WARNING_FILE_NOT_FOUND="Warning: File '%s' not found."
MSG_WARNING_FILE_NOT_READABLE="Warning: File '%s' not readable."
MSG_WARNING_UNKNOWN_FORMAT="Warning: Unknown format on line %d: '%s'"
MSG_WARNING_NO_VALID_ENTRIES="Warning: No valid entries found in '%s'."

# Dialog UI
UI_TITLE="ATMIRAL"
UI_FOLDER_TITLE="Folder list"
UI_LIST_TITLE="List contents"
UI_MENU_PROMPT="Please select an item and press enter to confirm, escape to exit ATMIRAL:"
UI_BACK_OPTION="..."
UI_BACK_DESCRIPTION="Parent level"
UI_FOLDER_PREFIX="Folder: "
UI_PROGRAMS_PREFIX="Programs from "
UI_OK_BUTTON="OK"
UI_CANCEL_BUTTON="Cancel"
UI_YES_BUTTON="Yes"
UI_NO_BUTTON="No"

# Error dialogs
UI_ERROR_LOADING_FILE="Error loading file:\n%s"
UI_ERROR_NO_ENTRIES="No valid entries in:\n%s"
UI_ERROR_NO_ENTRIES_DIR="No entries in directory:\n%s"

# Input
UI_INPUT_PROMPT="Please enter '%s':"

# Running
MSG_STARTING_COMMAND="Running: %s"
MSG_SEPARATOR="----------------------------------------"
MSG_COMMAND_SUCCESS="Command executed successfully."
MSG_COMMAND_ERROR="Error while executing command (Exit Code: %d)."
MSG_PRESS_ENTER="Press enter to return..."
MSG_CANCELLED="Aborted."
MSG_EXIT="Exited ATMIRAL."

# Regex pattern for field names (case-insensitive)
FIELD_NAME_PATTERN="^[Nn]ame:[[:space:]]*"
FIELD_DESC_PATTERN="^[Dd]escription:[[:space:]]*"
FIELD_CMD_PATTERN="^[Cc]ommand:[[:space:]]*"
FIELD_ARGS_PATTERN="^[Aa]rguments:[[:space:]]*"

# Placeholders for dialog box selection
PLACEHOLDER_FILE_SELECT="^[Ff]ile"
PLACEHOLDER_DIR_SELECT="^[Dd]irectory"
PLACEHOLDER_PASSWORD_SELECT="^[Pp]assword"

# File Browser
MSG_ERROR_FILE_MISSING="Error: The file command is missing."
UI_FM_TITLE="ATMIRAL file browser"
UI_FM_LIST_TITLE="Folder content"
UI_FM_MENU_PROMPT="Select an item with your arrow keys and use enter to confirm:"
UI_FM_ACTION_PROMPT="Please select an action and press enter to confirm:"
UI_FM_CUSTOM_PROMPT="Please enter command (parameters allowed):"
UI_FM_CUSTOM_ERROR="Error: Input cannot be empty."
UI_FM_FOLDER="Folder"
UI_FM_FILE="File"
UI_FM_FILETYPE="File type: %s"
UI_FM_FILETYPE_UNKNOWN="File type unknown"

# Symbolic Links
UI_SYMLINK_TO_DIRECTORY="Directory link"
UI_SYMLINK_TO_FILE="File link"
UI_SYMLINK_BROKEN="broken Link"
UI_SYMLINK_TO_SPECIAL="special file"
UI_SYMLINK_GENERIC="symbolic link"

# Special files
UI_SPECIAL_CHAR_DEVICE="Character device"
UI_SPECIAL_BLOCK_DEVICE="Block device" 
UI_SPECIAL_NAMED_PIPE="Named Pipe"
UI_SPECIAL_SOCKET="Socket"
UI_SPECIAL_UNKNOWN="special file"
UI_SPECIAL_GENERIC="special file"

UI_FILE_NOT_FOUND="File not found"
UI_FILE_NO_PERMISSION="No read permission"
UI_FILE_TIMEOUT="Timeout while getting file type"
UI_SYMLINK_VALID="Link %s"
UI_SYMLINK_BROKEN="Broken link %s"
UI_SYMLINK_UNREADABLE="Unreadable link"

ACTION_FILE_TITLE="File: %s"
ACTION_AS_TEXT="Open as text"
ACTION_VIEW="View file"
ACTION_PLAY_MEDIA="Play media file"
ACTION_IMAGE="Open image"
ACTION_RUN="Run"
ACTION_RUN_DESCRIPTION="Execute file"
ACTION_CUSTOM="Custom"
ACTION_CUSTOM_DESCRIPTION="Open with custom command"
ACTION_COPY="Copy to"
ACTION_COPY_DESCRIPTION="Copy file"
ACTION_MOVE="Move to"
ACTION_MOVE_DESCRIPTION="Move file"
ACTION_DELETE="Delete"
ACTION_DELETE_DESCRIPTION="Remove file"
ACTION_DELETE_CONFIRM="Delete file '%s'?"
ACTION_INFO="Info"
ACTION_INFO_DESCRIPTION="View file info"
ACTION_CANCEL="Cancel"
ACTION_CANCEL_DESCRIPTION="Close action menu"
INFO_MSG_PATH="Path: %s"
INFO_MSG_TYPE="Type: %s"
INFO_MSG_SIZE="File size: %s"
INFO_MSG_PERMS="Permissions: %s"
