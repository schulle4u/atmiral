#!/bin/bash
# ATMIRAL german language file

# Error messages
MSG_ERROR_DIALOG_MISSING="Fehler: dialog ist nicht installiert."
MSG_ERROR_DIALOG_INSTALL="Installiere es z. B. mit: sudo apt install dialog"
MSG_ERROR_MENUDIR_NOT_EXISTS="Fehler: Menu-Verzeichnis '%s' existiert nicht."
MSG_ERROR_MAIN_MENU_FAILED="Fehler beim Ausführen des Hauptmenüs."

# Warnings
MSG_WARNING_FILE_NOT_FOUND="Warnung: Datei '%s' nicht gefunden."
MSG_WARNING_FILE_NOT_READABLE="Warnung: Datei '%s' nicht lesbar."
MSG_WARNING_UNKNOWN_FORMAT="Warnung: Unbekanntes Format in Zeile %d: '%s'"
MSG_WARNING_NO_VALID_ENTRIES="Warnung: Keine gültigen Einträge in '%s' gefunden."

# Dialog UI
UI_TITLE="ATMIRAL"
UI_MENU_PROMPT="Bitte wählen:"
UI_BACK_OPTION="..."
UI_BACK_DESCRIPTION="Eine Ebene höher"
UI_FOLDER_PREFIX="Ordner: "
UI_PROGRAMS_PREFIX="Programme aus "
UI_OK_BUTTON="OK"
UI_CANCEL_BUTTON="Abbrechen"

# Error dialogs
UI_ERROR_LOADING_FILE="Fehler beim Laden der Datei:\n%s"
UI_ERROR_NO_ENTRIES="Keine gültigen Einträge in:\n%s"
UI_ERROR_NO_ENTRIES_DIR="Keine Einträge im Verzeichnis:\n%s"

# Input
UI_INPUT_PROMPT="Bitte '%s' eingeben:"

# Running
MSG_STARTING_COMMAND="Starte: %s"
MSG_SEPARATOR="----------------------------------------"
MSG_COMMAND_SUCCESS="Befehl erfolgreich ausgeführt."
MSG_COMMAND_ERROR="Fehler bei der Ausführung des Befehls (Exit-Code: %d)."
MSG_PRESS_ENTER="Drücke Enter um zurückzukehren..."
MSG_CANCELLED="Abgebrochen."
MSG_EXIT="ATMIRAL beendet."

# Regex pattern for field names (case-insensitive)
FIELD_NAME_PATTERN="^[Nn]ame:[[:space:]]*"
FIELD_DESC_PATTERN="^[Bb]eschreibung:[[:space:]]*"
FIELD_CMD_PATTERN="^[Bb]efehl:[[:space:]]*"
FIELD_ARGS_PATTERN="^[Aa]rgumente:[[:space:]]*"

# Placeholders for dialog box selection
PLACEHOLDER_FILE_SELECT="^[Dd]atei"
PLACEHOLDER_DIR_SELECT="^[Vv]erzeichnis"
PLACEHOLDER_PASSWORD_SELECT="^[Pp]asswort"