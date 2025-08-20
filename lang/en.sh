#!/bin/bash
# WhipLaunch english language file

# Error messages
MSG_ERROR_WHIPTAIL_MISSING="Error: whiptail is not installed."
MSG_ERROR_WHIPTAIL_INSTALL="Install using e.g.: sudo apt install whiptail"
MSG_ERROR_MENUDIR_NOT_EXISTS="Error: Menu directory '%s' doesn't exist."
MSG_ERROR_MAIN_MENU_FAILED="Error while executing main menu."

# Warnings
MSG_WARNING_FILE_NOT_FOUND="Warning: File '%s' not found."
MSG_WARNING_FILE_NOT_READABLE="Warning: File '%s' not readable."
MSG_WARNING_UNKNOWN_FORMAT="Warning: Unknown format on line %d: '%s'"
MSG_WARNING_NO_VALID_ENTRIES="Warning: No valid entries found in '%s'."

# Whiptail UI
UI_TITLE="WhipLaunch"
UI_MENU_PROMPT="Please select:"
UI_BACK_OPTION="..."
UI_BACK_DESCRIPTION="Parent level"
UI_FOLDER_PREFIX="Folder: "
UI_PROGRAMS_PREFIX="Programs from "
UI_OK_BUTTON="OK"
UI_CANCEL_BUTTON="Cancel"

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
MSG_EXIT="Exited WhipLaunch."

# Regex pattern for field names (case-insensitive)
FIELD_NAME_PATTERN="^[Nn]ame:[[:space:]]*"
FIELD_DESC_PATTERN="^[Dd]escription:[[:space:]]*"
FIELD_CMD_PATTERN="^[Cc]ommand:[[:space:]]*"
FIELD_ARGS_PATTERN="^[Aa]rguments:[[:space:]]*"