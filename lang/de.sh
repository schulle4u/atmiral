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
UI_FOLDER_TITLE="Ordnerliste"
UI_LIST_TITLE="Listeninhalt"
UI_MENU_PROMPT="Bitte einen Eintrag wählen und mit enter bestätigen, Escape zum Beenden von ATMIRAL:"
UI_BACK_OPTION="..."
UI_BACK_DESCRIPTION="Eine Ebene höher"
UI_FOLDER_PREFIX="Ordner: "
UI_PROGRAMS_PREFIX="Programme aus "
UI_OK_BUTTON="OK"
UI_CANCEL_BUTTON="Abbrechen"
UI_YES_BUTTON="Ja"
UI_NO_BUTTON="Nein"
UI_SELECT_BUTTON="Auswählen"
UI_ACTIONS_BUTTON="Aktionen"
UI_EXIT_BUTTON="Beenden"

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

# File Browser
MSG_ERROR_FILE_MISSING="Fehler: Der File-Befehl ist nicht verfügbar."
UI_FM_TITLE="ATMIRAL Dateibrowser"
UI_FM_LIST_TITLE="Ordnerinhalt"
UI_FM_MENU_PROMPT="Bitte einen Eintrag mit den Pfeiltasten wählen und mit Enter bestätigen:"
UI_FM_ACTION_PROMPT="Bitte eine Aktion wählen und mit Enter bestätigen:"
UI_FM_CUSTOM_PROMPT="Bitte Befehl eingeben (Parameter erlaubt):"
UI_FM_CUSTOM_ERROR="Fehler: Das Eingabefeld darf nicht leer sein."
UI_FM_FOLDER="Ordner"
UI_FM_FILE="Datei"
UI_FM_FILETYPE="Dateityp: %s"
UI_FM_FILETYPE_UNKNOWN="Dateityp unbekannt"
UI_FM_NO_SELECTION="Keine Auswahl"

# Symbolic Links
UI_SYMLINK_TO_DIRECTORY="Verzeichnislink"
UI_SYMLINK_TO_FILE="Dateilink"
UI_SYMLINK_BROKEN="defekter Link"
UI_SYMLINK_TO_SPECIAL="spezielle Datei"
UI_SYMLINK_GENERIC="Symbolischer Link"

# Special files
UI_SPECIAL_CHAR_DEVICE="Zeichengerät"
UI_SPECIAL_BLOCK_DEVICE="Blockgerät" 
UI_SPECIAL_NAMED_PIPE="Named Pipe"
UI_SPECIAL_SOCKET="Socket"
UI_SPECIAL_UNKNOWN="Spezielle Datei"
UI_SPECIAL_GENERIC="Spezielle Datei"

UI_FILE_NOT_FOUND="Datei nicht gefunden"
UI_FILE_NO_PERMISSION="Keine Leseberechtigung"
UI_FILE_TIMEOUT="Timeout bei Dateityp-Erkennung"
UI_SYMLINK_VALID="Link %s"
UI_SYMLINK_BROKEN="Defekter Link %s"
UI_SYMLINK_UNREADABLE="Unlesbarer Link"

ACTION_TITLE="%s: %s"
ACTION_OPEN_DIR="Verzeichnis öffnen"
ACTION_AS_TEXT="Mit %s als Text öffnen"
ACTION_VIEW="Mit %s anzeigen"
ACTION_PLAY_MEDIA="Mit %s abspielen"
ACTION_IMAGE="Mit %s anzeigen"
ACTION_RUN="Ausführen"
ACTION_CUSTOM="Öffnen mit"
ACTION_COPY="Kopieren nach"
ACTION_MOVE="Verschieben nach"
ACTION_DELETE="Löschen"
ACTION_DELETE_CONFIRM="%s '%s' wirklich löschen?"
ACTION_INFO="Datei-Info"
ACTION_CANCEL="Abbrechen"
INFO_MSG_PATH="Pfad: %s"
INFO_MSG_TYPE="Typ: %s"
INFO_MSG_SIZE="Dateigröße: %s"
INFO_MSG_PERMS="Berechtigungen: %s"

# Exit codes
EXIT_MSG_INVALID="Ungültiger Exit-Code '%s'. Es muss eine positive Ganzzahl sein."
EXIT_MSG_0="Befehl erfolgreich ausgeführt."
EXIT_MSG_1="Fehler beim Ausführen des Befehls: Allgemeiner Fehler."
EXIT_MSG_2="Fehler: Falsche Verwendung von Argumenten."
EXIT_MSG_126="Fehler: Ungenügende Berechtigung."
EXIT_MSG_127="Fehler: Befehl nicht gefunden."
EXIT_MSG_UNKNOWN="Fehler: Exit-Code '%d'"